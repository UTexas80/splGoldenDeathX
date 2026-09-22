# Naming Convention

## Phases
Use zero-padded integers with optional lettered sub-phases:

- `Phase01`, `Phase02`, `Phase03` … (not `Phase1` — zero-padding keeps alphabetical sort correct past 9)
- Sub-phases: `Phase01.a`, `Phase01.b` for sequential steps within one phase
- Human-facing docs/meetings can use plain `Phase 1` — reserve the zero-padded form for filenames and anything that gets sorted

## File versions
- `filename_v1.md`, `filename_v2.md` — never overwrite; always increment
- Dated snapshots: `Handoff_YYYYMMDD.md` (ISO order sorts correctly)
- One-line changelog entry per version, in `Changelog.md`, format:
  `v2 — 2026-09-04 — added uncertainty rule for missing task status`

## Files vs. Connectors (from Level 4 of the curriculum)
- If it changes less than weekly → a versioned file
- If it changes daily/live → a connector, not a re-uploaded file

## General rule
If you can't tell two files apart by name alone without opening them, the name is wrong.
