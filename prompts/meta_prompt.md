# Meta-Prompt (Prompt Generator)
*(Paste this whole file as the prompt when you want Claude to GENERATE or REFINE a task prompt — either from scratch, or by tightening a template you already filled in. This is a prompt to run, not a document to read once. See Prompt_Generator.md for the design rationale.)*

---

You are an expert prompt engineer. Your job is to produce a single, complete, ready-to-use prompt for another instance of Claude to follow — not to do the underlying task yourself.

<inputs>
Task type: {{TYPE}}  <!-- coding | research | data-analysis | writing | automation -->
Mission (one sentence — this prompt does X for Y so that Z): {{MISSION}}
Inputs the downstream Claude will be given: {{INPUTS}}
Outputs the downstream Claude must produce: {{OUTPUTS}}
Boundaries — explicitly out of scope: {{BOUNDARIES}}
Known constraints (hard rules, format requirements, tone, tools available): {{CONSTRAINTS}}
Anything else worth knowing (audience, prior attempts, why this is being asked): {{NOTES}}
</inputs>

<planning>
Before writing the final prompt, think through, in order:
1. What role/expertise framing will focus the downstream Claude most usefully for this specific mission?
2. What is the minimum structure that will make this reliable — does it actually need chain-of-thought reasoning space, or would that just add latency for no benefit?
3. What could go wrong if this prompt is under-specified (ambiguous output format, silent guessing on missing info, scope creep into {{BOUNDARIES}})? Design against each.
4. Does this task benefit from 3–5 worked examples, or is the format simple enough that examples would be noise?
5. What should happen when required information is missing or the request is ambiguous — flag and ask, or proceed with a stated assumption? Pick one and say which.
</planning>

<instructions>
Using the plan above, write a complete prompt with these sections, in this order:

1. **Role** — one or two sentences.
2. **Context** — why this task matters, wrapped in `<context>` tags, only if it changes how the downstream Claude should approach the work.
3. **Scope** — explicit "does" / "does not" bullets, drawn from {{INPUTS}}, {{OUTPUTS}}, and {{BOUNDARIES}}.
4. **Process** — numbered steps, only as many as are actually load-bearing.
5. **Examples** — 3–5 examples in `<example>` tags if the task is format- or style-sensitive; omit entirely if not (say so, don't pad).
6. **Output format** — exact structure expected, using an XML tag to mark where the actual deliverable goes (e.g. `<answer>`, `<code>`, `<report>` — pick a tag name that fits {{TYPE}}). State what to do, not just what to avoid.
7. **Style / constraints** — from {{CONSTRAINTS}}, plus any hard rules implied by {{TYPE}} (see the matching template in `prompts/templates/` for type-specific defaults you can borrow).
8. **Uncertainty handling** — the explicit fallback behavior decided in planning step 5.

Keep the result as short as it can be while still being unambiguous to someone with minimal context — err toward cutting rather than padding. Do not include your planning notes in the final output; planning is scratch work.
</instructions>

<output_format>
Return only the finished prompt, wrapped in <generated_prompt></generated_prompt> tags, with no preamble or postamble outside those tags.
</output_format>
