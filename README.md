<div align="center">

# Jacquenetta

**适用于学术演示的现代化极简 Beamer 主题**

`\usetheme{Jacquenetta}`

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
[![LaTeX](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg)](https://www.latex-project.org/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Samuel%20Manchajm-0077B5?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samuel-manchajm/)

</div>

---

<div align="center">
<img src="assets/preview_title.jpg" width="48%" />
<img src="assets/preview_section.jpg" width="48%" />
</div>

<div align="center">
<img src="assets/preview_blocks.jpg" width="48%" />
<img src="assets/preview_math.jpg" width="48%" />
</div>

---

Jacquenetta 是一款简洁、有态度的 Beamer 主题，专为 AI、机器学习、统计学等领域的学术演讲设计。灵感来自 Jacquenetta 风格的 Google Slides。没有多余元素，没有导航栏，只保留你的内容，同时呈现强烈的视觉识别度。

## 亮点

- **签名边框** —— 每张幻灯片都有粗重的深色边框，可用 `noborder` 关闭
- **统一标注系统** —— 标准块、警示块、示例块、problock、highlightbox 共享相同的左边框语言
- **分节页** —— 深色 `\sectionframe`，配有大号幽灵数字
- **强调色** —— 支持任意 xcolor 名称，完全可配置
- **衬线数学** —— 正文使用 Helvetica / TeX Gyre Heros，公式使用 Computer Modern
- **X/N 页脚** —— 右下角仅显示页码，无其他干扰

## 更新内容

- **新增中文支持**：`chinese` 选项可一键启用中文，自动加载 `ctex` 并设置 CJK 字体
- **中英混排示例**：`example/example.tex` 已更新为中英双语示例，可直接使用
- **英文回退 Helvetica**：在 XeLaTeX/LuaLaTeX 下通过 `TeX Gyre Heros` 保持英文 Helvetica 风格
- **简化构建**：`make example` 默认使用 `xelatex`，无需单独的中文编译目标
- **代码环境**：`code` 选项提供 `jqlisting` 与 `jqcodebox` 代码环境
- **流程图支持**：`flowchart` 选项提供 `jqflowchart` 环境与 `\jqnode`、`\jqedge`、`\jqbranch` 命令

## 安装

将 `src/` 中的所有 `.sty` 文件复制到你的项目目录：

```bash
cp src/*.sty /path/to/your/project/
```

或系统全局安装：

```bash
make install   # 复制到 ~/texmf/tex/latex/jacquenetta/
```

## 快速入门

### 1. 最简单的中英混用幻灯片

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme[chinese]{Jacquenetta}

\title{你的标题}
\subtitle{Your Subtitle / 你的副标题}
\author{你的名字 / Your Name}
\institute{你的机构 / Your Institution}
\date{\today}

\begin{document}

\titleframe

\begin{frame}{幻灯片标题 / Slide Title}
    这里是中文内容，and here is English content.
\end{frame}

\thanksframe[谢谢 / Thank you]

\end{document}
```

### 2. 编译命令

```bash
xelatex example.tex && xelatex example.tex
```

或使用 Makefile：

```bash
make example
```

> **注意**：中文支持需要 **XeLaTeX** 或 **LuaLaTeX**。`pdflatex` 无法直接编译中文内容。

## 主题选项

```latex
\usetheme[accent=jqorange]{Jacquenetta}   % 橙色强调色
\usetheme[noborder]{Jacquenetta}           % 关闭签名边框
\usetheme[accent=teal, noborder]{Jacquenetta}
```

| 选项 | 说明 | 默认值 |
|--------|-------------|---------|
| `accent=<颜色>` | 任意 xcolor 名称或主题别名 | `jqblue` |
| `noborder` | 关闭签名边框 | 关闭 |
| `chinese` | 启用中文 CJK 支持（XeLaTeX/LuaLaTeX） | 关闭 |
| `code` | 启用 `jqlisting` 与 `jqcodebox` 代码环境 | 关闭 |
| `flowchart` | 启用流程图环境 | 关闭 |

## 中文支持

使用 `chinese` 选项即可启用中文支持。主题会自动加载 `ctex`，并设置：

- **中文**：Noto Sans CJK SC / Source Han Sans（思源黑体）
- **英文**：TeX Gyre Heros（Helvetica 克隆）
- **数学**：保留 Computer Modern 衬线字体

如需使用其他 CJK 字体，可在加载主题后覆盖：

```latex
\usetheme[chinese]{Jacquenetta}
\setCJKmainfont{Source Han Sans SC}[AutoFakeSlant]
\setCJKsansfont{Source Han Sans SC}[AutoFakeSlant]
```

## 机构 Logo

在导言区设置一次 Logo，它会自动出现在标题页（右下角）和每张幻灯片的页脚（左下角）。如果不设置，则不会显示任何内容。

```latex
\logo{\includegraphics[height=0.7cm]{logo.png}}
```

> **注意**：避免在 `\logo{...}` 中使用文字（尤其是中文）。`\logo` 在导言区执行时字体尚未就绪，可能触发 `nullfont` 警告。建议始终使用图片 Logo。

若只想在标题页显示 Logo（不在页脚显示），在 `\titleframe` 后清空它：

```latex
\titleframe
\logo{}   % 从正文页脚中移除 logo
```

## 命令

| 命令 | 说明 |
|---------|-------------|
| `\titleframe` | 标题页（无边框），带强调色分隔线 |
| `\thanksframe` | 深色结束页 —— "Thank you." |
| `\thanksframe[你的文字]` | 自定义文字的深色结束页 |
| `\sectionframe{N}{标题}` | 深色分节页，带幽灵数字 |

## 环境

所有环境都使用统一的左边框视觉语言。

```latex
% 标准 Beamer 块 —— 可在 [fragile] 帧中使用
\begin{block}{标题}         % 强调色边框
\begin{alertblock}{标题}    % 橙色边框
\begin{exampleblock}{标题}  % 绿色边框

% 自定义环境 —— 依赖 tcolorbox，避免在 [fragile] 帧中使用
\begin{problock}{标题}      % 强调色边框，更丰富的内容
\begin{highlightbox}         % 橙色边框，无标题
```

## 代码环境

启用 `code` 选项后，可使用以下环境：

```latex
% 行内代码片段：带标题的高亮卡片
\begin{jqcodebox}[language=Python, title=训练循环]
for epoch in range(epochs):
    ...
\end{jqcodebox}

% 跨帧讲解：按行号切片展示
\begin{jqlisting}[language=Python, firstline=1, lastline=12]
...
\end{jqlisting}
```

- `jqcodebox` 基于 `tcolorbox` + `listings`，适合单帧内展示的代码片段。
- `jqlisting` 基于 `listings`，适合把长代码切成多帧逐行讲解。
- 使用 `\jqinputlisting[language=Python, firstline=1, lastline=20]{file.py}` 直接读取外部文件。
- 包含代码环境的 `frame` 需要声明 `[fragile]`。

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

## 调色板

| 别名 | Hex | 作用 |
|-------|-----|------|
| `jqdark` | `#121212` | 文本、边框、深色背景 |
| `jqgray` | `#757575` | 副标题、注释 |
| `jqblue` | `#4A90E2` | 默认强调色 |
| `jqorange` | `#E67E22` | 警示、高亮框 |
| `jqgreen` | `#27AE60` | 示例块 |
| `jqaccent` | — | 当前强调色别名 |

任意位置可用：`	extcolor{jqorange}{...}` · `	extcolor{jqaccent}{...}`

## 需求

标准 TeX Live 2020+ 或 MiKTeX 24+ 安装。所需宏包：`tikz`、`tcolorbox`（skins 库）、`helvet`、`microtype`、`setspace`、`ctex`、`listings`（启用 `code` 选项时）、`etoolbox`（CJK 修复使用）。启用 `flowchart` 时需要 TikZ 库 `shapes.geometric`、`shapes.misc`、`positioning`、`arrows.meta` —— 默认发行版均已包含。`example.tex` 中的占位图片使用 `mwe` 宏包，仅编译示例时需要。

## 许可

本作品采用 [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/) 许可。

你可以自由使用、修改和再分发本主题 —— 包括商业用途 —— 只要你署名原作者，并以相同许可分享修改版本。

2026 Samuel Manchajm
