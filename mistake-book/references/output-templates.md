# 输出模板 / Output templates

Two separate outputs are always produced. **Never put answers on the practice
sheet** — that is the whole point of the pair.

| Output | Default filename | Purpose |
|---|---|---|
| 练习卷 | `错题练习卷.pdf` | Blank variants for the student to solve |
| 答案与报告 | `答案与报告.pdf` | Answer key + mistake analysis + 建议 |

Write UTF-8 HTML in the output folder, link the stylesheet by **relative** path,
then render with `scripts/render.ps1`. Delete the intermediate `.html` only if
the user asks; keeping it lets them tweak and re-render.

---

## 1. Practice sheet skeleton (`错题练习卷.html`)

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="assets/print.css">
<title>七年级上册 数学 错题练习卷</title>
</head>
<body>

<header class="sheet-header">
  <h1>七年级上册 · 数学 错题练习卷</h1>
  <p class="subtitle">根据错题整理 · 变式练习 · 共 N 题</p>
</header>

<div class="student-bar">
  <span>班级：</span><span>姓名：</span><span>日期：</span><span>用时：</span>
</div>

<h2 class="section">一、选择题</h2>

<div class="question">
  <div class="q-head">
    <span class="q-no">1.</span>
    <span class="q-source">变式自：原卷第 3 题</span>
  </div>
  <p class="q-body math">下列说法正确的是（<span class="blank-box"></span>）</p>
  <ul class="options">
    <li>A. −a 一定是负数</li>
    <li>B. |a| 一定大于 0</li>
    <li>C. 0 的绝对值是 0</li>
    <li>D. 相反数等于本身的数只有 0 和 1</li>
  </ul>
</div>

<h2 class="section">二、填空题</h2>

<div class="question">
  <div class="q-head"><span class="q-no">2.</span></div>
  <p class="q-body math">若 |x − 2| = 5，则 x = <span class="answer-line"></span>。</p>
</div>

<h2 class="section">三、解答题</h2>

<div class="question">
  <div class="q-head">
    <span class="q-no">3.</span>
    <span class="q-source">变式自：原卷第 18 题（去括号符号）</span>
  </div>
  <p class="q-body math">计算：−2(3a − 4b) + 3(a + 2b)</p>
  <div class="workspace tall"></div>
</div>

<footer class="sheet-footer">
  错题练习卷 · 由 mistake-book 生成 · 共 N 题
</footer>

</body>
</html>
```

**Class cheat-sheet**

| Class | Use |
|---|---|
| `.question` | One problem; `page-break-inside: avoid` already set |
| `.q-no` / `.q-source` | Number, and provenance of the variant |
| `.answer-line` | Short inline blank (填空题) |
| `.blank-box` | Bracket box for 选择题 |
| `.workspace.short` / `.workspace.tall` | 解答区 with dashed box (70px / 130px) |
| `.options` | Flex list of A/B/C/D choices |
| `.math` | Serif/Cambria Math for formulas |
| `.page-break` | Force a new page |

---

## 2. Report skeleton (`答案与报告.html`)

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="assets/report.css">
<title>错题报告与答案</title>
</head>
<body>

<header class="report-header">
  <h1>七年级上册 · 数学 错题分析报告</h1>
  <p class="subtitle">试卷来源：IMG_2026xxxx.jpg 等 14 张 · 共整理 12 道错题</p>
</header>

<h2 class="section">一、总体情况</h2>
<div class="stats">
  <div class="stat"><span class="label">错题数</span><span class="value">12</span></div>
  <div class="stat"><span class="label">概念/法则类</span><span class="value">5</span></div>
  <div class="stat"><span class="label">习惯类</span><span class="value">7</span></div>
</div>

<h2 class="section">二、错误分类统计</h2>
<table>
  <thead>
    <tr><th>类型</th><th class="num">数量</th><th class="num">占比</th><th>分布</th><th class="num">等级</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>遗漏讨论</td><td class="num">4</td><td class="num">33%</td>
      <td><div class="bar"><span style="width:33%"></span></div></td>
      <td class="num"><span class="tag high">高</span></td>
    </tr>
    <tr>
      <td>计算错误</td><td class="num">3</td><td class="num">25%</td>
      <td><div class="bar"><span style="width:25%"></span></div></td>
      <td class="num"><span class="tag mid">中</span></td>
    </tr>
  </tbody>
</table>

<h2 class="section">三、逐题分析与答案</h2>

<div class="question-block">
  <h3 class="item">第 3 题（原卷）· 遗漏讨论 · 得 3/6 分</h3>
  <div class="wrong"><span class="label-inline">错解：</span>由 |a| = 3 得 a = 3</div>
  <div class="correct"><span class="label-inline">正解：</span>a = 3 或 a = −3</div>
  <div class="advice"><span class="label-inline">原因：</span>绝对值表示数轴上的距离，正负两侧各有一个解，需分类讨论。</div>
</div>

<h2 class="section">四、练习卷答案</h2>
<table>
  <thead><tr><th class="num">题号</th><th>答案</th><th>考查点</th></tr></thead>
  <tbody>
    <tr><td class="num">1</td><td>C</td><td>绝对值的意义</td></tr>
    <tr><td class="num">2</td><td>x = 7 或 x = −3</td><td>绝对值的分类讨论</td></tr>
    <tr><td class="num">3</td><td>−3a + 14b</td><td>去括号与合并同类项</td></tr>
  </tbody>
</table>

<h2 class="section">五、改进建议与复习计划</h2>
<div class="advice">
  <p>错误集中在<b>遗漏讨论</b>（33%）与<b>计算错误</b>（25%），说明概念本身基本掌握，
  但“绝对值要分正负”这一检查习惯尚未建立。</p>
</div>
<ul class="tight">
  <li>每日 2 题绝对值分类讨论专项，做完后强制写“分两种情况”。</li>
  <li>打草稿时把符号单独写一行，做完回代检验。</li>
  <li>三天后重做本卷错题，一周后再做一遍变式。</li>
</ul>

</body>
</html>
```

**Report sections, in order** (keep this order — it is what a parent expects):

1. 总体情况 — stat cards
2. 错误分类统计 — distribution table with bars and severity tags
3. 逐题分析与答案 — per-mistake 错解 / 正解 / 原因
4. 练习卷答案 — answer key (this is the requested "answer")
5. 改进建议与复习计划 — actionable, dated

---

## 3. Rendering

From the skill base directory, with outputs in the exam folder:

```powershell
# both outputs, plus PNG previews for a quick look
$skill = Join-Path $env:USERPROFILE ".config\opencode\skills\mistake-book"

powershell -NoProfile -ExecutionPolicy Bypass -File "$skill\scripts\render.ps1" `
  -Html ".\错题练习卷.html" -Pdf ".\错题练习卷.pdf" -Png

powershell -NoProfile -ExecutionPolicy Bypass -File "$skill\scripts\render.ps1" `
  -Html ".\答案与报告.html" -Pdf ".\答案与报告.pdf" -Png
```

`-ExecutionPolicy Bypass` is required — Windows ships with the policy set to
`Restricted`, which blocks `.ps1` files outright. Use `-Html` / `-Pdf`, never
`-Input` / `-Output` (those names collide with PowerShell's automatic variables).

Pass `-Png` when the user will want to eyeball the result in the Review pane
without opening a PDF reader. Non-ASCII paths are safe — the script renders into
an ASCII temp folder and moves the result into place.
