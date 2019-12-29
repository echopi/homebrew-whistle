# whistle ❤️ Homebrew

> [whistle]: HTTP, HTTP2, HTTPS, Websocket debugging proxy
> [Homebrew]: The Missing Package Manager for macOS (or Linux)

## 如何安装

```sh
# 卸载whistle命令
w2 stop
npm uni -g whistle
# or yarn global remove whistle

# brew install
brew update
brew install whistle
w2 start

# 更新
brew upgrade whistle
```

如果whistle npm 版本更新了，whistle Homebrew 未更新，可以通过以下方式安装最新版本：

```sh
# 更新本地whistle描述文件


```

## 如何发布whistle到Homebrew

以下以 whistle 为例，介绍如何把 npm 模块发布到 [Homebrew]。

简单地讲，就是生成一份合法的包描述文件 (formula)，提交到 homebrew 官方描述仓库 ([homebrew-core])。用户可以通过更新本地描述文件来安装对应的包。

版本更新则通过更新包描述的下载地址和sha256来实现。

## 1. 创建包描述

### 1.0 概览

1. 描述文件 whistle.rb
2. 本地安装、测试
3. brew audit
4. pr, [参考](https://github.com/Homebrew/homebrew-core/pull/48268)

### 1.1 whistle.rb

这里使用 [homebrew-npm-noob] 为 whistle 生成一份 Homebrew formula:

```sh
pip install homebrew-npm-noob
# or
# brew install zmwangx/npm-noob/noob

noob whistle > whistle.rb
```

会生成如下类似内容，保存为 whistle.rb

```rb
require "language/node"

class Whistle < Formula
	...
```

稍作修改：

* npm 下载地址已经包含了版本信息，version 字段不需重复添加
* test 可以添加安装后的启停脚本

具体参考 [whistle.rb]

### 1.2 本地安装、测试

```sh
brew install --build-from-source whistle
brew test whistle
```

### 1.3 brew audit

```sh
brew audit --new-formula whistle
brew audit --strict whistle
```

### 1.4 pull request

fork [homebrew-core]，提交 whistle.rb，提交信息按 `$package $x.y.z (new formula)` 格式提交

```sh
git commit -m 'whistle 2.4.2 (new formula)'
```

### 1.5 命令汇总

1. noob whistle > whistle.rb
2. brew install --build-from-source whistle
3. brew test whistle
4. brew audit --new-formula whistle
4. git commit: whistle 2.4.2 (new formula)

更多：[Contributing to Homebrew]

## 2. 更新包描述

<!-- 更新 whistle.rb 的版本相关信息，先进行本地测试：

```sh
brew uninstall --force whistle
brew install --build-from-source whistle
brew test whistle
brew audit --strict whistle
``` -->

brew 提供了命令，[更多](https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md#to-submit-a-version-upgrade-for-the-foo-formula)：

```sh
brew bump-formula-pr --strict whistle --url=$url --sha256=$sha256
```

以上命令可以通过 [brew-pr.js] 来生成。

## 参考

* [Node for Formula Authors](https://docs.brew.sh/Node-for-Formula-Authors)
* [Contributing to Homebrew]
* [Acceptable Formulae](https://docs.brew.sh/Acceptable-Formulae)
* [homebrew-npm-noob]

[Contributing to Homebrew]: https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md
[homebrew-npm-noob]: https://github.com/zmwangx/homebrew-npm-noob
[homebrew-core]: git@github.com:Homebrew/homebrew-core.git
[Homebrew]: https://brew.sh/
[whistle.rb]: https://github.com/Homebrew/homebrew-core/blob/master/Formula/whistle.rb
[How to Create and Maintain a Tap]: https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap
[whistle]: https://github.com/avwo/whistle
[brew-pr.js]: ./brew-pr.js
[brew-local-update.js]: ./brew-local-update.js
