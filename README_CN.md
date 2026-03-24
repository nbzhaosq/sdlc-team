# SDLC 子代理团队

一个完整的软件开发生命周期（SDLC）管道，以代理技能形式实现，具有结构化交接、状态管理和多 AI 工具支持。

## 安装

### 方式 1：一键安装（推荐）

```bash
# 使用 curl
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# 使用 wget
wget -qO- https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash

# 指定目标目录
curl -fsSL https://raw.githubusercontent.com/nbzhaosq/sdlc-team/main/install.sh | bash -s /path/to/project
```

### 方式 2：NPX（Node.js）

```bash
# 在当前目录初始化
npx @nbzhaosq/sdlc-team init .

# 指定目标目录
npx @nbzhaosq/sdlc-team init /path/to/project

# 为特定工具创建配置
npx @nbzhaosq/sdlc-team init . --tool cursor

# 为所有工具创建配置
npx @nbzhaosq/sdlc-team init . --all
```

### 方式 3：Git Clone

```bash
# 克隆仓库
git clone https://github.com/nbzhaosq/sdlc-team.git

# 复制 skills 到你的项目
cp -r sdlc-team/skills /path/to/your/project/

# 运行初始化
cd /path/to/your/project
./skills/sdlc-init/scripts/init-sdlc.sh .
```

### 方式 4：Git Submodule

```bash
# 添加为 submodule
git submodule add https://github.com/nbzhaosq/sdlc-team.git skills/sdlc-team

# 创建符号链接（可选）
ln -s sdlc-team/skills skills
```

### 验证安装

```bash
# 检查 skills 是否安装
ls skills/sdlc*

# 应该看到：
# skills/sdlc/
# skills/sdlc-init/
# skills/sdlc-requirements/
# skills/sdlc-architecture/
# skills/sdlc-development/
# skills/sdlc-review/
# skills/sdlc-testing/
```

## 特性

- **5阶段管道**：需求 → 架构 → 开发 → 审查 → 测试
- **结构化交接**：每个阶段产出物传递给下一阶段
- **状态管理**：通过 `.sdlc-state.json` 追踪管道进度
- **多工具支持**：支持 Claude Code、Cursor、Windsurf 等 AI 工具
- **项目定制**：通过 CLAUDE.md、AGENTS.md 或 .cursorrules 配置
- **质量门禁**：内置检查清单、代码检查和测试验证

## 快速开始

### 1. 初始化项目

```bash
# 自动检测 AI 工具并配置
/sdlc:init

# 或运行初始化脚本
./skills/sdlc-init/scripts/init-sdlc.sh .
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
| `/sdlc:init` | `/sdlc-init` | 初始化项目 SDLC |
| `/sdlc "feature"` | `/sdlc:run` | 运行完整5阶段管道 |
| `/sdlc --resume <phase>` | | 从指定阶段恢复 |
| `/sdlc --phase <phase>` | | 仅运行单阶段 |
| `/sdlc:analyze` | `/sdlc:req` | 阶段1：需求分析 |
| `/sdlc:design` | `/sdlc:arch` | 阶段2：架构设计 |
| `/sdlc:develop` | `/sdlc:code`, `/sdlc:dev` | 阶段3：实现 |
| `/sdlc:review` | `/sdlc:code-review` | 阶段4：代码审查 |
| `/sdlc:test` | `/sdlc:verify` | 阶段5：测试验证 |

## 项目结构

```
your-project/
├── CLAUDE.md                    # Claude Code 配置
├── AGENTS.md                    # 通用 AI 工具配置
├── .cursorrules                 # Cursor 配置
├── .sdlc-state.json             # 管道状态追踪
│
├── docs/
│   └── sdlc/                    # 阶段产出物
│       ├── requirements.md      # 阶段1 输出
│       ├── architecture.md      # 阶段2 输出
│       ├── implementation-notes.md  # 阶段3 输出
│       ├── review-feedback.md   # 阶段4 输出
│       └── test-report.md       # 阶段5 输出
│
├── .sdlc/
│   ├── templates/               # 自定义模板
│   ├── scripts/                 # 自定义验证脚本
│   └── standards/               # 编码规范
│
└── skills/                      # SDLC 技能（内嵌）
    ├── sdlc/                    # 协调器
    ├── sdlc-init/               # 初始化
    ├── sdlc-requirements/       # 阶段1
    ├── sdlc-architecture/       # 阶段2
    ├── sdlc-development/        # 阶段3
    ├── sdlc-review/             # 阶段4
    └── sdlc-testing/            # 阶段5
```

## 管道流程

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   需求分析  │───▶│   架构设计   │───▶│    开发     │───▶│   代码审查  │───▶│    测试     │
│   阶段 1    │    │   阶段 2     │    │   阶段 3    │    │   阶段 4    │    │   阶段 5    │
└──────┬──────┘    └──────┬───────┘    └──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                    │                  │                  │
       ▼                  ▼                    ▼                  ▼                  ▼
 requirements.md    architecture.md    implementation-    review-feedback.md  test-report.md
                                       notes.md + 代码
```

### 阶段详情

| 阶段 | 输入 | 输出 | 检查清单 |
|-------|-------|--------|-----------|
| 1. 需求 | 功能请求 | `requirements.md` | 用户故事、验收标准、边界情况 |
| 2. 架构 | `requirements.md` | `architecture.md` | 组件、API、数据模型、安全 |
| 3. 开发 | `architecture.md` | 代码 + `implementation-notes.md` | 功能、测试、错误处理 |
| 4. 审查 | 代码 + 架构 | `review-feedback.md` | 质量、安全、性能 |
| 5. 测试 | 代码 + 审查通过 | `test-report.md` | 测试通过、标准验证 |

## 多工具支持

### 支持的 AI 工具

| 工具 | 配置文件 | 支持级别 |
|------|-------------|---------------|
| Claude Code | `CLAUDE.md` | 完整（斜杠命令） |
| Cursor | `.cursorrules` | 工作流指导 |
| Windsurf | `.windsurfrules` | 工作流指导 |
| 通用 | `AGENTS.md` | 通用格式 |

### 为多个工具初始化

```bash
# 为所有工具创建配置
./skills/sdlc-init/scripts/init-sdlc.sh . all

# 创建：
# - CLAUDE.md（Claude Code）
# - AGENTS.md（通用）
# - .cursorrules（Cursor）
```

## 状态追踪

管道状态在 `.sdlc-state.json` 中追踪：

```json
{
  "project": "用户认证",
  "current_phase": "development",
  "phases": {
    "requirements": { "status": "completed", "completed_at": "2025-03-25T10:00:00Z" },
    "architecture": { "status": "completed", "completed_at": "2025-03-25T11:30:00Z" },
    "development": { "status": "in_progress", "started_at": "2025-03-25T12:00:00Z" },
    "review": { "status": "pending" },
    "testing": { "status": "pending" }
  },
  "artifacts": {
    "requirements": "docs/sdlc/requirements.md",
    "architecture": "docs/sdlc/architecture.md"
  }
}
```

## 错误处理

| 场景 | 行为 |
|----------|----------|
| 缺少前置产出物 | 提示运行更早阶段或提供输入 |
| 阶段失败 | 暂停管道，呈现错误，等待决策 |
| 审查发现问题 | 返回开发阶段并附带具体反馈 |
| 测试失败 | 返回开发阶段并附带失败详情 |
| 状态损坏 | 恢复模式 - 从产出物重建 |

## 示例

### 示例 1：新功能

```bash
# 启动完整管道
/sdlc "构建带头像上传的用户资料页"

# 管道将：
# 1. 生成包含用户故事的 requirements.md
# 2. 设计包含 API 端点的架构
# 3. 实现功能
# 4. 审查代码质量和安全性
# 5. 运行测试并验证验收标准
```

### 示例 2：中断后恢复

```bash
# 管道在开发阶段中断
/sdlc --resume development

# 从开发阶段继续
# 使用现有的 requirements.md 和 architecture.md
```

### 示例 3：单阶段迭代

```bash
# 手动更改后仅运行审查
/sdlc:review

# 或迭代架构
/sdlc:design
```

## 部署

### 团队/企业

1. 复制 `skills/` 到共享位置
2. 每个项目运行 `/sdlc:init` 配置
3. 项目通过配置文件定制
4. 团队共享模板和标准

### 内嵌到项目

1. 将 `skills/` 包含到项目仓库
2. 项目设置时运行 `/sdlc:init`
3. 提交 `.sdlc-state.json` 和配置文件
4. 团队成员通过 git 共享配置

## 技能参考

| 技能 | 名称 | 别名 | 用途 |
|-------|------|---------|---------|
| 协调器 | `sdlc` | `sdlc:run`, `sdlc:pipeline` | 主协调器 |
| 初始化 | `sdlc:init` | `sdlc-init` | 项目初始化 |
| 阶段1 | `sdlc:requirements` | `sdlc:analyze`, `sdlc:req` | 需求分析 |
| 阶段2 | `sdlc:architecture` | `sdlc:design`, `sdlc:arch` | 架构设计 |
| 阶段3 | `sdlc:development` | `sdlc:develop`, `sdlc:code` | 实现 |
| 阶段4 | `sdlc:review` | `sdlc:code-review` | 代码审查 |
| 阶段5 | `sdlc:testing` | `sdlc:test`, `sdlc:verify` | 测试验证 |

## 系统要求

- Claude Code（用于斜杠命令）或兼容的 AI 工具
- Bash（用于脚本）
- 项目相关工具（npm、pytest、go test 等）

## 许可证

MIT
