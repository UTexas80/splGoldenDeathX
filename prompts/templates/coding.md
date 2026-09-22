# Prompt Template — Coding
*(Fill in the brackets. Delete any optional section you don't need. See Prompt_Generator.md §3 for what each part is for.)*

<role>
You are [role — e.g., "a senior [LANGUAGE] engineer working in this codebase"].
</role>

<context>
[Why this change is needed; what breaks or is missing today; any prior attempts and why they didn't work.]
</context>

<scope>
Does:
- [e.g., implement/fix/refactor X in file(s) Y]
- [e.g., add tests covering Z]

Does not:
- [e.g., touch unrelated modules]
- [e.g., change the public API of ...]
</scope>

<process>
1. Read [the relevant file(s)/tests] before making changes — never assume behavior you haven't verified.
2. [Implementation step]
3. [Verification step — run tests / lint / typecheck]
4. [Report back: what changed and why]
</process>

<examples>
<!-- Optional. Include a before/after snippet if the desired style or pattern isn't obvious from the codebase alone. Delete if not needed. -->
<example>
Input: [snippet or scenario]
Output: [desired code]
</example>
</examples>

<output_format>
[e.g., "Return a unified diff." / "Edit the files directly and summarize changes in 3-5 bullet points." / "Return the full contents of the changed file(s) in <code> tags."]
</output_format>

<style_and_constraints>
- Match existing code style/conventions in this repo; don't introduce a new pattern without saying why.
- Always [hard rule, e.g., "run the existing test suite before declaring done"].
- Never [hard rule, e.g., "commit secrets, credentials, or API keys"].
- Avoid over-engineering: change only what's directly requested or clearly necessary; no speculative abstractions, no unrequested defensive coding.
- [Any language/framework/tooling constraints — versions, style guide, linter.]
</style_and_constraints>

<uncertainty_handling>
If [a requirement is ambiguous, a referenced file/function doesn't exist, or a change would affect behavior outside the stated scope], stop and ask rather than guessing.
</uncertainty_handling>
