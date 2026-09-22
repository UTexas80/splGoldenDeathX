#!/usr/bin/env python3
"""
Prompt Generator CLI — fills a type-specific template from prompts/templates/,
writes it to prompts/generated/, and optionally refines it through the
meta-prompt (prompts/meta_prompt.md) via the Claude API and/or hands it off
to an external tool.

Generic by design: no project-specific assumptions. See automation/README.md
and Prompt_Generator.md for the full design.
"""

import argparse
import datetime
import os
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
TEMPLATES_DIR = REPO_ROOT / "prompts" / "templates"
META_PROMPT_PATH = REPO_ROOT / "prompts" / "meta_prompt.md"
CONFIG_PATH = REPO_ROOT / "automation" / "config.yaml"

TYPE_TO_TEMPLATE = {
    "coding": "coding.md",
    "research": "research.md",
    "data-analysis": "data_analysis.md",
    "writing": "writing.md",
    "automation": "automation.md",
}

FIELDS = ["mission", "inputs", "outputs", "boundaries", "constraints", "notes"]

FIELD_PROMPTS = {
    "mission": "Mission (one sentence: this does X for Y so that Z)",
    "inputs": "Inputs the downstream Claude will be given",
    "outputs": "Outputs it must produce",
    "boundaries": "Explicitly out of scope",
    "constraints": "Hard rules / format requirements / tone",
    "notes": "Anything else worth knowing (optional)",
}


def load_config():
    config = {
        "anthropic_api_key": os.environ.get("ANTHROPIC_API_KEY", ""),
        "model": "claude-sonnet-4-5",
        "default_run_command": "",
        "output_dir": "prompts/generated",
    }
    if CONFIG_PATH.exists():
        try:
            import yaml  # type: ignore

            with open(CONFIG_PATH) as f:
                file_config = yaml.safe_load(f) or {}
            for key, value in file_config.items():
                if key == "anthropic_api_key" and os.environ.get("ANTHROPIC_API_KEY"):
                    continue  # env var wins
                if value:
                    config[key] = value
        except ImportError:
            print("Note: pyyaml not installed; ignoring config.yaml. "
                  "pip install pyyaml to use it.", file=sys.stderr)
    return config


def slugify(text, max_len=40):
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return slug[:max_len] or "untitled"


def collect_answers(args, answers_file):
    answers = {}
    if answers_file:
        try:
            import yaml  # type: ignore

            with open(answers_file) as f:
                answers = yaml.safe_load(f) or {}
        except ImportError:
            print("pyyaml is required to use --answers. "
                  "pip install pyyaml", file=sys.stderr)
            sys.exit(1)

    for field in FIELDS:
        if answers.get(field):
            continue
        if args.non_interactive:
            answers[field] = f"[{field.upper()} — fill in]"
            continue
        prompt_text = FIELD_PROMPTS[field]
        try:
            value = input(f"{prompt_text}: ").strip()
        except EOFError:
            value = ""
        answers[field] = value or f"[{field.upper()} — fill in]"
    return answers


def fill_template(template_text, answers):
    """Best-effort fill: replaces the bracketed placeholder lines in the
    template's own sections with the corresponding answer, where a direct
    match exists. Fields with no direct template slot (e.g. constraints
    feeding into 'style_and_constraints') are appended as a reference block
    at the top so nothing the user typed is lost."""
    header = "\n".join(
        f"<!-- {field}: {value} -->" for field, value in answers.items() if value
    )
    return f"{header}\n\n{template_text}"


def write_output(filled_text, prompt_type, mission, output_dir):
    output_dir_path = REPO_ROOT / output_dir
    output_dir_path.mkdir(parents=True, exist_ok=True)
    date_str = datetime.date.today().strftime("%Y%m%d")
    slug = slugify(mission)
    out_path = output_dir_path / f"{prompt_type.replace('-', '_')}_{slug}_{date_str}.md"
    out_path.write_text(filled_text)
    return out_path


def refine_with_meta_prompt(filled_text, prompt_type, answers, config):
    try:
        import anthropic  # type: ignore
    except ImportError:
        print("The 'anthropic' package is required for --refine. "
              "pip install anthropic", file=sys.stderr)
        sys.exit(1)

    if not config["anthropic_api_key"]:
        print("No API key found. Set ANTHROPIC_API_KEY or anthropic_api_key "
              "in automation/config.yaml.", file=sys.stderr)
        sys.exit(1)

    meta_prompt = META_PROMPT_PATH.read_text()
    filled_meta_prompt = meta_prompt.replace("{{TYPE}}", prompt_type)
    for field in FIELDS:
        filled_meta_prompt = filled_meta_prompt.replace(
            f"{{{{{field.upper()}}}}}", answers.get(field, "")
        )

    client = anthropic.Anthropic(api_key=config["anthropic_api_key"])
    response = client.messages.create(
        model=config["model"],
        max_tokens=4096,
        messages=[{"role": "user", "content": filled_meta_prompt}],
    )
    text = "".join(
        block.text for block in response.content if getattr(block, "type", "") == "text"
    )
    match = re.search(r"<generated_prompt>(.*?)</generated_prompt>", text, re.DOTALL)
    return match.group(1).strip() if match else text


def run_downstream(command, text):
    print(f"Piping generated prompt to: {command}", file=sys.stderr)
    subprocess.run(command, shell=True, input=text, text=True, check=True)


def main():
    parser = argparse.ArgumentParser(description="Generate a task prompt from a template.")
    parser.add_argument("--type", required=True, choices=TYPE_TO_TEMPLATE.keys())
    parser.add_argument("--answers", help="Path to a YAML answers file.")
    parser.add_argument("--non-interactive", action="store_true",
                         help="Don't prompt for missing fields; leave placeholders.")
    parser.add_argument("--refine", action="store_true",
                         help="Send the filled template through the meta-prompt via the Claude API.")
    parser.add_argument("--run", help="Command to pipe the finished prompt into (overrides config default).")
    args = parser.parse_args()

    config = load_config()
    template_path = TEMPLATES_DIR / TYPE_TO_TEMPLATE[args.type]
    if not template_path.exists():
        print(f"Template not found: {template_path}", file=sys.stderr)
        sys.exit(1)

    answers = collect_answers(args, args.answers)
    template_text = template_path.read_text()

    if args.refine:
        final_text = refine_with_meta_prompt(template_text, args.type, answers, config)
    else:
        final_text = fill_template(template_text, answers)

    out_path = write_output(final_text, args.type, answers.get("mission", "untitled"),
                             config["output_dir"])
    print(f"Wrote {out_path.relative_to(REPO_ROOT)}")

    run_command = args.run or config.get("default_run_command")
    if run_command:
        run_downstream(run_command, final_text)


if __name__ == "__main__":
    main()
