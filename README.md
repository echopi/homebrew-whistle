# Homebrew whistle formula

script & docs for homebrew whistle

## 资源

* [使用brew安装whistle](./whistle-formula.md)
* [更新whistle官方描述文件](./brew-pr.sh)
* [更新whistle的本地描述文件](./brew-local-update.sh)

## 常见问题

1. 优先使用Homebrew内置的nodejs，Homebrew nodejs 默认命令在 `/usr/local/bin/node`

```sh
export PATH=/usr/local/bin:$PATH w2 start/stop/restart
```

2. 如果whistle npm 版本更新了，whistle Homebrew 未更新，可以通过以下方式安装最新版本：

```sh
# 更新本地whistle描述文件
curl -s https://raw.githubusercontent.com/echopi/homebrew-whistle/master/brew-local-update.sh | bash -s --

# 更新
brew upgrade whistle
```

3. 更新Homebrew nodejs版本

```sh
brew list node
brew info node

brew update
brew upgrade node
```

## 提交pr更新Homebrew whistle版本

whistle npm更新版本后，需要更新 [homebrew-core] 的whistle描述文件。

在macOS/Linux环境下执行以下命令：

```sh
sh -c "$(curl -s https://raw.githubusercontent.com/echopi/homebrew-whistle/master/brew-pr.sh)"
```

非macOS/Linux环境需要手动提交pr到 [homebrew-core]。通过执行node脚本获得新的url、sha256：

```sh
yarn
node brew-pr.js
```

[homebrew-core]: https://github.com/Homebrew/homebrew-core
