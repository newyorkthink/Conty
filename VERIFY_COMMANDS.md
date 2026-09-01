# 构建后验证命令

本文档用于验证 Conty 构建产物中的关键组件是否仍然存在并可用。用于重新构建、同步上游或修改 `settings.sh` / `create-arch-bootstrap.sh` 后快速核对。

以下命令默认在包含 `conty.sh` 的目录执行；如果实际文件名是 `archlinux`，把命令中的 `./conty.sh` 替换为 `./archlinux`。

所有直接运行 Conty 的验证命令统一使用 `NVIDIA_HANDLER=0`，避免 NVIDIA 相关逻辑干扰本次检查。

注意：最终 Conty 产物会清理运行时不需要的 pacman 数据，因此不要使用 `pacman -Q` 作为最终镜像验证方法。最终验证应直接检查实际文件、动态库、schema 和可执行程序是否存在。

## 1. 验证 MonoLisa 字体是否已打包

```bash
NVIDIA_HANDLER=0 ./conty.sh sh -c "find /usr/share/fonts -type f -iname 'MonoLisa*.ttf' | sort"
```

正常结果：应列出 `MonoLisa-Regular.ttf`、`MonoLisa-Bold.ttf` 等字体文件，路径应位于 Conty 内的 `/usr/share/fonts/`。

## 2. 验证中文字体是否存在

```bash
NVIDIA_HANDLER=0 ./conty.sh fc-list :lang=zh family | sort -u | head -n 30
```

正常结果：应能列出可用于中文显示的字体家族。

## 3. 验证 Fcitx5 是否已安装

```bash
NVIDIA_HANDLER=0 ./conty.sh fcitx5 --version
```

正常结果：应输出 Fcitx5 版本号。

## 4. 验证 librime 核心库和 Lua 插件

```bash
NVIDIA_HANDLER=0 ./conty.sh sh -c 'ls -l /usr/lib/librime.so* /usr/lib/rime-plugins/librime-lua.so'
```

正常结果：应看到 `librime.so`、实际版本库（例如 `librime.so.1.17.0`）以及 `/usr/lib/rime-plugins/librime-lua.so`。

这说明 librime 核心库与 Lua 插件已经实际打包进入最终 Conty，不依赖 pacman 数据库判断。

## 5. 验证 Fcitx5 Rime 组件

```bash
NVIDIA_HANDLER=0 ./conty.sh sh -c "find /usr/lib/fcitx5 -type f -iname '*rime*.so' -print 2>/dev/null"
```

正常结果：应能找到 Fcitx5 的 Rime 动态组件。

## 6. 验证万象拼音主 schema 是否存在

```bash
NVIDIA_HANDLER=0 ./conty.sh ls -l /usr/share/rime-data/wanxiang.schema.yaml
```

正常结果：应能正常列出 `/usr/share/rime-data/wanxiang.schema.yaml`。该文件存在即可证明万象拼音数据已经进入最终镜像，不需要使用 `pacman -Q rime-wanxiang-pinyin`。

## 7. 验证当前万象版本使用的 Lua 组件

```bash
NVIDIA_HANDLER=0 ./conty.sh grep -nE 'user_predict|context_reorder' /usr/share/rime-data/wanxiang.schema.yaml
```

当前构建所使用的万象版本应以镜像内 schema 的实际内容为准。此前已确认对应版本使用 `wanxiang.context_reorder`；如果用户目录中的 `wanxiang.custom.yaml` 仍引用 `wanxiang.user_predict`，会产生版本不匹配，应先检查用户侧配置，不要误判为 Conty 缺包。

## 8. 单独验证 librime Lua 插件

```bash
NVIDIA_HANDLER=0 ./conty.sh ls -l /usr/lib/rime-plugins/librime-lua.so
```

正常结果：应能正常列出 `librime-lua.so`。

注意：该文件会随正常依赖进入镜像，不需要在 `create-arch-bootstrap.sh` 中额外强制重装 `librime`，也不需要额外增加强制文件检查。

## 9. 验证 Rime / Lua 插件实际能加载

先关闭当前正在运行的 Fcitx5，再启动 Conty 内的 Fcitx5：

```bash
pkill -x fcitx5
```

```bash
NVIDIA_HANDLER=0 ./conty.sh fcitx5 -d
```

正常日志中应能看到 Rime 与 Lua 相关 addon 被加载；随后实际切换到万象拼音输入中文，确认候选框正常出现。

## 10. 验证 GDK Pixbuf 自定义 loader 是否已打包

```bash
NVIDIA_HANDLER=0 ./conty.sh ls -l /usr/lib/libpixbufloader-svg.so /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.so
```

正常结果：两个路径都应存在。

## 11. 验证 Arch Linux CN 仓库配置

```bash
NVIDIA_HANDLER=0 ./conty.sh grep -A2 '^\[archlinuxcn\]' /etc/pacman.conf
```

正常结果：应看到 `[archlinuxcn]` 以及 `https://repo.archlinuxcn.org/$arch`。

## 12. 一次性快速检查关键文件

```bash
NVIDIA_HANDLER=0 ./conty.sh sh -c "\
set -e; \
command -v fcitx5 >/dev/null; \
test -e /usr/lib/librime.so; \
test -f /usr/lib/rime-plugins/librime-lua.so; \
test -f /usr/share/rime-data/wanxiang.schema.yaml; \
test -f /usr/lib/libpixbufloader-svg.so; \
test -f /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.so; \
find /usr/share/fonts -type f -iname 'MonoLisa-Regular.ttf' | grep -q .; \
echo '关键组件检查通过'"
```

出现 `关键组件检查通过`，说明 MonoLisa、Fcitx5、librime、librime-lua、万象拼音 schema 和自定义 Pixbuf loader 等关键项目都实际存在于最终 Conty 中。

## 验证原则

- 优先验证最终构建产物内部的实际文件，不凭软件包配置推测。
- 最终 Conty 不使用 `pacman -Q` 作为验证依据，因为 pacman 数据库可能已经被构建流程清理。
- Fcitx5 自带 Pinyin 正常、万象异常时，优先检查用户侧 Rime 配置版本是否与镜像内万象版本一致。
- 不因为单个用户配置错误去修改已经验证正常的 Conty 构建基线。
- 修改中文输入、字体、Rime、万象、GTK/GDK 或软件包列表后，至少重新执行本文对应项目的验证命令。
