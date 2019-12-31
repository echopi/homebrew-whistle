'use strict';

const crypto = require('crypto');
const fetch = require('node-fetch');
const {execSync} = require('child_process');

const npm_registry = 'https://registry.npmjs.org';
// const npm_registry = 'https://registry.npm.taobao.org';

const repo = execSync('brew --repo').toString().trim();
const formula = `${repo}/Library/Taps/homebrew/homebrew-core/Formula/whistle.rb`;
const sha256_to_replace = execSync(`grep -E -m 1 'sha256 ".+"' ${formula} | cut -d'"' -f 2`).toString().trim();
const url_to_replace = execSync(`grep -E -m 1 'url "https:[^"]+"' ${formula} | cut -d'"' -f 2`).toString().trim();

function inplace(url, sha256) {
  const inplace_url_cmd = `sed -i.bak -E 's,url "https:[^"]+",url "${url}",' ${formula}`;
  const inplace_sha256_cmd = `sed -i.bak -E 's,sha256 "${sha256_to_replace}",sha256 "${sha256}",' ${formula}`;
  execSync(inplace_url_cmd);
  execSync(inplace_sha256_cmd);

  console.log('👍 Update succeed!');
  console.log('url=', url);
  console.log('sha256=', sha256);
  console.log('formula location=', formula);
}

async function main() {
  const res = await fetch(`${npm_registry}/whistle/2.4.2`);
  const data = await res.json();
  const {tarball, shasum /* SHA-1 */} = data.dist;

  if (url_to_replace === tarball) {
    console.log('already the latest version');
    return;
  }

  const digester = crypto.createHash('sha256').setEncoding('hex');
  fetch(tarball).then(res => {
    res.body.pipe(digester).once('finish', () => {
      const url = tarball;
      const sha256 =  digester.read();
      inplace(url, sha256);
    });
  });
}

main();

// const url = 'https://registry.npmjs.org/whistle/-/whistle-2.4.4.tgz';
// const sha256 = 'a1216eaec1c6e651cf26c5307d6a5938c978943e03b47c57aa32575e6a6cee53';
// inplace(url, sha256);

