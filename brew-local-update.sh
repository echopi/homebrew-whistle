#!/bin/bash

version="latest"

npm_registry="https://registry.npmjs.org"
# taobao_npm_registry="https://registry.npm.taobao.org"

latest_tarball=`curl -s $npm_registry/whistle/$version | grep -E -o '"tarball":"[^"]+"'| cut -d'"' -f 4`
latest_sha256=""
formula=`brew --repo`/Library/Taps/homebrew/homebrew-core/Formula/whistle.rb

local_sha256=`grep -E -m 1 'sha256 ".+"' $formula | cut -d'"' -f 2`
local_tarball=`grep -E -m 1 'url "https:[^"]+"' $formula | cut -d'"' -f 2`

tmp_dir=`mktemp -d`
filename="$tmp_dir/`basename $latest_tarball`"
curl -s $latest_tarball -o $filename

if command -v shasum >/dev/null 2>&1; then
  latest_sha256=`shasum -a 256 $filename | cut -d ' ' -f 1`
else
  latest_sha256=`sha256 $filename | cut -d ' ' -f 1`
fi

echo "formula=$formula"
echo "local_tarball=$local_tarball"
echo "latest_tarball=$latest_tarball"
echo "local_sha256=$local_sha256"
echo "latest_sha256=$latest_sha256"

latest_tarball_basename=`basename $latest_tarball`
local_tarball_basename=`basename $local_tarball`

if [[ $local_tarball_basename == $latest_tarball_basename ]]; then
  echo '👋 no need to update'
  exit 0
fi

sed -i.bak -E "s,url \"$local_tarball\",url \"$latest_tarball\"," $formula
sed -i.bak -E "s,sha256 \"$local_sha256\",sha256 \"$latest_sha256\"," $formula

echo "👍 $formula"
cat $formula
