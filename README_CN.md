# SDLC 子代理团队

一个完整的软件开发生命周期（SDLC）管道，以代理技能形式实现，具有结构化交接、状态管理和多 AI 工具支持。

## 安装

### 方式 1：一键安装（推荐）

```bash
# 交互式选择
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# 指定工具
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool claude-code
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool opencode
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool qodercli
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --tool cursor

# 安装到所有工具
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s . --all
```

### 方式 2：NPX

```bash
# 交互式选择
npx @nbzhaosq/sdlc-team init .

# 指定工具
npx @nbzhaosq/sdlc-team init . --tool claude-code
npx @nbzhaosq/sdlc-team init . --tool opencode
npx @nbzhaosq/sdlc-team init . --tool qodercli

# 安装到所有工具
npx @nbzhaosq/sdlc-team init . --all
```

### 方式 3：Git Clone

```bash
git clone https://github.com/nbzhaosq/sdlc-team.git
cp -r sdlc-team/skills /path/to/your/project/.claude/
# 或: cp -r sdlc-team/skills /path/to/your/project/.opencode/
# 或: cp -r sdlc-team/skills /path/to/your/project/.qoder/
```

## 支持的 AI 工具

| 工具 | Skills 目录 | 配置文件 | 命令前缀 |
|------|-------------|----------|---------|
| Claude Code | `.claude/skills/` | `CLAUDE.md` | `/sdlc:*` |
| OpenCode | `.opencode/skills/` | `OPENCODE.md` | `/sdlc:*` |
| QoderCLI | `.qoder/skills/` | `QODER.md` | `/sdlc:*` |
| Cursor | `.cursor/skills/` | `.cursorrules` | `Cmd+K` |
| Generic | `skills/` | `AGENTS.md` | workflow |

## 特性

- **5 阶段管道**：需求 → 架构 → 开发 → 审查 → 测试
- **结构化交接**：每个阶段产出物传递给下一阶段
- **状态管理**：通过 `.sdlc-state.json` 追踪管道进度
- **多工具支持**：支持 Claude Code、OpenCode、QoderCLI、Cursor 等
- **项目定制**：通过工具特定配置文件定制
- **质量门禁**：内置检查清单、代码检查和测试验证

## 快速开始

### 1. 安装

```bash
# 交互式 - 会提示选择工具
npx @nbzhaosq/sdlc-team init .

# 或指定你的工具
npx @nbzhaosq/sdlc-team init . --tool claude-code
```

### 2. 运行管道

```bash
# 完整管道
/sdlc "使用 OAuth 构建用户认证功能"

# 单阶段
/sdlc:analyze "添加仪表盘功能"
/sdlc:design
/sdlc:develop
/sdlc:review
/sdlc:test
```

## 命令参考

| 命令 | 别名 | 描述 |
|---------|---------|-------------|
| `/sdlc "feature"` | `/sdlc:run` | 运行完整 5 阶段管道 |
| `/sdlc --resume <phase>` | | 从特定阶段恢复 |
| `/sdlc:analyze` | `/sdlc:req` | 阶段 1：需求分析 |
| `/sdlc:design` | `/sdlc:arch` | 阶段 2：架构设计 |
| `/sdlc:develop` | `/sdlc:code` | 阶段 3：实现 |
| `/sdlc:review` | `/sdlc:code-review` | 阶段 4：代码审查 |
| `/sdlc:test` | `/sdlc:verify` | 阶段 5：测试验证 |

## 项目结构

```
your-project/
├── .claude/skills/          # Claude Code skills (或 .opencode/skills, .qoder/skills)
│   ├── sdlc/                # 协调器
│   ├── sdlc-requirements/   # 阶段 1
│   ├── sdlc-architecture/   # 阶段 2
│   ├── sdlc-development/    # 阶段 3
│   ├── sdlc-review/         # 阶段 4
│   └── sdlc-testing/        # 阶段 5
│
├── CLAUDE.md               # 工具配置 (或 OPENCODE.md, QODER.md 等)
├── .sdlc-state.json        # 管道状态追踪
│
├── docs/
│   └── sdlc/               # 阶段产出物
│       ├── requirements.md
│       ├── architecture.md
│       ├── implementation-notes.md
│       ├── review-feedback.md
│       └── test-report.md
│
└── .sdlc/                  # 自定义
    ├── templates/
    ├── scripts/
    └── standards/
```

## 管道流程

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ 需求分析    │───▶│ 架构设计     │───▶│ 开发实现    │───▶│ 代码审查    │───▶│ 测试验证    │
│   阶段 1    │    │   阶段 2     │    │   阶段 3    │    │   阶段 4    │    │   阶段 5    │
└──────┬──────┘    └──────┬───────┘    └──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                    │                  │                  │
       ▼                  ▼                    ▼                  ▼                  ▼
 requirements.md    architecture.md    implementation-    review-feedback.md  test-report.md
                                       notes.md + code
```

## 技能参考

| 技能 | 名称 | 别名 | 用途 |
|-------|------|---------|---------|
| 协调器 | `sdlc` | `sdlc:run` | 主协调器 |
| 阶段1 | `sdlc:requirements` | `sdlc:analyze`, `sdlc:req` | 需求分析 |
| 阶段2 | `sdlc:architecture` | `sdlc:design`, `sdlc:arch` | 架构设计 |
| 阶段3 | `sdlc:development` | `sdlc:develop`, `sdlc:code` | 实现 |
| 阶段4 | `sdlc:review` | `sdlc:code-review` | 代码审查 |
| 阶段5 | `sdlc:testing` | `sdlc:test`, `sdlc:verify` | 测试验证 |

## 系统要求

- Node.js >= 18.0.0（用于 NPX）
- Bash（用于脚本）
- Git（用于克隆）
- 项目相关工具（npm、pytest、go test 等）

## 许可证

MIT
