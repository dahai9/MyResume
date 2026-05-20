---
name: generate-resume
description: Generate concise, job-matched resumes from target job posts, GitHub repositories, local repo evidence, blog posts, and agent workflow files. Use when asked to write, optimize, tailor, compress, or regenerate a resume/CV, especially for A4 one-page resumes, LLM/ATS screening, ByteDance/AI Agent roles, or YAML-driven resume files such as easyCV.
---

# Generate Resume

## Core Rule

Optimize for two readers:

1. **LLM/ATS first pass**: include exact role keywords, technologies, protocols, and project names.
2. **HR 10-second scan**: keep the resume to one A4 page, with few projects and short bullets.

Do not list every project. Select the strongest evidence for the target role.

## Workflow

### 1. Read the Target Job

Open or fetch the job page before writing. Extract:

- Job title, location, category, and seniority signal.
- Top requirement keywords.
- Whether the role is algorithm/research, agent infrastructure, backend/application, solution/product, or design.
- Hard requirements that must not be overclaimed, such as SFT, RL, Agentic RL, Reward System, model post-training, production traffic, or years of experience.

For AI Agent roles, map requirements into:

- Agent architecture: Agent Loop, planning, ReAct/PlanAct/CodeAct, multi-agent, self-evolving agents.
- Engineering: runtime, tool orchestration, context engineering, state/memory, tracing, evaluation, rollback.
- Model/API: Function Calling, Tool Calling, Responses API, Chat Completions, streaming/SSE, model routing.
- Retrieval/memory: RAG, MCP, vector/hybrid search, RRF, long/short-term memory.
- Training/research: Agentic RL, reward signal, SFT/RL post-training, CodeRL.

### 2. Gather Project Evidence

Use `gh` for public GitHub evidence:

```bash
gh repo list <user> --limit 100 --json name,description,url,pushedAt,updatedAt,primaryLanguage,languages,isFork,isArchived
```

Prefer repositories updated in the last 2-3 months. If a same-name local checkout exists under the parent workspace, inspect local files instead of relying only on GitHub metadata.

High-yield local evidence:

- `README.md`
- `AGENTS.md`, `CLAUDE.md`, `.cursorrules`
- `.agents/skills/**/SKILL.md`, `.claude/skills/**/SKILL.md`
- `docs/`
- `src/`, `crates/`, `tests/`
- Recent blog posts and commit messages.

For this user's Agent resume work, strong evidence patterns include:

- `sapience`: goal-driven self-update, RuntimeSignal, GoalPlan, UpdateProposal, VerificationPipeline, rollback, SWE smoke, attempt ledger.
- `responses-adapter`: Responses API to Chat Completions, SSE, custom tools, function/tool calling, DeepSeek reasoning content.
- `openlink-rs`: browser AI to local tools, sandbox, skills, ChatGPT/Gemini/AI Studio adapters.
- `EverMemOS/evermemos-rs`: Agent Memory, MCP, agentic retrieval, hybrid search/RRF, Rust infra rewrite.
- `Sea_of_Bits`: technical blog evidence for self-evolving agents, goal-driven self-update, protocol bridging, tool systems.
- `har_analyzer`: LLM-friendly tooling and reusable agent skill packaging.

### 3. Interpret Agent Workflow Files

Treat `AGENTS.md`, `CLAUDE.md`, and Skill files as evidence that the project is designed for AI coding assistants, but do not imply they prove production adoption.

Use them to support claims like:

- "固化 AI coding assistant 的目标、验收标准和工程约束"
- "把工具使用流程包装成可复用 Skill"
- "使用 goal-driven 的 Goal + Criteria + Verification 思路驱动 Agent 工程"

Avoid saying "used Claude Code/Codex in production" unless logs, commits, or user confirmation support it.

### 4. Rank Projects

Score each project by:

- Direct match to job requirements.
- Strength of public or local evidence.
- Recency.
- Differentiation from ordinary CRUD or boilerplate work.
- Whether it helps the candidate look current with AI Agent engineering.

For one-page resumes, keep:

- 3 core projects maximum.
- 1 compact blog/tooling section maximum.
- 2 bullets per project.
- One clear tech stack line per project.

Merge related smaller projects instead of listing them separately.

### 5. Write for LLM Screening

Include exact keywords naturally:

- Agent Runtime
- Tool Calling / Function Calling
- Context Engineering
- MCP
- Agent Memory
- Self-Evolving Agent
- GoalPlan / VerificationPipeline / Rollback
- SSE / Streaming
- Responses API / Chat Completions
- Agentic RL / reward signal, only as learning/research unless implemented

Do not overclaim hard algorithm work. If the user studied Agentic RL but has no training implementation, write:

- "Agentic RL 学习"
- "关注 reward signal / evaluation"
- "结合 goal-driven verification 探索 Agent 自改进"

Do not write:

- "完成 SFT/RL 训练优化"
- "搭建生产级 Reward System"
- "负责模型 post-training"

unless there is concrete evidence.

### 6. Write for One A4 Page

Use this structure:

1. Basics: name, target role, contact.
2. Education.
3. Code/blog links.
4. Personal summary: one dense keyword paragraph.
5. Projects: 3 compact projects, 2 bullets each.
6. Optional blog/tooling: 1 compact block, 2 bullets.

Prefer this bullet shape:

```text
- 实现 X：A -> B -> C，解决 Y，覆盖 Z 关键词。
```

Remove weak projects, repeated tech stacks, and long architecture explanations.

### 7. For easyCV YAML

When editing an easyCV file such as `examples/me.yaml`, use existing rendered fields:

- `basics.position`
- `personal_docs.summary`
- `personal_docs.items`
- `personal_projects`
- `lab_tutorials`

Avoid adding new top-level keys unless the template renders them.

For A4 one-page output, aim for:

- `personal_docs.items`: 1-2 items.
- `personal_projects`: 3 items.
- `lab_tutorials`: 1 item.
- Each project: description + 2 highlights + tech_stack.

Validate after editing:

```bash
python -c "from pathlib import Path; import yaml; data=yaml.safe_load(Path('examples/me.yaml').read_text(encoding='utf-8')); print(len(data.get('personal_projects', [])), len(data.get('lab_tutorials', [])))"
```

If a preview server is running, inspect the rendered page or PDF length before claiming it fits one page.

## Final Checks

Before finishing:

- Confirm target job keywords are present.
- Confirm strongest projects are included and weak projects are removed.
- Confirm no unsupported claims were introduced.
- Confirm the file parses if it is YAML/JSON.
- Mention unrelated dirty files that were not touched.
