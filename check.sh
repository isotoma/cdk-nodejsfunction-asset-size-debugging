#!/bin/bash -e

rm -rf cdk.out
npm run -- cdk --app 'node ./lib/index.js' synth -e mystage/mystack

# Find out what non-template assets that wants to deploy
asset_manifest='cdk.out/assembly-mystage/*.assets.json'
echo "Asset manifest file ($asset_manifest):"
cat $asset_manifest | jq .
echo "---"
asset_paths="$(cat $asset_manifest | jq -r '.files | to_entries | .[].value.source.path' | grep -v 'template.json$')"

echo "Asset paths:"
echo "$asset_paths"
echo "---"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if echo "$asset_paths" | grep '^'"$DIR"'$' >> /dev/null; then
    >&2 echo -e "${RED}### BAD ###${NC}"
    >&2 echo "Found absolute path to project root in assets, this is probably wrong and bad"
    exit 1
else
    >&2 echo -e "${GREEN}### GOOD ###${NC}"
    >&2 echo "Asset paths look fine"
fi
