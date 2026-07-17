# Flowchart Support for Jacquenetta — Design

**Date:** 2026-07-17  
**Author:** OpenCode  
**Status:** Approved

---

## 1. Objective

Add flowchart support to the Jacquenetta Beamer theme that reuses the existing visual language (flat, left-border accent style, dark typography, rounded corners) and is easy to write for technical presentations.

## 2. Background

The theme already provides:

- A dark/gray/blue/orange/green palette via `beamercolorthemeJacquenetta.sty`.
- A flat, left-border block language.
- Optional submodules loaded by `chinese` and `code` in `beamerthemeJacquenetta.sty`.
- TikZ (loaded in the main theme) for title-page logo placement.

Flowcharts should therefore be implemented as a new optional inner submodule, loaded via a `flowchart` theme option, keeping the default theme lightweight.

## 3. Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Loading | New `flowchart` option | Consistent with `chinese` and `code` options; avoids imposing dependencies on all users. |
| Layering | TikZ styles + light wrapper commands | Gives power users full TikZ access while providing helpers for common node/edge declarations. |
| Node set | Terminator, Process, Decision, IO, Subprocess | Covers standard flowchart notation. |
| Visual style | Theme “border language” | White fill, dark border, accent edge on terminator; matches blocks and code boxes. |
| Edges | Thick lines, `arrows.meta` Stealth, corner routing | Strong, readable connectors that fit the bold theme. |
| Layout | TikZ `positioning` library | Relative placement (`right=of A`) rather than manual coordinates. |

## 4. Architecture

```
beamerthemeJacquenetta.sty
  └── flowchart option
        └── \useinnertheme{Jacquenetta-flowchart}
              └── beamerinnerthemeJacquenetta-flowchart.sty
                    ├── TikZ libraries: shapes.geometric, positioning, arrows.meta
                    ├── Node styles: jqterminator, jqprocess, jqdecision, jqio, jqsubprocess
                    ├── Edge style: jqcedge
                    └── Wrapper commands:
                          \begin{jqflowchart}[options]
                          \jqnode{type}{id}{text}{placement}
                          \jqedge{from}{to}{label}[options]
                          \jqbranch{from}{to}{label}{direction}
```

## 5. Component Details

### 5.1 New file: `src/beamerinnerthemeJacquenetta-flowchart.sty`

- Loads `tikz` (already loaded by main theme) and libraries `shapes.geometric`, `positioning`, `arrows.meta`.
- Defines a base style `jqcbase` with common parameters (font, inner sep, minimum height, line width, dark border, white fill, text color).
- Defines per-node styles that inherit from `jqcbase` and add shape-specific geometry and an accent edge/border for the terminator node.
- Defines an edge style `jqcedge` with:
  - line width `1.2pt`
  - color `jqdark`
  - arrow tip `Stealth[length=3mm,width=2mm]`
  - `rounded corners` for orthogonal routing
- Defines a label style `jqclabel` using small text, `jqgray`, placed near the edge.

### 5.2 Node styles

| Style | Shape | Default size | Accent |
|-------|-------|--------------|--------|
| `jqterminator` | rounded rectangle | min width 2.2cm, min height 0.9cm | top border or left border in `jqaccent` |
| `jqprocess` | rectangle | min width 2.2cm, min height 0.9cm | none |
| `jqdecision` | diamond | aspect=2, min width 2cm | none |
| `jqio` | trapezium | trapezium left angle=70, right angle=110 | none |
| `jqsubprocess` | rectangle | min width 2.2cm, min height=0.9cm, double border | none |

All nodes accept `fill=<color>`, `draw=<color>`, and `accent` overrides through TikZ option syntax.

### 5.3 Wrapper commands

#### Environment

```latex
\begin{jqflowchart}[<tikz options>]
  ...
\end{jqflowchart}
```

Wraps `\begin{tikzpicture}[...]` and sets default styles.

#### Node command

```latex
\jqnode[<options>]{<type>}{<id>}{<text>}{<relative position>}
```

Examples:

```latex
\jqnode{terminator}{start}{Start}{}
\jqnode[right=of start]{process}{prep}{Preprocess}
\jqnode[below=of prep]{decision}{check}{Valid?}
```

The `type` maps to the TikZ style: `terminator`, `process`, `decision`, `io`, `subprocess`.

#### Edge command

```latex
\jqedge[<options>]{<from id>}{<to id>}{<label>}
```

Connects two nodes using orthogonal routing with a label placed midway.

```latex
\jqedge{start}{prep}{}
\jqedge{prep}{check}{input}
```

#### Branch command

```latex
\jqbranch[<options>]{<from id>}{<to id>}{<label>}{<direction>}
```

Specialized edge that draws from a decision node to a side branch (e.g. `right` or `left`) and places the label.

```latex
\jqbranch{check}{fix}{No}{left}
\jqbranch{check}{train}{Yes}{right}
```

### 5.4 Main theme wiring

In `src/beamerthemeJacquenetta.sty`:

- Add `\newif\ifjq@flowchart` / `\jq@flowchartfalse`.
- Add `\DeclareOptionBeamer{flowchart}{\jq@flowcharttrue}`.
- After inner theme loading, add:

```latex
\ifjq@flowchart
  \useinnertheme{Jacquenetta-flowchart}
\fi
```

- Update documentation comments to list the new option.

## 6. Example Usage

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme[chinese, code, flowchart]{Jacquenetta}

\begin{document}

\begin{frame}{模型训练流程 / Training Pipeline}
\begin{jqflowchart}[node distance=1.4cm and 2.2cm]
  \jqnode{terminator}{start}{开始 / Start}{}
  \jqnode[below=of start]{io}{load}{加载数据 / Load data}
  \jqedge{start}{load}{}
  \jqnode[below=of load]{process}{pre}{预处理 / Preprocess}
  \jqedge{load}{pre}{}
  \jqnode[below=of pre]{decision}{split}{划分训练集？}
  \jqedge{pre}{split}{}
  \jqnode[below=of split]{process}{train}{训练模型 / Train}
  \jqbranch{split}{train}{是}{right}
  \jqnode[right=of split]{process}{eval}{评估 / Evaluate}
  \jqbranch{split}{eval}{否}{right}
  \jqnode[below=of train]{terminator}{end}{结束 / End}
  \jqedge{train}{end}{}
\end{jqflowchart}
\end{frame}

\end{document}
```

## 7. Files to Change

| File | Change |
|------|--------|
| `src/beamerinnerthemeJacquenetta-flowchart.sty` | New optional flowchart inner theme. |
| `src/beamerthemeJacquenetta.sty` | Add `flowchart` option and conditional loading. |
| `example/example.tex` | Add a new flowchart section and frame. |
| `README.md` | Document `flowchart` option and commands. |

## 8. Testing & Verification

- Compile `example/example.tex` with `make example` after enabling `flowchart`.
- Ensure no `Missing character in font nullfont` warnings.
- Run the English regression check (without `chinese`) to confirm the new option works standalone.
- Use the multimodal visual check on the generated PDF to verify:
  - Node styles match the theme (dark border, accent on terminator, white fill).
  - Arrows are thick and end in Stealth tips.
  - Corner routing is clean and labels are readable.
  - No node overlaps or clipped text.

## 9. Open Questions

- None. Design approved.
