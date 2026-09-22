# prompts/
*(See ../Prompt_Generator.md for the full design. This folder holds the generator's inputs and scratch outputs.)*

- `meta_prompt.md` — the reusable prompt-generator prompt (run this via `automation/generate_prompt.py --refine`, or paste it directly).
- `templates/` — five pre-built prompt templates (coding, research, data-analysis, writing, automation), each using this template's Instructions anatomy. Fill in the brackets directly, or use the CLI.
- `generated/` — CLI output. Gitignored, scratch only. Promote anything worth keeping into `templates/` (as a new reusable template) or into a real Project's `Instructions.md`, and log it in `../Changelog.md`.
