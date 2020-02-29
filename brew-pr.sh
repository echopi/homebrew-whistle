#!/bin/bash

version="latest"

npm_registry="https://registry.npmjs.org"
# npm_registry="https://registry.npm.taobao.org"

current_formula_url="https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/whistle.rb"
latest_tarball=`curl -s $npm_registry/whistle/$version | grep -E -o '"tarball":"[^"]+"'| cut -d'"' -f 4`
latest_sha256=""

tmp_dir=`mktemp -d`
filename="$tmp_dir/`basename $latest_tarball`"
formula_filename="$tmp_dir/whistle.rb"

curl -s $current_formula_url -o $formula_filename
current_sha256=`grep -E -m 1 'sha256 ".+"' $formula_filename | cut -d'"' -f 2`
current_tarball=`grep -E -m 1 'url "https:[^"]+"' $formula_filename | cut -d'"' -f 2`

current_tarball_basename=`basename $current_tarball`
latest_tarball_basename=`basename $latest_tarball`

if [[ $current_tarball_basename == $latest_tarball_basename ]]; then
  echo '👋 no need to pr'
  exit 0
fi

curl -s $latest_tarball -o $filename

if command -v shasum >/dev/null 2>&1; then
  latest_sha256=`shasum -a 256 $filename | cut -d ' ' -f 1`
else
  latest_sha256=`sha256sum $filename | cut -d ' ' -f 1`
fi

echo "current_tarball=$current_tarball"
echo "latest_tarball=$latest_tarball"
echo "current_sha256=$current_sha256"
echo "latest_sha256=$latest_sha256"

pr_cmd="brew bump-formula-pr --strict whistle --url=${latest_tarball} --sha256=${latest_sha256}"
echo $pr_cmd
if command -v brew >/dev/null 2>&1; then
  $pr_cmd
else
  echo "💔 [ERROR] exec the above command on macOS or Linux:"
fi
