# AGENTS.md

本文件是本仓库中所有 AI coding agents（Codex、Claude Code、Copilot、Gemini CLI 等）的仓库级操作规范。

除非用户在当前任务中明确要求例外，否则以下规则均视为强制约束。

## 1. 仓库定位

本仓库是 `Kron4ek/Conty` 的公开个人自定义 Fork。

- 上游仓库：`https://github.com/Kron4ek/Conty`
- 上游默认分支：`master`
- 本仓库默认分支：`master`
- 核心目标：尽量跟随上游 Conty，同时保留本仓库明确的个人定制、自动构建和 Release 逻辑。
- 不把本仓库改造成与上游完全无关的独立项目；能沿用上游实现时优先沿用。

## 2. 修改前必须先核对上游

涉及 Conty 核心脚本、包列表、运行逻辑或上游已有文件时，AI 必须先检查当前上游 `Kron4ek/Conty` 的最新状态，再决定如何修改。

重点文件包括但不限于：

- `settings.sh`
- `create-arch-bootstrap.sh`
- `create-conty.sh`
- `create-utils.sh`
- `conty-start.sh`
- `enter-bwrap.sh`
- `enter-chroot.sh`
- `init.c`
- 上游原有 `.github/workflows/*`

要求：

- 先比较上游与本 Fork 的实际差异，不得凭记忆修改。
- 上游已经修复的问题，优先采用上游实现，不重复造补丁。
- 上游的新提交不得直接覆盖本仓库已经确认有效的自定义修改。
- 如果上游修改与本仓库自定义逻辑发生冲突，必须先理解双方目的，再做最小合并。
- 不得为了“同步上游”而重置、force-push 或丢弃本仓库自定义提交。
- 不得为了“保持自定义”而长期无理由拒绝上游安全修复、兼容性修复或失效包修复。

## 3. 稳定基线与最小修改

已经确认有效的脚本、参数、命令顺序、workflow 和 Release 逻辑视为稳定基线。

- 只修改完成当前任务所必需的文件。
- 不得顺手格式化、重构、改名或清理无关代码。
- 不得擅自替换已验证有效的命令、参数、程序、路径或执行顺序。
- 不得仅因为 AI 更偏好另一种写法就重写上游脚本。
- 修改前必须完整阅读相关文件及其调用链，检查重复命令、路径、变量、引号、权限和执行顺序。
- 提交前必须检查完整 diff，确认没有遗漏、误改和无关变更。

## 4. 公开仓库的许可证与资产规则

这是 Public 仓库。所有新增并提交到 Git 历史、Git LFS、Actions artifact 或 Release 的第三方文件，都必须确认允许公开再分发。

严格禁止：

- 提交来源不明、无明确再分发许可或不适合公开分发的第三方资产。
- 从旧私有版本直接复制来源不明的私有二进制或其他仅因“以前能用”而存在的资产。
- 提交 token、密码、Cookie、SSH key、API key、个人配置、浏览器数据或其他凭据。
- 提交无法说明来源和许可证的预编译 `.so`、可执行文件或大型二进制资产。

如果确实需要新增第三方二进制或资源：

1. 先确认来源；
2. 核对许可证和再分发条件；
3. 能由 Arch Linux 官方仓库、AUR 或官方上游在构建时获取的，优先在 GitHub Actions 中动态获取，不直接塞进仓库；
4. 无法确认再分发权限时，不得加入 Public 仓库或 Release。

## 5. 旧私有版本迁移规则

旧私有自定义版本只能作为历史实现参考，不得整仓复制到本 Public Fork。

迁移任何旧修改前必须逐项判断：

- 该修改现在是否仍然需要；
- 上游是否已经提供等价或更好的修复；
- 是否与当前上游代码兼容；
- 是否涉及私有文件、未知二进制或许可证风险；
- 是否会破坏本仓库的每日构建和 `latest` Release。

只迁移当前仍有明确价值、来源清楚、适合公开并且经过核对的自定义修改。

## 6. GitHub Actions 规则

本仓库是 Public 仓库。正常、必要的 GitHub-hosted Actions 构建和验证不应为了节省 Private 仓库 Actions 分钟而省略。

本 Fork 的自定义长期发布入口是：

`/.github/workflows/custom-daily-release.yml`

该 workflow 的稳定目标：

- 每天自动构建一次；
- 核心构建文件发生变化时自动构建；
- 保留 `workflow_dispatch` 手动入口；
- 发布到固定的 `latest` Release；
- 避免每天创建新的时间戳 Release；
- 超过 GitHub 单文件 Release 限制时自动分卷；
- 同时发布 SHA-256 校验文件和包列表；
- 使用 concurrency 防止同一发布任务重复并行运行。

除非用户明确要求，不要把上游自带的 `conty.yml`、`utils.yml`、`conty-autorelease.yml` 大规模重写成本 Fork 的私有格式。优先把本仓库专用逻辑放在 `custom-*` 文件中，降低后续同步上游时的冲突。

修改 workflow 前必须检查：

- YAML 语法；
- `on` 触发条件；
- `permissions`；
- runner / container；
- Action 版本；
- 构建依赖；
- artifact 获取逻辑；
- 文件大小和分卷逻辑；
- Release tag / asset 名；
- `GITHUB_TOKEN` 权限；
- 是否可能形成无限触发或重复发布。

不得通过反复提交、等待 Actions 失败再逐项修改的方式作为主要试错手段。提交前应尽可能完成静态检查。

## 7. Release 规则

本 Fork 使用固定 `latest` Release 作为个人持续构建入口。

- `latest` 必须代表本 Fork 当前最新成功构建。
- 构建失败时不得覆盖已有可用 Release。
- 不得上传空文件或伪造成功产物。
- 资产名称必须稳定。
- 如果 `conty.sh` 超过 GitHub Release 单文件限制，应分卷发布，并在 Release 说明中给出明确合并命令。
- 必须生成 `SHA256SUMS`。
- 能取得时应同时发布容器内包列表。
- 本 Fork 的 `latest` 发布逻辑不得删除或修改与它无关的其他 Release。

## 8. 上游同步规则

用户要求检查或同步上游时：

1. 读取 `Kron4ek/Conty` 最新提交；
2. 比较上游与本 Fork；
3. 先区分“上游新增/修复”和“本 Fork 自定义”；
4. 检查上游变更是否影响本 Fork 的包列表、构建、runtime、utils 或 workflow；
5. 只合并需要的内容；
6. 保留 `AGENTS.md`、本 Fork 的 `custom-*` workflow 和明确的自定义逻辑；
7. 完整检查最终 diff 后再提交。

不要机械点击或模拟“Sync fork”后就认为任务完成；存在本地自定义时必须检查实际差异。

## 9. 构建和安全审计

区分 GitHub Actions 构建期行为与最终 `conty.sh` 运行时行为。

构建期可以在临时 GitHub runner 中使用 `sudo`、`mount`、`chroot`、`pacman` 等完成 Conty 构建，这不等于最终产物会对用户宿主系统执行同样操作。

当用户询问“会不会乱改系统、有没有额外权限或夹带内容”时，应重点审计：

- `conty-start.sh`；
- bubblewrap / mount 参数；
- 更新逻辑；
- 对 `$HOME`、`~/.local/share/Conty` 等路径的写入；
- `sudo` / setuid / capabilities；
- 网络下载与执行；
- Release 产物实际来源。

结论必须区分静态代码审计、CI 构建验证和实际运行验证，不能把“未发现”描述成“绝对不存在”。

## 10. 提交方式

本仓库默认直接维护 `master`，不创建无意义测试分支。

提交前必须：

- 确认当前 `master` 没有在检查期间发生意外变化；
- 检查完整 diff；
- 确认只改了当前任务需要的文件；
- 检查 YAML / Shell 语法和路径引用；
- 确认没有引入私有资产、凭据或许可证风险。

尽量一次提交完成一组已经完整检查的相关修改，避免为了修同一个问题连续制造多个小修补提交。

## 11. AI 工作顺序

每次任务按以下顺序执行：

1. 读取本 `AGENTS.md`；
2. 读取当前任务涉及的全部仓库文件；
3. 涉及上游基线时读取并比较 `Kron4ek/Conty`；
4. 必要时参考旧实现，但不直接复制高风险资产；
5. 设计一套最小、可维护方案；
6. 静态检查；
7. 检查完整 diff；
8. 提交到 `master`；
9. 涉及 Actions 时继续检查对应 run、Job、日志和 Release 结果；
10. 最后简要说明修改文件、提交和验证结果。
