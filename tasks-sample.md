---
title: Task List Test
tags: [test, checklist]
---

# Task List Test

Open this file via **Folder…** (or drag-drop in Chrome/Edge) to exercise the
save-back. Toggle a box, then reopen the file from disk — the change should
have persisted.

## Groceries

- [ ] Milk
- [ ] Bread
- [x] Eggs
- [ ] Apples
- [X] Coffee beans (preserves uppercase `X` on re-toggle)

## Today

- [x] Wake up
- [x] Coffee
- [ ] Reply to the email from Anna
- [ ] Push the mdviewer task-list branch
- [ ] Walk the dog

## Nested lists

- [ ] Ship the feature
  - [x] Render checkboxes
  - [x] Wire change handler
  - [ ] Write release notes
  - [ ] Tag the release
    - [ ] Bump version in manifest
    - [ ] Update screenshots
- [ ] Mop the kitchen
- [x] Take out the trash

## Mixed with regular bullets

- [x] First task
- Plain bullet — no checkbox, shouldn't get one
- [ ] Second task
- Another plain bullet
- [x] Third task

## Ordered task list

1. [ ] Draft the PR
2. [x] Self-review
3. [ ] Request reviewers
4. [ ] Merge

## Edge cases (these should *not* become interactive)

The following look like task markers but live inside a fenced code block —
the lexer-based position mapping should skip them, so the count above stays
correct.

```markdown
- [ ] This is sample markdown shown verbatim
- [x] Not a real task
```

And an inline `[ ] not a task` should also be ignored.

## Long list (stress test)

- [ ] Item 01
- [ ] Item 02
- [x] Item 03
- [ ] Item 04
- [ ] Item 05
- [x] Item 06
- [ ] Item 07
- [ ] Item 08
- [ ] Item 09
- [x] Item 10
- [ ] Item 11
- [ ] Item 12
- [ ] Item 13
- [x] Item 14
- [ ] Item 15

---

When you toggle any box above, the viewer flips a single byte in the source
(`[ ]` → `[x]` or vice versa) and writes the whole file back via
`FileSystemFileHandle.createWritable()` after a 150 ms debounce. Watch for the
**Saved** toast at the bottom of the window.
