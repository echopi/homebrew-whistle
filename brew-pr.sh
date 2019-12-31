#!/bin/bash

version="latest"

npm_registry="https://registry.npmjs.org"
# npm_registry="https://registry.npm.taobao.org"

remote_formula_url="https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/whistle.rb"
latest_tarball=`curl -s $npm_registry/whistle/$version | grep -E -o '"tarball":"[^"]+"'| cut -d'"' -f 4`
latest_sha256=""

tmp_dir=`mktemp -d`
filename="$tmp_dir/`basename $latest_tarball`"
formula_filename="$tmp_dir/whistle.rb"

curl -s $remote_formula_url -o $formula_filename
remote_sha256=`grep -E -m 1 'sha256 ".+"' $formula_filename | cut -d'"' -f 2`
remote_tarball=`grep -E -m 1 'url "https:[^"]+"' $formula_filename | cut -d'"' -f 2`

remote_tarball_basename=`basename $remote_tarball`
latest_tarball_basename=`basename $latest_tarball`

if [[ $remote_tarball_basename == $latest_tarball_basename ]]; then
  echo '👋 no need to pr'
  exit 0
fi

curl -s $latest_tarball -o $filename

if command -v shasum >/dev/null 2>&1; then
  latest_sha256=`shasum -a 256 $filename | cut -d ' ' -f 1`
else
  latest_sha256=`sha256sum $filename | cut -d ' ' -f 1`
fi

echo "remote_tarball=$remote_tarball"
echo "latest_tarball=$latest_tarball"
echo "remote_sha256=$remote_sha256"
echo "latest_sha256=$latest_sha256"

if command -v brew >/dev/null 2>&1; then
  brew bump-formula-pr --strict whistle --url=${latest_sha256} --sha256=${latest_sha256}
else
  echo "💔 [ERROR] exec the following command by brew on macOS or Linux:"
  echo "brew bump-formula-pr --strict whistle --url=${latest_sha256} --sha256=${latest_sha256}"
fi
