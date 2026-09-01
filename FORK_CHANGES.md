# Conty Fork 中文基准与修改说明

本文档作为 `newyorkthink/Conty` 的长期基准说明，记录本 fork 相对上游 `Kron4ek/Conty` 的实际修改、构建逻辑、中文输入环境、已确认问题和后续维护边界。

本文只记录仓库本身，不记录任何个人设备、宿主系统、账户、路径习惯或其他个人环境信息。

## 对比基准

- 上游仓库：`Kron4ek/Conty`
- 当前 fork：`newyorkthink/Conty`
- 当前默认分支：`master`
- 共同基线提交：`314f60dd857172f8119a5487502ed14398d38d2d`
- 后续修改均以该共同基线为起点继续维护。

以后判断“本 fork 改了什么”时，应先以该基线和当前 `master` 做 Git diff；本文档用于解释修改目的和已确认结论，不替代 Git diff。

## 本 fork 的总体定位

上游 Conty 更偏通用便携 Arch Linux / Wine / 游戏运行环境。本 fork 在此基础上扩展为更完整的 Arch Linux 桌面运行环境，并重点保留：

- 常用 CLI、网络、文件系统、桌面和系统工具。
- Qt、GTK、多媒体、远程连接等运行依赖。
- 完整中文字体和中文输入环境。
- Fcitx5、IBus、Rime 及多种 Rime 输入方案。
- `rime-wanxiang-pinyin` 万象拼音。
- 自定义字体和 GDK Pixbuf 兼容资源。
- 自动构建并持续更新 `latest` Release。

中文输入相关内容属于当前 fork 的明确组成部分，后续维护不得因为调整镜像、Action 或构建流程而误删。

## GitHub Actions

### 已删除的上游工作流

相对共同基线删除：

```text
.github/workflows/conty-autorelease.yml
.github/workflows/conty.yml
```

### 当前主工作流

新增：

```text
.github/workflows/custom-daily-release.yml
```

工作流名称为 `Custom Daily Release`，运行环境为 `ubuntu-22.04`。

当前触发方式：

- 定时：每天北京时间 00:00，即 UTC 16:00。
- Push：关键构建文件、`share/**` 或该 workflow 本身变化时触发。
- 手动：支持 `workflow_dispatch`。

当前**没有 `concurrency` 并发锁**。自动触发、Push 触发和手动触发的多个 `Custom Daily Release` 可以并行运行，不应因为同一 concurrency group 进入 `Waiting`。

### 构建流程

主流程为：

1. Checkout 仓库。
2. 尝试下载已有 Utils artifact；没有则忽略。
3. 执行 `create-arch-bootstrap.sh` 构建 Arch bootstrap。
4. 把 `share/fonts/` 复制进镜像字体目录。
5. 把 `share/lib/libpixbufloader-svg.so` 复制进 GDK Pixbuf loader 路径和 `/usr/lib/`。
6. 执行 `create-conty.sh` 生成 Conty。
7. 收集包列表和许可证信息。
8. 生成 `SHA256SUMS`。
9. 更新 GitHub `latest` Release。

当 `conty.sh` 超过 GitHub Release 单文件大小限制时，workflow 会自动分卷为 `conty.sh.part*`，Release 说明中提供重新合并方法。

## `create-arch-bootstrap.sh` 的修改

### Arch Linux CN

相对上游增加 Arch Linux CN 仓库配置，并安装对应 keyring，使 `settings.sh` 中需要从 Arch Linux CN 获取的软件包可以正常进入镜像。

这部分与中文输入环境直接相关，因为当前万象拼音等软件包来自当前 Arch / Arch Linux CN 软件源体系。后续不得为了简化 bootstrap 随意删除 Arch Linux CN 配置而不先核对 `settings.sh` 的依赖。

### Chaotic-AUR bootstrap 多镜像回退

此前 bootstrap 下载 Chaotic-AUR 的：

```text
chaotic-keyring.pkg.tar.zst
chaotic-mirrorlist.pkg.tar.zst
```

时固定使用：

```text
cdn-mirror.chaotic.cx
```

GitHub Actions 中连续出现该 CDN 返回 HTTP 503，导致 `Build Arch bootstrap` 直接失败。

现在改为：

- 优先使用官方 `geo-mirror`。
- 失败后回退到官方 CDN。
- 再回退到多个官方美国镜像。
- 每个镜像带自动重试。
- `keyring` 和 `mirrorlist` 先下载成本地包，再交给 chroot 内的 `pacman -U` 安装。
- 只有所有配置镜像都失败时才终止构建。

**该修改只处理 Chaotic-AUR keyring/mirrorlist 的下载可靠性，不会删除、替换或关闭中文字体、Fcitx5、Rime、万象拼音、Arch Linux CN 或其他中文环境。**

### GTK / GDK 兼容处理

保留本 fork 的 GTK/GDK 兼容逻辑，包括把相关 immodules / pixbuf loader 放到 Conty 运行时可以直接找到的位置，用于减少部分 GTK 程序的运行时加载问题。

## `settings.sh` 的修改

相对共同基线，`settings.sh` 已进行较大调整。

### 软件包范围

当前 `PACKAGES` 相比上游更完整，包含：

- 常用 CLI 和系统工具。
- 文件系统及压缩相关工具。
- 网络工具。
- Qt / GTK 桌面运行依赖。
- 多媒体组件。
- 远程连接组件。
- 中文字体。
- Fcitx5 / IBus / Rime 中文输入环境。
- 多种 Rime 输入方案。
- `rime-wanxiang-pinyin` 万象拼音。

### 中文输入环境

当前 fork 明确保留：

```text
fcitx5
fcitx5-rime
fcitx5-qt
ibus
ibus-rime
rime-wanxiang-pinyin
```

以及仓库当前 `settings.sh` 中列出的其他 Rime 方案和中文字体包。

后续如果修改软件包列表，必须先检查这些输入法包之间的依赖和当前万象版本，不能因为某个故障临时删掉整套中文输入环境。

### 音频路线

当前配置继续使用 PulseAudio 路线，不把 PipeWire 作为本 fork 的默认音频方案。`settings.sh` 顶部已有相关兼容性备注，应保留这些已经验证过的说明。

### AUR 和压缩格式

当前状态：

```text
AUR_PACKAGES=()
USE_DWARFS=1
```

不再沿用上游默认的 `faugus-launcher-git` AUR 配置；当前 Conty 构建启用 DwarFS。

## 自定义资源

### MonoLisa 字体

新增：

```text
share/fonts/monolisa/
```

包含 MonoLisa 多个字重及对应斜体字体。Custom Daily Release 会把 `share/fonts/` 下的内容复制进构建后的 Arch 文件系统。

### GDK Pixbuf SVG loader

新增：

```text
share/lib/libpixbufloader-svg.so
```

构建时复制到：

```text
/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/
/usr/lib/
```

用于相关 GTK/GDK 程序运行时加载。

## 已确认的 Rime / 万象拼音坑

### 现象

Fcitx5 自带 Pinyin 可以正常显示候选框，但切换到 Rime 万象拼音后只能输入字母或候选生成失败。

前台日志曾出现：

```text
module 'wanxiang.user_predict' not found
```

### 已确认根因

根因不是 Conty 缺少 `librime-lua.so`，而是用户侧万象自定义配置与 Conty 内当前万象版本不匹配。

用户配置中曾残留较新版本写法：

```text
lua_filter@*wanxiang.user_predict*F
```

而当前 Conty 使用的 `rime-wanxiang 17.9.2` 对应的是：

```text
wanxiang.context_reorder
```

该版本本来就没有：

```text
lua/wanxiang/user_predict.lua
```

因此 Rime 可以接收到按键，但万象 Lua 组件加载失败，最终表现为候选异常。

### 已验证处理方法

将用户侧 `wanxiang.custom.yaml` 中的：

```text
wanxiang.user_predict
```

改为：

```text
wanxiang.context_reorder
```

然后删除 Rime 生成缓存：

```text
~/.local/share/fcitx5/rime/build
```

再重启 Fcitx5。

### `librime-lua.so` 结论

此前曾临时在 `create-arch-bootstrap.sh` 中加入：

- 强制再次安装 `librime`。
- 强制检查 `/usr/lib/rime-plugins/librime-lua.so`，不存在则构建失败。

后续使用未加入该临时修复的旧版 Conty 实际验证：

- 旧版镜像本来就存在 `/usr/lib/rime-plugins/librime-lua.so`。
- 在修正 `user_predict` / `context_reorder` 版本不匹配后，旧版也可以正常中文输入。

因此上述“强制重装 `librime` + 强制检查 `librime-lua.so`”已经撤销，不属于必要修复。

以后遇到相同症状，应优先比较：

```text
用户 wanxiang.custom.yaml
用户 build/wanxiang.schema.yaml
Conty /usr/share/rime-data/wanxiang.schema.yaml
```

确认万象版本是否一致，不要先误判成 `librime-lua.so` 缺失。

## Codespell

`.codespellrc` 已加入对 `rime` 的忽略，避免仓库文档中的 Rime 输入法名称被误判成普通英文拼写错误。

这只是拼写检查配置，不改变任何输入法或构建行为。

## 仓库维护文件

### `AGENTS.md`

用于约束后续 AI / 自动化对仓库的修改方式。继续维护前应先阅读，避免：

- 未完整检查现有代码就修改。
- 改动已经验证稳定的基线。
- 无关重构。
- 连续触发无意义 Actions。
- 同一个问题反复生成多个试错版本。

### `MAINTENANCE_NOTES.md`

用于记录已经确认的问题、撤销的临时修复和踩过的坑。

### `FORK_CHANGES.md`

即本文档。用于说明“整个 fork 相对共同基线改了什么、为什么改、哪些结论已经确认”。

## 当前相对共同基线的文件级差异

经重新对比共同基线 `314f60dd857172f8119a5487502ed14398d38d2d` 与当前 `master`，当前差异范围包括：

```text
.codespellrc                                  modified
.github/workflows/conty-autorelease.yml       removed
.github/workflows/conty.yml                   removed
.github/workflows/custom-daily-release.yml    added
AGENTS.md                                     added
FORK_CHANGES.md                               added
MAINTENANCE_NOTES.md                          added
create-arch-bootstrap.sh                      modified
settings.sh                                   modified
share/fonts/monolisa/*                        added
share/lib/libpixbufloader-svg.so              added
```

其中 MonoLisa 字体目录包含多个字重和斜体文件，因此 Git diff 中会显示为多项二进制字体文件。

## 后续同步上游时的基线规则

以后同步 `Kron4ek/Conty` 时按以下原则处理：

1. 先确定新的上游基线和当前 fork 的共同祖先。
2. 重新做完整 Git diff，不只依赖本文档。
3. 优先保留已经确认有效的中文输入环境、Arch Linux CN、GTK/GDK 兼容、自定义资源和 Release 工作流。
4. 如果上游已经提供等价或更好的实现，再逐项判断是否可以删除 fork 自定义逻辑。
5. 不因为单次网络故障、临时包问题或本地用户配置问题就改动无关的稳定构建逻辑。
6. Rime / 万象问题先核对版本和用户配置，再决定是否需要改仓库。
7. 修改后统一检查 workflow 触发条件、Shell 语法、包依赖、镜像地址和 Release 生成逻辑。

本文档应随真正的仓库差异变化而更新；纯个人环境、临时机器配置和与仓库无关的信息不要写入本文档。