# 使用 Skill 生成一页岗位匹配简历

这份教程说明如何用本仓库的 `generate-resume` Codex Skill，从目标岗位、GitHub 项目、本地代码仓库和博客证据生成一份适合 LLM/ATS 初筛和 HR 快速浏览的一页 A4 简历。

## 目标

最终产物通常是：

- `examples/my_resume.yaml`：可提交的示例简历。
- `resume.yaml`：你的私有简历，默认被 `.gitignore` 忽略，适合放真实姓名、电话、邮箱和照片。
- 浏览器预览页：`http://localhost:8010/resume`。
- 一页 PDF：通过 Chrome/Edge 打印为 PDF。

Skill 的核心原则是同时服务两个读者：

- LLM/ATS 初筛：保留岗位关键词、协议名、技术栈、项目名和可检索证据。
- HR 10 秒扫读：只保留最强项目，不把所有项目堆进简历。

## 必要软件

基础运行环境：

```bash
python --version
uv --version
git --version
```

推荐安装：

```bash
gh --version
rg --version
google-chrome --version
```

如果使用 GitHub CLI 查询项目，先登录：

```bash
gh auth login
gh auth status
```

## 推荐 MCP 和工具能力

使用 Skill 时，Codex 最好具备这些能力：

| 能力 | 用途 | 是否必须 |
| --- | --- | --- |
| Chrome DevTools MCP | 打开岗位页、抓取页面文本、预览简历、测量 A4 高度、截图检查 | 推荐 |
| GitHub CLI `gh` | 查询用户近 2-3 个月仓库、更新时间、语言和描述 | 推荐 |
| GitHub MCP | 如果环境里有 GitHub MCP，可替代部分 `gh` 查询 | 可选 |
| `rg` | 搜索本地仓库 README、docs、src、tests、Skill/Agent 文件 | 推荐 |
| Chrome/Edge | 打印 PDF，并关闭页眉页脚、选择无边距 | 必须 |

没有 Chrome DevTools MCP 时也可以手动打开岗位链接，把岗位 JD 复制给 Codex；没有 `gh` 时，可以让 Codex 直接读取本地仓库和你提供的 GitHub 链接。

## Skill 位置

本仓库已经包含 Skill：

```text
.codex/skills/generate-resume/SKILL.md
```

在 Codex 当前工作目录为本仓库时，可以直接请求使用：

```text
使用 generate-resume skill，根据这个岗位链接和我的 GitHub/本地项目，优化 examples/my_resume.yaml，要求 A4 一页。
岗位链接：https://example.com/job/detail
GitHub：<github-user>
本地仓库根目录：<workspace-path>
```

如果要写真实投递版本，建议让 Codex 写 `resume.yaml`：

```text
使用 generate-resume skill，把 examples/my_resume.yaml 复制为 resume.yaml 并生成真实投递版。保留 A4 一页，不提交 resume.yaml。
岗位链接：<job-url>
GitHub：<github-user>
```

## 从岗位到简历的完整流程

### 1. 准备目标岗位

优先给 Codex 一个具体岗位详情页，而不是只给搜索结果页。好的输入包括：

```text
岗位：<岗位名称>
链接：https://jobs.example.com/position/123/detail
地区：<城市或远程>
目标：根据岗位 JD 生成一页中文简历
```

Skill 会提取：

- 岗位标题、地点、团队方向。
- 高频关键词，例如框架、协议、语言、平台、业务域和工程能力。
- 硬要求，例如工作年限、特定技术栈、生产经验、论文/开源/行业经验。
- 岗位类型，例如算法研究、基础架构、后端研发、前端研发、数据工程、开发者工具、解决方案或产品工程。

### 2. 查询 GitHub 项目

推荐命令：

```bash
gh repo list <github-user> --limit 100 --json name,description,url,pushedAt,updatedAt,primaryLanguage,languages,isFork,isArchived
```

Codex 会优先看最近 2-3 个月活跃仓库，然后在本地仓库根目录寻找同名 checkout。例如：

```text
<workspace-path>/<repo-a>
<workspace-path>/<repo-b>
<workspace-path>/<repo-c>
```

只看 GitHub 描述不够。Skill 要求继续读取本地证据：

- `README.md`
- `AGENTS.md`
- `CLAUDE.md`
- `.cursorrules`
- `.codex/skills/**/SKILL.md`
- `.agents/skills/**/SKILL.md`
- `.claude/skills/**/SKILL.md`
- `docs/`
- `src/`
- `crates/`
- `tests/`
- 近期博客文章和提交信息

### 3. 给项目打分

Skill 会按这几个维度选择项目：

- 与岗位关键词的直接匹配度。
- 证据强度，优先源码、测试、README、技术博客，而不是空泛描述。
- 最近更新时间。
- 差异化程度，优先能体现岗位核心能力的项目，而不是普通样板代码。
- 是否能在一页里讲清楚。

一页简历建议保留：

- 3 个核心项目。
- 1 个博客/工具链补充块。
- 每个项目 1 行描述、2 条 bullet、1 行技术栈。

### 4. 避免过度声称

如果项目里没有明确代码、实验记录或线上证据，不要写过强结论。例如：

```text
负责核心架构并落地生产
显著提升关键指标
完成某类模型训练或平台建设
```

可以写成有证据边界的表述：

```text
参与/独立实现某模块
基于公开项目或本地实验完成原型
学习并复现某方向方法
```

这样能覆盖岗位关键词，同时不引入无法证明的硬性经历。

### 5. 编辑 YAML

easyCV 当前模板会渲染这些字段：

```yaml
basics:
  name: "Your Name"
  position: "<目标岗位>"
education: []
code: []
personal_docs:
  summary: ""
  items: []
personal_projects: []
lab_tutorials: []
```

优先编辑已经被模板渲染的字段：

- `basics.position`
- `personal_docs.summary`
- `personal_docs.items`
- `personal_projects`
- `lab_tutorials`

不要随意新增不会被模板使用的顶层字段，否则 YAML 里有内容但页面不会显示。

### 6. 本地预览

安装依赖：

```bash
uv sync
```

使用默认示例简历预览：

```bash
uv run uvicorn app:app --reload --host 127.0.0.1 --port 8010
```

使用指定简历文件：

```bash
RESUME_FILE=examples/my_resume.yaml uv run uvicorn app:app --reload --host 127.0.0.1 --port 8010
```

打开：

```text
http://localhost:8010/resume
http://localhost:8010/editor
```

### 7. 校验 YAML

```bash
python - <<'PY'
from pathlib import Path
import yaml

path = Path("examples/my_resume.yaml")
data = yaml.safe_load(path.read_text(encoding="utf-8"))
assert isinstance(data, dict)
print(data["basics"]["position"])
print("personal_projects:", len(data.get("personal_projects", [])))
print("lab_tutorials:", len(data.get("lab_tutorials", [])))
PY
```

### 8. 校验是否一页

浏览器里检查：

- 打开 `/resume`。
- 点击“导出 PDF”。
- 目标打印机选择“另存为 PDF”。
- 关闭页眉页脚。
- 边距选择“无”。
- 确认预览只有 1 页。

如果有 Chrome headless，也可以命令行校验：

```bash
google-chrome \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf=/tmp/easycv-resume.pdf \
  http://127.0.0.1:8010/resume
```

页数可用 `pdfinfo`、`mutool` 或简单脚本检查。没有这些工具时，直接看 Chrome 打印预览最可靠。

## 通用一页简历结构

```yaml
personal_docs:
  summary: "关键词：<语言/框架> / <岗位关键词> / <业务域> / <工程能力>。用一段话概括最近项目主线和与目标岗位最相关的能力。"

personal_projects:
  - name: "<项目 A> - <一句话定位>"
    description: "<项目解决的问题、你的角色和主要产出>"
    highlights:
      - "实现 <能力 1>：<输入/方案/结果>，对应岗位关键词 <keyword>。"
      - "完善 <能力 2>：<验证/测试/部署/文档>，体现工程闭环。"
    tech_stack: "<技术栈>"
  - name: "<项目 B> - <一句话定位>"
  - name: "<项目 C> - <一句话定位>"

lab_tutorials:
  - name: "<博客/工具/开源贡献> - <一句话定位>"
```

这个结构的好处是：

- 第一个项目放最贴近岗位要求的证据。
- 第二、三个项目补齐技术广度或业务深度。
- 博客、工具或开源贡献只保留一个，用来证明复盘能力和长期产出。
- 每个项目最多 2 条 bullet，避免把一页简历写成项目清单。

## 常见问题

### Codex 没有自动使用 Skill

直接点名：

```text
请使用 .codex/skills/generate-resume/SKILL.md 的流程。
```

或者：

```text
使用 generate-resume skill 优化 examples/my_resume.yaml。
```

### 项目太多，怎么选

不要把所有项目都写上去。先按岗位类型筛选：

- 算法/研究：方法、实验、指标、复现、论文或开源证据。
- 基础架构/后端：服务边界、可靠性、性能、协议、数据一致性、监控和测试。
- 前端/客户端：交互复杂度、性能、状态管理、跨端适配和可访问性。
- 数据/平台：数据链路、调度、质量、查询性能、成本和稳定性。
- 开发者工具：CLI、IDE/Browser integration、API adapter、文档和用户工作流。

一页里最多放 3 个主项目。其余项目可以只放 GitHub/Blog 链接里。

### 一页放不下

优先删这些内容：

- 长 URL 项。
- 重复技术栈。
- 每个项目超过 2 条 bullet 的部分。
- 与岗位无关的项目。
- “负责/参与/熟悉”这类没有证据密度的句子。

再调整样式：

- 缩小 section 间距。
- 缩小项目块 `margin-bottom`。
- 控制头像高度。
- 打印时设置 `@page size: A4; margin: 0;`。

### 能不能写正在学习的技术

可以写“学习/复现/实验/关注”，但不要写成已经承担生产职责。没有代码、实验记录或线上结果时，保守表述更可靠。

## 提交建议

推荐提交公开模板、Skill 和教程：

```bash
git add README.md docs/generate-resume-with-skill.md .codex/skills/generate-resume/SKILL.md examples/my_resume.yaml
git commit -m "docs: explain resume skill workflow"
```

真实个人信息建议写在 `resume.yaml`，保持忽略，不提交。
