# Homebrew whistle formula

script & docs for homebrew whistle

## 资源

* [使用brew安装whistle](./whistle-formula.md)
* [更新whistle官方描述文件](./brew-pr.sh)
* [更新whistle的本地描述文件](./brew-local-update.sh)

## 安装依赖

```sh
npm install
```

## 提交pr更新Homebrew whistle版本

whistle npm更新版本后，需要更新 [homebrew-core](git@github.com:Homebrew/homebrew-core.git) 的whistle描述文件。

在macOS/Linux环境下执行以下命令：

```sh
curl -s https://raw.githubusercontent.com/echopi/homebrew-whistle/master/brew-pr.sh | bash -s --
```

非macOS/Linux环境需要手动提交pr到 [homebrew-core](git@github.com:Homebrew/homebrew-core.git)。通过执行node脚本获得新的url、sha256：

```sh
node brew-pr.js
```

[homebrew-core]: git@github.com:Homebrew/homebrew-core.git
