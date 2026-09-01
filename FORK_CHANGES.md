# Fork changes from upstream

本文档记录 `newyorkthink/Conty` 相对上游 `Kron4ek/Conty` 的当前主要差异，方便新机器部署、后续自己维护，以及 AI 接手时快速判断哪些内容是本 fork 的自定义修改。

对比基准：上游共同基线提交 `314f60dd857172f8119a5487502ed14398d38d2d`。当前 fork 在该基线上继续维护。

## GitHub Actions

- 删除上游 `.github/workflows/conty-autorelease.yml`。
- 删除上游 `.github/workflows/conty.yml`。
- 新增 `.github/workflows/custom-daily-release.yml`。
- Custom Daily Release 每天北京时间 00:00 自动构建，同时在关键构建文件变化时触发。
- 构建完成后更新 `latest` Release，并生成 `SHA256SUMS`；当 `conty.sh` 超过 GitHub Release 单文件限制时自动分卷。
- 构建时会复制本 fork 的 `share/fonts/` 字体资源和 `share/lib/libpixbufloader-svg.so`。

## 构建环境

### `create-arch-bootstrap.sh`

相对上游增加了本 fork 所需的 Arch Linux CN 仓库配置，并加入 GTK/GDK 兼容处理，用于把相关 immodules / pixbuf loader 放到 Conty 运行时可直接找到的位置。

此前曾临时加入“强制重装 `librime` 并检查 `librime-lua.so`”逻辑，现已撤销。旧版镜像实测本来就包含 `librime-lua.so`，该逻辑不是必要修复。

## 软件包配置

### `settings.sh`

上游配置主要偏 Wine / 游戏运行环境；本 fork 已改为更完整的通用桌面、工具和中文输入环境，包括：

- 大幅调整 `PACKAGES`，加入常用 CLI、文件系统、网络、桌面、Qt、GTK、多媒体、远程连接和系统工具。
- 加入完整 Fcitx5 / IBus 输入法环境，以及多种 Rime 方案和 `rime-wanxiang-pinyin`。
- 加入中文字体、Noto 字体等字体环境。
- 保留 PulseAudio 路线，明确不把 PipeWire 作为本 fork 的默认音频方案。
- 当前 `AUR_PACKAGES=()`，不再沿用上游默认的 `faugus-launcher-git`。
- 当前启用 `USE_DWARFS=1`。
- 文件顶部保留已验证的软件兼容性备注，例如 Dolphin、KDE Connect、PipeWire、EasyEffects / lsp-plugins 等。

## 自定义资源

新增 `share/fonts/monolisa/`，包含 MonoLisa 多个字重及斜体字体文件。

新增：

```text
share/lib/libpixbufloader-svg.so
```

该文件会在 Custom Daily Release 构建阶段复制进镜像的 GDK Pixbuf loader 路径和 `/usr/lib/`。

## 仓库维护规则

新增 `AGENTS.md`，用于约束后续 AI / 自动化维护方式。修改仓库时应先阅读该文件，避免无关改动、重复试错和不必要的 Actions 构建。

新增 `MAINTENANCE_NOTES.md`，用于记录已经确认的问题、撤销的临时修复以及踩过的坑。

## 已确认的输入法坑

Fcitx5 + Rime 万象拼音曾出现“只能输入字母、没有候选框”。最终根因不是 Conty 缺少 `librime-lua.so`，而是用户目录中的：

```text
~/.local/share/fcitx5/rime/wanxiang.custom.yaml
```

残留了较新万象配置：

```text
lua_filter@*wanxiang.user_predict*F
```

而 Conty 当前使用的 `rime-wanxiang 17.9.2` 对应：

```text
wanxiang.context_reorder
```

修复方式是把用户配置改为 `context_reorder`，删除 `~/.local/share/fcitx5/rime/build` 生成缓存，然后重启 Fcitx5。

## 当前相对上游的文件级差异

根据当前 fork 与共同基线对比，主要差异文件为：

```text
.github/workflows/conty-autorelease.yml        removed
.github/workflows/conty.yml                    removed
.github/workflows/custom-daily-release.yml     added
AGENTS.md                                      added
MAINTENANCE_NOTES.md                           added
create-arch-bootstrap.sh                       modified
settings.sh                                    modified
share/fonts/monolisa/*                         added
share/lib/libpixbufloader-svg.so               added
```

以后如果继续同步上游，先重新比较 `Kron4ek/Conty` 与本 fork，再更新本文档；不要把本文件当作替代 Git diff 的绝对事实来源。
