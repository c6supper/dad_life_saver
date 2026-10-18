# 错题分类体系 / Mistake taxonomy and remediation

Classify **every** extracted mistake into exactly one **primary** type (and an
optional secondary). The classification drives the 改进建议 in the report, so it
must be the *cause*, not the symptom.

> Rule of thumb: ask "what would stop this happening?" If the answer is
> "more careful" the class is wrong — pick a specific one below.

---

## Primary types

### A. 概念不清 / Conceptual gap
**Looks like:** wrong method chosen; cannot start the problem; confuses 相反数 with
倒数; treats `-a` as always negative.
**Tell:** the *approach* is wrong, not the arithmetic. Rewriting the numbers
still produces a wrong answer.
**Remediation:** return to the textbook definition; rebuild with the simplest
possible example; then redo the original from scratch. Do **not** just re-drill
variants — the concept has to be re-taught first.

### B. 法则记错 / Rule misapplied
**Looks like:** `(-3)² = -9`; `去括号` without flipping signs; `移项` without
changing sign; 分数除法 not inverted.
**Tell:** a specific, nameable procedure was misremembered. The student can
usually self-correct when asked "which rule did you use?".
**Remediation:** write the rule out loud from memory, then apply it to 3 trivial
cases before returning to the original. The 变式 should be *trap-restoring*.

### C. 计算错误 / Arithmetic slip
**Looks like:** `7×8=54`; a dropped `−` mid-line; correct method, wrong number.
**Tell:** the *method is visible and correct* in the working; the error is local
and not reproducible on a similar problem.
**Remediation:** do not over-correct this one. Prescribe a checking habit
(验算 / 回代检验), because the fix is process, not knowledge.

### D. 审题错误 / Misread the question
**Looks like:** answered in the wrong unit; missed "不正确的是"; ignored a
condition; computed `x` when asked for `x+1`.
**Tell:** there is usually a correct computation attached to the wrong request.
**Remediation:** teach underlining 关键词 before starting. Variant questions
should change which detail is the trap.

### E. 遗漏讨论 / Incomplete case analysis
**Looks like:** `|a| = 3` gives only `a = 3`; a solution set missing a boundary;
leaving out the `答：` conclusion.
**Tell:** the answer is partly right and the omission is systematic.
**Remediation:** pair each such mistake with a checklist card
(如 `绝对值`、`分类讨论`、`答`). This is the single most common 七上 problem.

### F. 书写/格式不规范 / Presentation
**Looks like:** no `解：`; steps run together; geometry figure unlabelled; unit
missing on the final answer.
**Tell:** deducts 卷面分 or 步骤分 even though the maths is right.
**Remediation:** prescribe a fixed answer template and require the student to
re-copy 2 answers per day until the format is automatic.

### G. 知识遗忘 / Forgotten content
**Looks like:** a topic from an earlier chapter is simply gone; blank response.
**Tell:** the student cannot state the definition at all when asked.
**Remediation:** schedule it into 复习计划 with spaced repetition (day 1, 3, 7).

### H. 时间/策略问题 / Time or strategy
**Looks like:** last 解答题 blank; rushed careless errors concentrated at the end;
spent the whole paper on one hard question.
**Tell:** the errors cluster at the end of the paper, or an otherwise-able
student left a large question empty.
**Remediation:** practice with a timer and a paper-order strategy (skip and
return, mark uncertain items).

---

## Severity rubric

| 等级 | Meaning | Report tag |
|---|---|---|
| 高 | Concept or rule not understood — will recur | `<span class="tag high">高</span>` |
| 中 | Understands, but the habit is unreliable | `<span class="tag mid">中</span>` |
| 低 | One-off slip, no pattern | `<span class="tag low">低</span>` |

Assign **高** whenever the same type appears twice or more on one paper.
A single arithmetic slip is 低; the same slip three times is a 中 habit.

## Reading the distribution

The report's 分类统计 table should be read as a shape, not a score:

- Mostly **A/B** → re-teach the chapter before any drilling.
- Mostly **C/F** → the knowledge is fine; install a checking process.
- Mostly **E** → drill the specific checklist, not general accuracy.
- Mostly **H** → the content is fine; the paper technique is the problem.

Say this explicitly in the 建议 section — it is the most useful sentence in the
whole report.
