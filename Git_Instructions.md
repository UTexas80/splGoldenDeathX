# Git Instructions
*(Reference for setting up and maintaining git version control on any local project folder — e.g. project-template, valueline-options-strategy. This is a process doc for you, not something Claude reads as Instructions.)*

## One-time setup (per new folder)

1. **Navigate to the folder**
   `cd /path/to/folder`
   Confirm with `pwd`.

2. **Set your git identity** (only if you've never used git on this machine before)
   `git config --global user.name "Your Name"`
   `git config --global user.email "you@example.com"`

3. **Initialize the repo**
   `git init`
   Creates a hidden `.git` folder. Don't edit it directly — git manages it. This is a one-time step per folder, never repeated.

4. **Add a .gitignore for macOS clutter**
   `echo ".DS_Store" > .gitignore`

5. **Check what git sees**
   `git status`
   All files should show as "Untracked."

6. **Stage everything**
   `git add .`
   Re-run `git status` — files should now show as "Changes to be committed."

7. **Make the baseline commit**
   `git commit -m "v1 — baseline [folder name] files"`

8. **Tag the milestone**
   `git tag v1.0`
   Verify with `git log --oneline` and `git tag`.

If `git` isn't installed, any git command will prompt macOS to offer the Xcode Command Line Tools — accept, then re-run.

---

## Ongoing workflow (every time you make a change)

**Never leave changes staged-but-uncommitted.** Staging (`git add`) is a queue, not a saved snapshot — only a commit is permanent and recoverable. If you've run `git add`, finish with `git commit` in the same sitting.

Every time you edit a tracked file:

```bash
git add .
git commit -m "vX — [describe the change]"
```

Whenever you hit a stable milestone worth naming:

```bash
git tag vX.0
```

**Commit message convention:** tie the message to the corresponding `Changelog.md` entry, so git history and the changelog never drift apart — e.g. `git commit -m "v3 — added mode-based Instructions structure"`.

---

## Quick reference

| Command | What it does | How often |
|---|---|---|
| `git init` | Creates the repo | Once, ever, per folder |
| `git add .` | Stages changes | Every commit |
| `git commit -m "..."` | Saves a permanent snapshot | Every commit |
| `git tag vX.0` | Marks a named milestone | At stable checkpoints |
| `git status` | Shows what's staged/unstaged | Anytime, to check state |
| `git log --oneline` | Shows commit history | Anytime, to review history |
| `git diff` | Shows uncommitted changes | Anytime, before staging |

## Sharing later (not required now)
When/if you want a remote copy (GitHub, backup, collaboration):
```bash
git remote add origin <url>
git push -u origin main
```
This doesn't require redoing `git init` — it just points your existing history at a remote.
