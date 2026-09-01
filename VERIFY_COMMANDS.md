# 构建后验证命令

本文档用于验证 Conty 构建产物中的关键组件是否仍然存在并可用。用于新机器、重新构建、同步上游或修改 `settings.sh` / `create-arch-bootstrap.sh` 后快速核对。

以下命令默认在包含 `conty.sh` 的目录执行；如果实际文件名是 `archlinux`，把命令中的 `./conty.sh` 替换为 `./archlinux`。

所有直接运行 Conty 的验证命令统一使用 `NVIDIA_HANDLER=0`，避免 NVIDIA 相关逻辑干扰本次检查。

## 1. 验证 MonoLisa 字体是否已打包

```bash
NVIDIA_HANDLER=0 ./conty.sh sh -c "find /usr/share/fonts -type f -iname 'MonoLisa*.ttf' | sort"
```

正常结果：应列出 `MonoLisa-Regular.ttf`、`MonoLisa-Bold.ttf` 等字体文件。

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

## 4. 验证 Rime 相关软件包是否存在

```bash
NVIDIA_HANDLER=0 ./conty.sh pacman -Q fcitx5-rime librime
```

正常结果：应同时输出 `fcitx5-rime` 和 `librime` 的已安装版本。

## 5. 验证万象拼音是否已安装

```bash
NVIDIA_HANDLER=0 ./conty.sh pacman -Q rime-wanxiang-pinyin
```

正常结果：应输出 `rime-wanxiang-pinyin` 的已安装版本。

## 6. 验证万象主 schema 是否存在

```bash
NVIDIA_HANDLER=0 ./conty.sh ls -l /usr/share/rime-data/wanxiang.schema.yaml
```

正常结果：应能正常列出 `/usr/share/rime-data/wanxiang.schema.yaml`。

## 7. 验证当前万象版本使用的 Lua 组件

```bash
NVIDIA_HANDLER=0 ./conty.sh grep -nE 'user_predict|context_reorder' /usr/share/rime-data/wanxiang.schema.yaml
```

当前仓库使用的 `rime-wanxiang 17.9.2` 应看到 `wanxiang.context_reorder` 相关内容。

如果用户目录中的 `wanxiang.custom.yaml` 仍引用 `wanxiang.user_predict`，会产生版本不匹配，应先检查用户侧配置，不要误判为 Conty 缺包。

## 8. 验证 librime Lua 插件是否存在

```bash
NVIDIA_HANDLER=0 ./conty.sh ls -l /usr/lib/rime-plugins/librime-lua.so
```

正常结果：应能正常列出 `librime-lua.so`。

注意：该文件原本就会随正常构建进入镜像，不需要额外强制重装 `librime`。

## 9. 验证 Rime / Lua 插件实际能加载

先关闭当前正在运行的 Fcitx5，再前台启动 Conty 内的 Fcitx5：

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
test -f /usr/share/rime-data/wanxiang.schema.yaml; \
test -f /usr/lib/rime-plugins/librime-lua.so; \
test -f /usr/lib/libpixbufloader-svg.so; \
find /usr/share/fonts -type f -iname 'MonoLisa-Regular.ttf' | grep -q .; \
pacman -Q fcitx5-rime librime rime-wanxiang-pinyin; \
echo '关键组件检查通过'"
```

出现 `关键组件检查通过`，说明字体、Rime、万象拼音、Lua 插件和自定义 Pixbuf loader 这些关键项目都已存在。

## 验证原则

- 优先验证构建产物内部是否存在，不凭配置文件推测。
- Fcitx5 自带 Pinyin 正常、万象异常时，优先检查用户侧 Rime 配置版本是否与镜像内万象版本一致。
- 不因为单个用户配置错误去修改已经验证正常的 Conty 构建基线。
- 修改中文输入、字体、Rime、万象、GTK/GDK 或软件包列表后，至少重新执行本文对应项目的验证命令。
