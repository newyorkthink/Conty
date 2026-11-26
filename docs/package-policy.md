# 软件包增删与黑名单规则

本文档记录 `settings.sh` 中明确禁止加入、已剔除以及必须保留的软件包。后续增减软件包前，先对照本文档核对，避免重复踩坑或误删关键兼容依赖。

## 禁止加入（已知异常或架构冲突）

| 包名 | 原因 |
| --- | --- |
| `dolphin` | Conty 容器内无法正常启动 |
| `kdeconnect` | Conty 容器内无法正常启动 |
| `pipewire` | 可能与 PulseAudio 冲突，且依赖 systemd 后台常驻服务 |
| `easyeffects` | 生成大量无用桌面图标，污染启动器菜单 |
| `lsp-plugins` | 生成大量无用桌面图标，污染启动器菜单 |

> 架构限制说明：
> - 依赖 systemd 常驻运行或接管宿主机硬件/网络的系统守护进程不适合放入 Conty。
> - 需要直接拉起宿主机 FUSE AppImage 的应用启动器在 Conty 内会受 `bwrap` 的 `NoNewPrivs` 限制导致 FUSE 挂载失败，不建议新增到容器内。

## 已剔除的冗余包（避免误加回）

| 包名 | 原因 |
| --- | --- |
| `audacity` | 大体积音频剪辑软件，非桌面基础组件 |
| `cmatrix` | 纯娱乐终端字符雨动画 |
| `cython` | Python C 扩展编译工具，运行普通 Python 程序不需要（标准 `python` 保留） |
| `dhclient` | 宿主机 DHCP 客户端守护进程，容器内无法接管网卡 |
| `dhcpcd` | 宿主机 DHCP 守护进程，容器内无法接管网卡 |
| `haskell-alsa-core` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haskell-alsa-mixer` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haskell-bzlib` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haskell-graphscc` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haskell-pandoc-lua-engine` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haskell-pandoc-lua-marshal` | Haskell 动态库，会拉入整套 GHC 运行时，桌面无需求 |
| `haveged` | 旧内核熵守护进程，现代内核已淘汰且容器内无法常驻 |
| `hostapd` | Wi-Fi 热点服务端，需要独占宿主机无线网卡 |
| `hplip` | 惠普打印机驱动大套件，容器内无法管理系统打印服务 |
| `hspell` | 希伯来语拼写检查库 |
| `ibus-anthy` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-chewing` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-hangul` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-kkc` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-libpinyin` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-rime` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-skk` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-sunpinyin` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-table` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-table-chinese` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-table-extraphrase` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-typing-booster` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ibus-unikey` | 重复的 IBus 输入法引擎（已用 `fcitx5`，仅保留 `ibus` 本体） |
| `ipython` | Python 交互开发终端（标准 `python` 保留） |
| `libvoikko` | 芬兰语拼写检查库 |
| `mangohud` | 游戏 FPS 监控浮窗 |
| `mkinitcpio-nfs-utils` | Arch 开机 initramfs 网络引导钩子，容器不引导内核 |
| `netctl` | 宿主机网络管理服务，容器内无法接管网卡 |
| `openbox` | 窗口管理器，容器内用不到 |
| `openpgl` | Intel 离线光线追踪渲染库，桌面基础环境无需求 |
| `rxvt-unicode` | 已有 `lxterminal`、`xterm` 备用终端，减少重复菜单图标 |
| `shutter` | 截图工具，拉入大量 Perl 依赖并增加菜单图标 |
| `squid` | HTTP 缓存代理服务端，容器内无法常驻 |
| `xorg-server-devel` | 纯编译期 C 头文件，运行程序不需要 |

## 必留保护清单（精简时不得误删）

| 包名 / 配置项 | 原因 |
| --- | --- |
| `ibus`（本体） | `create-arch-bootstrap.sh` 会直接复制 `im-ibus.so`，且部分 GTK/Electron 程序依赖 IBus 客户端模块兼容 `fcitx5` |
| `fcitx5-*` 与 `rime-*`（含 `rime-wanxiang-pinyin`） | 核心中文输入与万象拼音运行环境 |
| `gnome-settings-daemon` 等 GNOME 基础组件 | 间接提供 GTK3/GTK4 所需的 GSettings schemas 与主题支持，全删可能导致独立 GTK 程序显示不完整 |
| `libnotify` | 桌面通知基础库 |
| `at-spi2-core` | GTK 与桌面无障碍总线基础库 |
| `libxft` | X11 字体渲染基础库（保留一处即可，避免重复登记） |
| `chromium` | 跨机通用应急浏览器 |
| `LOCALES`（25 项） | 保持与上游 `Kron4ek/Conty` 默认配置一致，减少同步分叉 |

## 增删包前核对原则

1. 先核对上方黑名单与保护清单，确认不触发已知启动失败、冲突或构建硬依赖。
2. 避免引入依赖 systemd 守护进程的系统服务、整套无关语言运行时或大量无用桌面菜单图标。
3. 以“跨机器通用桌面基础环境”为基准，不按单台机器已有软件过度裁剪基础运行库与应急工具。
