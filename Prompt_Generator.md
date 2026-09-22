# Prompt Generator
*(Companion system to Instructions.md / Project_Instructions.md. This is the annotated source — read this to understand the design, then use `prompts/meta_prompt.md` + `automation/generate_prompt.py` day to day.)*

**Current version:** v1
**Last updated:** 2026-09-06

---

## 1. Mission
Produce well-structured, on-demand prompts — for coding, research, data analysis, writing, and automation tasks — without hand-writing a new one from scratch each time, by combining a reusable meta-prompt with type-specific templates and a small CLI.

## 2. Inputs / Outputs
- Inputs: a prompt `TYPE` (`coding` / `research` / `data-analysis` / `writing` / `automation`), a one-sentence mission, and the 4-part scoping (mission / inputs / outputs / boundaries) for the task at hand
- Outputs: a complete, ready-to-paste prompt file in `prompts/generated/`, built from the matching template in `prompts/templates/` and (optionally) refined by Claude via `prompts/meta_prompt.md`

## 3. Design

### Why a meta-prompt + templates, not one giant prompt
A single generic prompt that tries to cover coding, research, data analysis, writing, and automation ends up vague in every direction. Instead:

- **`prompts/meta_prompt.md`** is the reusable *generator* — it knows how to turn a short task description into a complete, well-formed prompt, the same way Anthropic's own prompt generator does (see references below). You run this when you need something the five templates don't already cover, or when you want Claude to flesh out a filled-in template into a sharper final version.
- **`prompts/templates/*.md`** are five pre-built starting points, one per task type, already structured with the template's Instructions anatomy (Role / Scope / Process / Output format / Style / Constraints / Uncertainty handling) so most requests need only the bracketed placeholders filled in — no meta-prompt round-trip required.
- **`automation/generate_prompt.py`** is the CLI that ties them together: pick a type, answer a few prompts (or pass an answers file), get a filled `.md` file in `prompts/generated/`, optionally run through the meta-prompt for polish, optionally hand off to an external tool.

### How this maps to the template's own conventions
Every generated prompt uses the same anatomy as `Instructions.md`: Role, Scope, Process, Output format, Style/tone, Constraints, Uncertainty handling. The four-part scoping (mission / inputs / outputs / boundaries) is the same one used in `Project_Instructions.md` §1–2. Nothing new to learn — this system just automates filling that shape in for one-off task prompts instead of whole-Project instructions.

### Best-practice techniques baked into the templates and meta-prompt
(See `Test-Suite-Log.md` for how to validate a generated prompt once you're using it for real.)

- **Role prompting** — every template opens with an explicit role.
- **XML tags** — instructions, context, examples, and input are each wrapped in a distinct tag so Claude doesn't conflate them.
- **Multishot examples** — a 3–5 example slot in each template (relevant, diverse, tagged with `<example>`), not required but strongly recommended for anything format-sensitive.
- **Explicit output-format control** — templates say what *to* do ("write in prose"), not just what to avoid.
- **Chain-of-thought slot** — a marked space to think before answering, used only where the task actually needs multi-step reasoning (per the "minimum necessary structure" principle below).
- **Uncertainty handling** — every template ends with an explicit fallback instruction, same as `Instructions.md`.
- **Minimum necessary structure** — start with the plain template; reach for `meta_prompt.md` and heavier techniques (chain of thought, prefilling, prompt chaining) only when the plain version doesn't hold up under testing. Longer and more elaborate is not automatically better.

## 4. The five prompt types

| Type | Template | Typical use |
|---|---|---|
| Coding | `prompts/templates/coding.md` | Implement/fix/refactor a specific piece of code |
| Research | `prompts/templates/research.md` | Investigate a question, synthesize sources |
| Data analysis | `prompts/templates/data_analysis.md` | Explore/clean/model a dataset, answer a data question |
| Writing | `prompts/templates/writing.md` | Draft a document in a specific voice/format |
| Automation | `prompts/templates/automation.md` | Script or agentic task that takes actions, not just produces text |

## 5. Workflow

1. Run `automation/generate_prompt.py --type <type>` (or fill the template by hand — the CLI is a convenience, not a requirement).
2. Answer the prompted fields (mission, inputs, outputs, boundaries, constraints) or pass `--answers path/to/answers.yaml`.
3. The script fills the matching template and writes it to `prompts/generated/<type>_<slug>_<date>.md`.
4. Optional: add `--refine` to pipe the filled template through `prompts/meta_prompt.md` (requires an API key — see `automation/README.md`) for Claude to tighten wording, add examples, or flag missing pieces.
5. Optional: add `--run "<command>"` to pipe the finished prompt straight into an external CLI tool (a coding agent, a batch runner — whatever `<command>` reads from stdin).
6. Use the generated prompt. If you'll reuse it, promote it: copy the finished file out of `prompts/generated/` into `prompts/templates/` (or into the target Project's own `Instructions.md`) and log the change in `Changelog.md`, same as any other template file.
7. For a prompt that's becoming a real recurring Instructions set (not a one-off task), graduate it into a full Project using this template's normal flow (`Project_Instructions.md` → `Instructions.md`), not this system — the prompt generator is for one-off/ad hoc task prompts, not Project-level instructions.

## 6. Integration notes — merging into an existing repo layout
This template is intentionally flat. If the Project you apply it to already has its own structure (source code, data, notebooks, docs, etc. — from a language-specific scaffolding convention or otherwise), add `prompts/` and `automation/` as siblings to that structure rather than nesting them inside it:

```
[project-root]/
├── [existing source folder(s)]/
├── [existing data folder(s)]/
├── [existing docs folder(s)]/
├── prompts/
│   ├── meta_prompt.md
│   ├── templates/
│   └── generated/          # gitignored — treat as scratch output
├── automation/
│   ├── generate_prompt.py
│   └── config.example.yaml
├── Instructions.md
├── Project_Instructions.md
├── Prompt_Generator.md
└── ... (rest of the standard template files)
```

`prompts/generated/` is scratch output, not source of truth — gitignore it (already done in this template's `.gitignore`) and only commit a generated prompt once you've promoted it per §5 step 6.

## 7. Evaluation
Treat a generated prompt like any other Instructions version: run it against `Test-Suite-Log.md`-style cases (happy path, missing-data case, ambiguous request, out-of-scope request, format-stress case) before relying on it, and prefer having a second pass grade outputs on a simple scale rather than eyeballing a single run. Compare candidate versions side by side rather than sequentially trusting whichever you tried last.

## 8. References
- Anthropic, "Evaluate your prompts" — https://claude.com/blog/evaluate-prompts
- Anthropic, "Introducing the prompt generator" — https://claude.com/blog/prompt-generator
- Anthropic docs, "Prompt engineering overview" — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
- Anthropic, "Best practices for prompt engineering" — https://claude.com/blog/best-practices-for-prompt-engineering
- Anthropic docs, "Claude prompting best practices" — https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

---

## Version history
| Version | Date | Change | Reason |
|---|---|---|---|
| v1 | 2026-09-06 | Initial design — meta-prompt, 5 templates, CLI | Requested prompt-generator system, generalized into the template per this Project's scope rules |
