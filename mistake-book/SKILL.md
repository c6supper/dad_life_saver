---
name: mistake-book
description:  Aim to let my daughter track, analyze, and learn from errors rather than forgetting them. Analyze the pics of her exams, collect mistakes , generate report & similar practice sheet & answer.The exams are in Chinese. There are two outputs, one is similar practice sheet of the mistake, the other is the answer and report. The report is a summary of mistakes ,which include classifying of the mistakes, suggestions for improvement. The answer is the correct answers to the practice sheet.
license: Apache-2.0
compatibility: opencode, deepseek V4 flash
metadata:
  author: c6supper.github.io
  version: "1.0.0"
  domain: parenting, education, learning, self-improvement
  triggers: 
    - exam analysis
    - mistake tracking
    - learning improvement
  role: parent
  scope: exam analysis, mistake tracking, learning improvement
  output-format: pdf
  related-skills: 
    - mistake analysis
    - exam review
    - learning improvement
    - error tracking
---

# mistake-book

Turn photographs of a Chinese exam into a **mistake report** and a matching
**blank practice sheet**, delivered as clean PDFs.

All paths below are relative to this skill's base directory (the folder
containing this `SKILL.md`).

## Inputs

One folder containing the exam photos (`*.jpg` / `*.png`). Typically one subject.
Read every page before analysing — the last pages often hold the 解答题 where
most marks are lost.

## Outputs — always exactly two PDFs

| File | Contents |
|---|---|
| `错题练习卷.pdf` | Blank 变式题. **No answers.** |
| `答案与报告.pdf` | Answer key + 分类统计 + 逐题分析 + 改进建议 |

Write them into the same folder as the photos.

## Core Flow

1. **Validate.** Confirm the argument is a folder and that it contains images.
   If it does not, say so and stop — do not invent an exam.
2. **Read the photos.** Transcribe each question and the student's answer.
   Note the marks lost (`得 3/6 分`) on 计算题/解答题, not just right/wrong.
3. **Extract and classify the mistakes.** Read
   `references/mistake-taxonomy.md` first. Assign each mistake one primary type
   (概念不清 / 法则记错 / 计算错误 / 审题错误 / 遗漏讨论 / 书写不规范 /
   知识遗忘 / 时间策略) and a severity (高/中/低). Attach a 七上 topic from the
   knowledge map in `references/exam-conventions.md`.
4. **Design the 变式题.** Read the variant rules in
   `references/exam-conventions.md` §6. Include at least one *trap-restoring*
   variant per mistake. Keep the practice sheet answer-free.
5. **Write the report.** Follow the section order and generation rules in
   `references/exam-conventions.md` §7 and the taxonomy's severity rubric.
   Address the parent in Chinese, in the third person (`孩子`).
6. **Emit HTML.** Use the skeletons in `references/output-templates.md` and link
   `assets/print.css` (practice sheet) or `assets/report.css` (report) by
   relative path.
7. **Render to PDF.** Use `scripts/render.ps1` — see below.
8. **Present.** Give the two output paths, plus a 2–3 sentence summary of the
   headline finding (e.g. "错题集中在遗漏讨论,建议先补分类讨论的习惯").

## Rendering

`scripts/render.ps1` drives the Chromium engine already present in Edge/Chrome.
No installs required. It renders into an ASCII temp folder and then moves the
result, so Chinese paths are safe.

```powershell
$skill = Join-Path $env:USERPROFILE ".config\opencode\skills\mistake-book"

# Windows blocks .ps1 files by default, so always launch through a child
# PowerShell with -ExecutionPolicy Bypass.
# Parameters are -Html / -Pdf. Never use -Input / -Output: those names collide
# with PowerShell's automatic $Input / $Output variables and bind empty.
powershell -NoProfile -ExecutionPolicy Bypass -File "$skill\scripts\render.ps1" `
  -Html ".\错题练习卷.html" -Pdf ".\错题练习卷.pdf" -Png

powershell -NoProfile -ExecutionPolicy Bypass -File "$skill\scripts\render.ps1" `
  -Html ".\答案与报告.html" -Pdf ".\答案与报告.pdf" -Png
```

- `-Png` also writes a preview image — useful for checking the layout visually.
- `-TimeoutSeconds` (default 90), `-PngWidth`, and `-Browser <path>` are available if needed.
- Chinese paths are safe; the script renders in an ASCII temp folder and then
  moves the result into place.
- **Verify before reporting success.** Read the PNG preview back, or at minimum
  confirm the script printed a `PDF :` line with a plausible byte count.

## Reference files

| File | Read it when |
|---|---|
| `references/mistake-taxonomy.md` | Classifying mistakes; choosing severity; writing 建议 |
| `references/exam-conventions.md` | Marking schemes, deduction points, 七上 knowledge map, 变式 design, report tone |
| `references/output-templates.md` | Building the two HTML documents; CSS class cheat-sheet |

## Quality bar

- Every mistake is classified with a *cause*, never "粗心" on its own.
- Every practice question maps to a specific original mistake, and the mapping
  is stated (`.q-source`).
- Answers appear only in the report.
- Chinese renders as real glyphs, not boxes — verify with `-Png`.
- The 建议 section names a concrete, repeated action, not reassurance.
