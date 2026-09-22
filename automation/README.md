# Automation — Prompt Generator CLI
*(Process doc for `generate_prompt.py`. Not something Claude reads as Instructions. See Prompt_Generator.md for the design.)*

## What this is
A small, dependency-light CLI that fills in one of the five templates in `prompts/templates/`, writes the result to `prompts/generated/`, and optionally (a) sends it through `prompts/meta_prompt.md` via the Claude API for refinement, and (b) hands the finished prompt to an external tool of your choice.

This script is generic on purpose — it doesn't assume any particular project layout, language, or downstream tool. Adapt freely.

## Requirements
- Python 3.9+
- `pip install anthropic pyyaml` — only needed if you use `--refine` (API call) or `--answers` (YAML file). The base fill-in-a-template flow needs no dependencies beyond the standard library.

## Setup
1. Copy `config.example.yaml` to `config.yaml` and fill in your values (or set the equivalent environment variables — env vars win if both are set).
2. If using `--refine`, set `ANTHROPIC_API_KEY` in your environment (never commit it — `config.yaml` and `.env` are gitignored).

## Usage
```bash
# Interactive — prompts you for each field
python automation/generate_prompt.py --type coding

# Non-interactive — from an answers file
python automation/generate_prompt.py --type research --answers answers.yaml

# Fill the template, then refine it through the meta-prompt via the API
python automation/generate_prompt.py --type writing --refine

# Fill, refine, and pipe the finished prompt into an external tool
python automation/generate_prompt.py --type automation --refine --run "your-cli-tool-here"
```

## Answers file format
```yaml
mission: "..."
inputs: "..."
outputs: "..."
boundaries: "..."
constraints: "..."
notes: "..."
```
Any field omitted falls back to an interactive prompt unless `--non-interactive` is passed, in which case it's left as a bracketed placeholder for you to fill by hand.

## Output
Generated prompts land in `prompts/generated/<type>_<slug>_<YYYYMMDD>.md`. That folder is gitignored — it's scratch output. Promote a prompt you want to keep by copying it into `prompts/templates/` (as a new reusable template) or into a real Project's `Instructions.md`, and log the change in `Changelog.md` per this template's normal versioning rule.

## The `--run` flag
`--run "<command>"` pipes the finished prompt to `<command>`'s stdin after generation. `<command>` is whatever you point it at — a coding agent CLI, a batch job runner, `pbcopy`/`clip` to just put it on your clipboard, anything that reads stdin. Nothing is hardcoded to a specific vendor's tool; set it in `config.yaml` under `default_run_command` if you use the same one every time.
