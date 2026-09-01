# 仓库维护记录

用于记录本 fork 相对上游/默认行为的重要修改，以及已经踩过的坑，方便后续自己或 AI 继续维护时快速判断。

## 当前修改

### 2026-09-01：撤销额外的 librime 强制重装与文件检查

此前在 `create-arch-bootstrap.sh` 中额外加入了：

- 构建后再次执行 `pacman --noconfirm -S librime`。
- 强制检查 `/usr/lib/rime-plugins/librime-lua.so`，缺失时终止构建。

现已删除这两段额外逻辑。

原因：使用未加入该修复的旧版 `archlinux` 实际验证，`/usr/lib/rime-plugins/librime-lua.so` 本来就存在，而且在修正万象配置后可以正常中文输入。因此这次故障并不是 Conty 缺少 `librime-lua.so`，不需要额外重装 `librime` 或增加该文件的构建检查。

### 2026-09-01：Chaotic-AUR bootstrap 增加官方多镜像回退

连续两次手动运行 Custom Daily Release 都在 `Build Arch bootstrap` 阶段失败，错误为 `cdn-mirror.chaotic.cx` 返回 HTTP 503。此前成功的 push 构建与手动构建执行的是同一套 workflow 和 bootstrap 逻辑；已观察到成功构建运行在 `northcentralus`，失败的手动构建运行在 `westus2`，说明问题不在 `workflow_dispatch` 分支，而在 bootstrap 把 Chaotic-AUR keyring/mirrorlist 下载锁死到单一 CDN 端点。

现已将 Chaotic-AUR bootstrap 改为：优先使用官方 `geo-mirror`，失败后依次回退到官方 CDN 和多个美国官方镜像；每个镜像带重试。两个 bootstrap 包先下载到本地，再由 chroot 内的 pacman 安装，避免 pacman 重新锁定单一 CDN URL。仅当所有配置镜像都失败时才终止构建。

## 踩过的坑

### Fcitx5 + Rime 万象拼音无候选框

现象：Fcitx5 自带 Pinyin 可以正常显示候选框，但 Rime 万象拼音只能输入字母、没有正常候选；前台日志出现：

```text
module 'wanxiang.user_predict' not found
```

真实原因是用户侧万象配置和 Conty 内的万象版本不匹配：

- 用户文件 `~/.local/share/fcitx5/rime/wanxiang.custom.yaml` 残留新版配置：
  `lua_filter@*wanxiang.user_predict*F`
- Conty 当前 `rime-wanxiang 17.9.2` 使用的是：
  `wanxiang.context_reorder`
- 该版本本来就没有 `lua/wanxiang/user_predict.lua`。

处理方法：把用户配置中的 `wanxiang.user_predict` 改为 `wanxiang.context_reorder`，删除 `~/.local/share/fcitx5/rime/build` 生成缓存后重启 Fcitx5。

维护注意：以后遇到相同症状，先检查用户侧 `wanxiang.custom.yaml`、`build/wanxiang.schema.yaml` 与 Conty 内 `/usr/share/rime-data/wanxiang.schema.yaml` 是否版本一致；不要先误判为缺少 `librime-lua.so`。
