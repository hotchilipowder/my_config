# macOS

记录一台全新的 macOS 从零配置到日常可用的过程，方便以后换机或者重装时快速恢复。
下面按实际操作顺序整理：Homebrew → Rust → Ghostty / Stats → opencode。

```{contents}
:local:
:depth: 2
```


## 1. Homebrew

一切从 Homebrew 开始，macOS 上绝大多数命令行工具和 GUI 应用都通过它安装：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Apple Silicon 安装完成后需要把 Homebrew 加入 PATH：

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

验证：

```bash
brew --version
```


## 2. Rust

Rust 通过官方的 rustup 安装（而不是 brew），这样版本管理和 toolchain 更灵活：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

安装脚本默认会把 `~/.cargo/bin` 写入 shell 配置，当前终端可以手动生效：

```bash
source "$HOME/.cargo/env"
```

验证：

```bash
rustc --version
cargo --version
```


## 3. Ghostty 与 Stats

终端和系统监控都直接用 Homebrew 的 cask 安装：

```bash
brew install --cask ghostty
brew install --cask stats
```

- [Ghostty](https://ghostty.org/)：原生、跨平台的终端模拟器，字体和主题等配置见
  {doc}`ghostty`。
- [Stats](https://github.com/exelban/stats)：显示在菜单栏的系统监控工具，可以看
  CPU、内存、网络等占用。


## 4. opencode

opencode 使用官方安装脚本，默认安装到 `~/.opencode/bin`：

```bash
curl -fsSL https://opencode.ai/install | bash
```

然后把安装目录写入 `~/.zshrc` 的 PATH：

```bash
export PATH="$HOME/.opencode/bin:$PATH"
```

验证：

```bash
opencode --version
```


## 验证

上面的步骤全部完成后，可以用下面的命令确认环境就绪：

```bash
brew --version
rustc --version
opencode --version
```

后续的终端字体、快捷键等个性化配置见 {doc}`ghostty`，其余工具链按需补充。
