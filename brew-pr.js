'use strict';

const crypto = require('crypto');
const fetch = require('node-fetch');
const {execSync} = require('child_process');

const npm_registry = 'https://registry.npmjs.org';
// const npm_registry = 'https://registry.npm.taobao.org';

const remote_formula_url = 'https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/whistle.rb';
const brew_existed = '0' !== execSync(`command -v brew >/dev/null 2>&1 || echo '0'`).toString().trim();

function get_pr_cmd(url, sha256) {
  return `brew bump-formula-pr --strict whistle --url=${url} --sha256=${sha256}`
}

async function main() {
  const formula_res = await fetch(remote_formula_url);
  const formula_content = await formula_res.text();
  const remote_tarball = (formula_content.match(/url "(https:\/\/[^"]+)"/)|| [])[1];
  if (!remote_tarball) return;

  const res = await fetch(`${npm_registry}/whistle/latest`);
  const data = await res.json();
  const {tarball, shasum /* SHA-1 */} = data.dist;

  if (remote_tarball === tarball) {
    console.log('👋 no need to pr!');
    return;
  }
  const digester = crypto.createHash('sha256').setEncoding('hex');
  fetch(tarball).then(res => {
    res.body.pipe(digester).once('finish', () => {
      const url = tarball;
      const sha256 =  digester.read();
      const cmd = get_pr_cmd(url, sha256);
      if (brew_existed) {
        console.log(cmd);
        execSync(cmd);
      } else {
        console.error(`[ERROR] exec the following command by brew on macOS or Linux: ${cmd}`);
      }
    });
  });
}

main();


// const content=tpl().replace('{{url}}', url).replace('{{sha256}}', sha256);
function tpl() {
  return `
    require "language/node"

    class Whistle < Formula
      desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
      homepage "https://github.com/avwo/whistle"
      url "{{url}}"
      sha256 "{{sha256}}"

      depends_on "node"

      def install
        system "npm", "install", *Language::Node.std_npm_install_args(libexec)
        bin.install_symlink Dir["#{libexec}/bin/*"]
      end

      test do
        (testpath/"package.json").write('{"name": "test"}')
        system bin/"whistle", "start"
        system bin/"whistle", "stop"
      end
    end
    `;
}
