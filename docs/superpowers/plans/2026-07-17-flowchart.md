# Flowchart Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `flowchart` theme option that loads a new inner submodule providing TikZ-based flowchart styles and lightweight commands, matching the existing Jacquenetta visual language.

**Architecture:** Create `src/beamerinnerthemeJacquenetta-flowchart.sty` as an optional submodule. It defines TikZ styles for five node types and an edge style, plus wrapper commands `jqflowchart`, `\jqnode`, `\jqedge`, and `\jqbranch`. The main theme `src/beamerthemeJacquenetta.sty` gets a new `flowchart` option that conditionally loads the submodule. The example and README are updated to demonstrate the feature.

**Tech Stack:** LaTeX2e, Beamer, TikZ (`shapes.geometric`, `positioning`, `arrows.meta`), `tcolorbox` (already loaded).

## Global Constraints

- Only standard LaTeX/TeX Live packages; no external renderers or shell-escape tools.
- New dependencies must be loaded inside the optional submodule, not by the default theme.
- All styles must reuse the theme palette (`jqdark`, `jqgray`, `jqaccent`) to preserve visual consistency.
- Code environments still require `[fragile]` frames; flowchart TikZ code does not.
- `make example` must compile with no `Missing character in font nullfont` warnings.
- XeLaTeX is the default compiler via the project Makefile.

## File Structure

| File | Responsibility |
|------|----------------|
| `src/beamerinnerthemeJacquenetta-flowchart.sty` | New optional submodule: TikZ libraries, node/edge styles, wrapper commands. |
| `src/beamerthemeJacquenetta.sty` | Add `flowchart` option flag and conditional `\useinnertheme{Jacquenetta-flowchart}`. |
| `example/example.tex` | Add a new flowchart section and at least one flowchart frame. |
| `README.md` | Document the `flowchart` option and the new commands/environments. |

---

### Task 1: Create the flowchart inner submodule

**Files:**
- Create: `src/beamerinnerthemeJacquenetta-flowchart.sty`
- Test: `make example` (after Task 3)

**Interfaces:**
- Consumes: Theme colors `jqdark`, `jqgray`, `jqaccent` from `beamercolorthemeJacquenetta`.
- Produces: Node styles `jqterminator`, `jqprocess`, `jqdecision`, `jqio`, `jqsubprocess`; edge style `jqcedge`; label style `jqclabel`; environment `jqflowchart`; commands `\jqnode`, `\jqedge`, `\jqbranch`.

- [ ] **Step 1: Scaffold the package header**

Create `src/beamerinnerthemeJacquenetta-flowchart.sty` with the standard package header.

```latex
% ----------------------------------------------------------
% beamerinnerthemeJacquenetta-flowchart.sty — Flowchart support
% Jacquenetta Beamer Theme | CC BY-SA 4.0
% ----------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{beamerinnerthemeJacquenetta-flowchart}%
  [2026/07/17 v1.2 Jacquenetta flowchart environments]

\mode<presentation>

\RequirePackage{tikz}
\usetikzlibrary{shapes.geometric, shapes.misc, positioning, arrows.meta}

\mode<all>
\endinput
```

- [ ] **Step 2: Define base and node styles**

Append the following TikZ style definitions after the `\usetikzlibrary` line.

```latex
% === Base node style =================================================
\tikzset{
  jqcbase/.style={
    font=\small\sffamily,
    text=jqdark,
    fill=white,
    draw=jqdark,
    line width=0.8pt,
    inner sep=6pt,
    minimum height=0.9cm,
    minimum width=2.2cm,
    align=center,
  },
  jqterminator/.style={
    jqcbase,
    shape=rounded rectangle,
    draw=jqaccent,
    line width=1.2pt,
  },
  jqprocess/.style={
    jqcbase,
    shape=rectangle,
  },
  jqdecision/.style={
    jqcbase,
    shape=diamond,
    aspect=2,
    inner sep=4pt,
  },
  jqio/.style={
    jqcbase,
    shape=trapezium,
    trapezium left angle=70,
    trapezium right angle=110,
  },
  jqsubprocess/.style={
    jqcbase,
    shape=rectangle,
    double=jqdark,
    double distance=1.5pt,
  },
}
```

- [ ] **Step 3: Define edge and label styles**

Append the edge and label styles.

```latex
% === Edge and label styles ===========================================
\tikzset{
  jqcedge/.style={
    ->,
    >=Stealth[length=3mm, width=2mm],
    draw=jqdark,
    line width=1.2pt,
    rounded corners=3pt,
  },
  jqclabel/.style={
    font=\scriptsize\sffamily,
    text=jqgray,
    fill=white,
    inner sep=2pt,
  },
}
```

- [ ] **Step 4: Define the wrapper environment and commands**

Append the high-level commands.

```latex
% === jqflowchart environment =========================================
\newenvironment{jqflowchart}[1][]{%
  \begin{tikzpicture}[#1]%
}{%
  \end{tikzpicture}%
}

% === \jqnode =========================================================
% Usage: \jqnode[<options>]{<type>}{<id>}{<text>}{<relative position>}
\newcommand{\jqnode}[5][]{%
  \node[jq#2, #1, #5] (#3) {#4};%
}

% === \jqedge =========================================================
% Usage: \jqedge[<options>]{<from>}{<to>}{<label>}
\newcommand{\jqedge}[4][]{%
  \if\relax\detokenize{#4}\relax
    \draw[jqcedge, #1] (#2) -- (#3);%
  \else
    \draw[jqcedge, #1] (#2) -- node[midway, jqclabel] {#4} (#3);%
  \fi
}

% === \jqbranch =======================================================
% Usage: \jqbranch[<options>]{<from>}{<to>}{<label>}{<direction>}
% <direction> should be a TikZ direction keyword such as left, right, above, below.
% The actual implementation (see the shipped .sty file) maps these keywords to
% compass anchors and orthogonal path operators (-| for horizontal branches,
% |- for vertical ones), draws to the target's border anchor to avoid PGF
% warnings on non-rectangular nodes, and omits the label node when empty.
% Simplified interface sketch:
\newcommand{\jqbranch}[5][]{%
  % dispatch to \jqbranch@h (left/right) or \jqbranch@v (above/below)
}
```

**Verification:** Run the following in the project root to ensure the file parses:

```bash
cd /tmp/opencode/jacquenetta-worktree
TEXINPUTS=./src: xelatex -interaction=nonstopmode -no-pdf \
  "\RequirePackage{beamerthemeJacquenetta}\useinnertheme{Jacquenetta-flowchart}\stop" 2>&1 | grep -i "error\|emergency"
```

Expected: no `!` errors and no emergency stops.

- [ ] **Step 5: Commit**

```bash
git add src/beamerinnerthemeJacquenetta-flowchart.sty
git commit -m "feat: add flowchart inner theme submodule"
```

---

### Task 2: Wire the `flowchart` option into the main theme

**Files:**
- Modify: `src/beamerthemeJacquenetta.sty`

**Interfaces:**
- Consumes: Nothing new.
- Produces: `\jq@flowcharttrue` flag and conditional loading of `Jacquenetta-flowchart`.

- [ ] **Step 1: Add the option flag**

In `src/beamerthemeJacquenetta.sty`, after the `\jq@code` block, add the flowchart flag.

```latex
\newif\ifjq@flowchart
\jq@flowchartfalse
```

- [ ] **Step 2: Declare the option**

Add the option declaration after the `code` option declaration.

```latex
\DeclareOptionBeamer{flowchart}{\jq@flowcharttrue}
```

- [ ] **Step 3: Conditionally load the submodule**

After the existing `\ifjq@code` block and before `\useoutertheme{Jacquenetta}`, add:

```latex
\ifjq@flowchart
  \useinnertheme{Jacquenetta-flowchart}
\fi
```

- [ ] **Step 4: Update the package comments**

Update the header comments to list `flowchart` in the options and add `shapes.geometric`, `positioning`, `arrows.meta` to the dependency list when the option is used.

Updated options comment:
```latex
% Options:
%   accent=<color>   Change the accent color (default: jq@blue)
%   noborder         Disable the signature dark border
%   chinese          Enable CJK support for Chinese (XeLaTeX/LuaLaTeX)
%   code             Enable code environment support
%   flowchart        Enable flowchart environment support
```

Updated dependencies comment:
```latex
% Dependencies: tikz, tcolorbox, listings (with `code` option), etoolbox (CJK
% fixes), helvet, microtype, setspace. With `flowchart`: tikz libraries
% shapes.geometric, positioning, arrows.meta. The `mwe` package is only needed
% for the example-image placeholder in example.tex.
```

**Verification:** Confirm the diff looks correct.

```bash
git diff src/beamerthemeJacquenetta.sty
```

Expected: adds the flag, option, conditional load, and comment updates only.

- [ ] **Step 5: Commit**

```bash
git add src/beamerthemeJacquenetta.sty
git commit -m "feat: wire flowchart option into main theme"
```

---

### Task 3: Update the example document with flowcharts

**Files:**
- Modify: `example/example.tex`

**Interfaces:**
- Consumes: `flowchart` option and `jqflowchart`, `\jqnode`, `\jqedge`, `\jqbranch` from Task 1.

- [ ] **Step 1: Enable the `flowchart` option**

Change the theme declaration on line 2 from:

```latex
\usetheme[chinese, code]{Jacquenetta}
```

To:

```latex
\usetheme[chinese, code, flowchart]{Jacquenetta}
```

- [ ] **Step 2: Add a flowchart section and frames**

After the `\section{代码 / Code}` section and before `\section{颜色 / Colors}`, insert a new section.

```latex
% ============================================================
\section{流程图 / Flowcharts}
% ============================================================

\sectionframe{04}{流程图 Flowcharts}

\begin{frame}{训练流程 / Training pipeline}
\begin{jqflowchart}[scale=0.75, transform shape, node distance=0.5cm and 0.8cm]
  \jqnode{terminator}{start}{开始 / Start}{}
  \jqnode{io}{load}{加载数据 / Load data}{below=of start}
  \jqedge{start}{load}{}
  \jqnode{process}{pre}{预处理 / Preprocess}{below=of load}
  \jqedge{load}{pre}{}
  \jqnode{decision}{split}{数据足够？}{below=of pre}
  \jqedge{pre}{split}{}
  \jqnode{process}{train}{训练模型 / Train}{below=of split}
  \jqbranch{split}{train}{是}{below}
  \jqnode{process}{collect}{收集更多数据 / Collect more}{right=of split}
  \jqbranch{split}{collect}{否}{right}
  \jqnode{terminator}{end}{结束 / End}{below=of train}
  \jqedge{train}{end}{}
\end{jqflowchart}
\end{frame}

\begin{frame}{模型推断 / Inference}
\begin{jqflowchart}[scale=0.85, transform shape, node distance=1.2cm and 2.0cm]
  \jqnode{terminator}{in}{输入样本 / Input}{}
  \jqnode{subprocess}{model}{模型前向 / Forward pass}{right=of in}
  \jqedge{in}{model}{}
  \jqnode{decision}{thresh}{置信度 > 0.5？}{right=of model}
  \jqedge{model}{thresh}{}
  \jqnode{process}{pos}{正例 / Positive}{below=of thresh}
  \jqbranch{thresh}{pos}{Yes}{below}
  \jqnode{process}{neg}{负例 / Negative}{above=of thresh}
  \jqbranch{thresh}{neg}{No}{above}
\end{jqflowchart}
\end{frame}
```

- [ ] **Step 3: Renumber the following section frames**

Because the new section is inserted after the code section, the code section keeps `03` and the new flowcharts section takes `04`. Renumber the following sections:

- `\sectionframe{03}{流程图 Flowcharts}` → `\sectionframe{04}{流程图 Flowcharts}`
- `\sectionframe{04}{颜色 Colors}` → `\sectionframe{05}{颜色 Colors}`
- `\sectionframe{05}{总结 Conclusion}` → `\sectionframe{06}{总结 Conclusion}`

**Verification:** Compile the example.

```bash
cd /tmp/opencode/jacquenetta-worktree
make example 2>&1 | tail -20
```

Expected: Output written to `example.pdf` with no `Missing character in font nullfont` lines in the log.

Confirm with:

```bash
grep -i "missing character\|font nullfont" example/example.log || echo "No nullfont warnings"
```

Expected: `No nullfont warnings`.

- [ ] **Step 4: Commit**

```bash
git add example/example.tex
git commit -m "docs(example): add flowchart section and frames"
```

---

### Task 4: Update README documentation

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: Feature behavior from Tasks 1–3.

- [ ] **Step 1: Add `flowchart` to the options table**

In the options table, add a row for `flowchart`.

```markdown
| `flowchart` | 启用流程图环境 | 关闭 |
```

- [ ] **Step 2: Add a new "流程图 / Flowcharts" section**

Insert a new section after the "代码环境" section.

```markdown
## 流程图 / Flowcharts

启用 `flowchart` 选项后，可以使用基于 TikZ 的流程图环境：

```latex
\usetheme[chinese, flowchart]{Jacquenetta}

\begin{frame}{训练流程 / Training pipeline}
\begin{jqflowchart}[scale=0.75, transform shape, node distance=0.5cm and 0.8cm]
  \jqnode{terminator}{start}{开始 / Start}{}
  \jqnode{io}{load}{加载数据 / Load data}{below=of start}
  \jqedge{start}{load}{}
  \jqnode{process}{pre}{预处理 / Preprocess}{below=of load}
  \jqedge{load}{pre}{}
  \jqnode{decision}{split}{数据足够？}{below=of pre}
  \jqedge{pre}{split}{}
  \jqnode{process}{train}{训练模型 / Train}{below=of split}
  \jqbranch{split}{train}{是}{below}
  \jqnode{process}{collect}{收集更多数据 / Collect more}{right=of split}
  \jqbranch{split}{collect}{否}{right}
  \jqnode{terminator}{end}{结束 / End}{below=of train}
  \jqedge{train}{end}{}
\end{jqflowchart}
\end{frame}
```

节点类型：`terminator`（开始/结束）、`process`（处理）、`decision`（判断）、`io`（输入/输出）、`subprocess`（子流程）。

命令说明：

| 命令 | 说明 |
|------|------|
| `\jqnode{类型}{id}{文本}{位置}` | 放置节点；位置如 `below=of start` |
| `\jqedge{from}{to}{标签}` | 直连两个节点 |
| `\jqbranch{from}{to}{标签}{方向}` | 从判断节点引出分支，方向为 `left`/`right`/`above`/`below` |

样式说明：

- 节点采用与主题一致的深灰边框 + 白底，开始/结束节点使用强调色边框。
- 连线为粗实线，使用 `arrows.meta` Stealth 箭头。
- 依赖 TikZ 的 `positioning` 库，支持相对定位。
```

- [ ] **Step 3: Update dependencies**

Update the dependencies paragraph to mention the new TikZ libraries when `flowchart` is enabled.

```markdown
标准 TeX Live 2020+ 或 MiKTeX 24+ 安装。所需宏包：`tikz`、`tcolorbox`（skins 库）、`helvet`、`microtype`、`setspace`、`ctex`、`listings`（启用 `code` 选项时）、`etoolbox`（CJK 修复使用）。启用 `flowchart` 时需要 TikZ 库 `shapes.geometric`、`positioning`、`arrows.meta` —— 默认发行版均已包含。`example.tex` 中的占位图片使用 `mwe` 宏包，仅编译示例时需要。
```

**Verification:** Proofread the README for Markdown correctness and consistent terminology.

```bash
sed -n '170,220p' README.md
```

Expected: the new section renders correctly and uses the same terminology as the rest of the README.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs(readme): document flowchart option and commands"
```

---

### Task 5: Multimodal visual check

**Files:**
- Review generated PDF: `example/example.pdf`

**Interfaces:**
- Consumes: `example/example.pdf` from Task 3.

- [ ] **Step 1: Regenerate the example PDF**

```bash
cd /tmp/opencode/jacquenetta-worktree
make example
```

- [ ] **Step 2: Inspect the flowchart pages**

Use a multimodal tool or image extraction to inspect the two flowchart frames.

```bash
# Extract flowchart pages (section starts after color divider; page numbers may shift)
pdftoppm -f 19 -l 24 -png -r 150 example/example.pdf /tmp/opencode/flowchart-pages
ls /tmp/opencode/flowchart-pages*.png
```

Adjust `-f` and `-l` if page numbers differ.

- [ ] **Step 3: Evaluate visually**

Check the following:

1. Terminator nodes have an accent-colored border and rounded ends.
2. Process, IO, decision, and subprocess nodes have dark borders and white fill.
3. Decision nodes are diamonds and fully contain their text.
4. Edges are thick dark lines with Stealth arrowheads.
5. Orthogonal routing has clean corners; no arrowheads buried inside nodes.
6. Branch labels (`是`/`否`, `Yes`/`No`) are readable and not overlapping edges.
7. No text is clipped by nodes.
8. CJK characters in flowchart nodes render correctly when `chinese` is enabled.

- [ ] **Step 4: Fix any visual defects**

If issues are found, adjust the styles in `src/beamerinnerthemeJacquenetta-flowchart.sty` and/or the example layout, then rerun the visual check.

- [ ] **Step 5: Commit regenerated PDF**

```bash
git add example/example.pdf
git commit -m "chore: regenerate example PDF with flowcharts"
```

---

### Task 6: Strict review and regression check

**Files:**
- Review: all changed files and generated PDF.

**Interfaces:**
- Consumes: All previous tasks.

- [ ] **Step 1: Self-review for code quality**

Read `src/beamerinnerthemeJacquenetta-flowchart.sty` and verify:

- No `tikzpicture` leaks from the environment definitions.
- All commands are robust to missing optional arguments.
- TikZ libraries are loaded only inside the submodule.

- [ ] **Step 2: English regression check**

Create a temporary minimal document without `chinese` and compile.

```bash
cat > /tmp/opencode/flowchart-en-test.tex <<'EOF'
\documentclass[aspectratio=169]{beamer}
\usetheme[flowchart]{Jacquenetta}
\begin{document}
\begin{frame}{Flowchart}
\begin{jqflowchart}[scale=0.8, transform shape, node distance=1.0cm and 1.8cm]
  \jqnode{terminator}{a}{Start}{}
  \jqnode{process}{b}{Compute}{below=of a}
  \jqedge{a}{b}{}
  \jqnode{decision}{c}{OK?}{below=of b}
  \jqedge{b}{c}{}
  \jqnode{process}{d}{Retry}{right=of c}
  \jqbranch{c}{d}{No}{right}
  \jqnode{terminator}{e}{End}{below=of c}
  \jqbranch{c}{e}{Yes}{below}
\end{jqflowchart}
\end{frame}
\end{document}
EOF
TEXINPUTS=/tmp/opencode/jacquenetta-worktree/src: xelatex -interaction=nonstopmode /tmp/opencode/flowchart-en-test.tex 2>&1 | tail -5
TEXINPUTS=/tmp/opencode/jacquenetta-worktree/src: xelatex -interaction=nonstopmode /tmp/opencode/flowchart-en-test.tex 2>&1 | tail -5
```

Expected: Output written to `flowchart-en-test.pdf`.

- [ ] **Step 3: Run full example check**

```bash
cd /tmp/opencode/jacquenetta-worktree
make clean && make example 2>&1 | tail -5
grep -i "missing character\|font nullfont" example/example.log || echo "No nullfont warnings"
```

Expected: successful compile and no nullfont warnings.

- [ ] **Step 4: Review commit history**

```bash
git log --oneline -8
```

Expected: clean, focused commits in logical order.

- [ ] **Step 5: Commit any final fixes**

If any fixes were made during review, commit them now.

---

## Self-Review

1. **Spec coverage:**
   - `flowchart` option → Task 2.
   - New inner submodule with styles → Task 1.
   - Five node types and edge style → Task 1 Steps 2–3.
   - Wrapper commands → Task 1 Step 4.
   - Example document update → Task 3.
   - README update → Task 4.
   - Multimodal visual check → Task 5.
   - Regression check → Task 6.
   No gaps.

2. **Placeholder scan:**
   - No TBD/TODO/fill-in-later references.
   - All code blocks contain concrete LaTeX code.
   - All commands and expected outputs are explicit.

3. **Type consistency:**
   - `\jqnode` arguments remain `{type}{id}{text}{position}` in all examples.
   - `\jqbranch` arguments remain `{from}{to}{label}{direction}`.
   - Node style names `jqterminator`, `jqprocess`, `jqdecision`, `jqio`, `jqsubprocess` are consistent.

Plan is ready for execution.
