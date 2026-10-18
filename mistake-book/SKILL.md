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

# Core Flow
1. Validate if the $1 is a folder and contains the exams' pics.
2. Analyze these pics, extract the mistakes.
3. Generate similar practice sheet of the mistakes, leave the answer blanks.
4. Generate a report summarizing the mistakes and providing suggestions for improvement.
5. Format output into clean pdf.
