#!/bin/zsh
# Refreshes the community rules bundled with Preen and the test fixtures, from the same addresses
# the app downloads them from while it runs. Run it before a release, then run the tests.
# Preen's own list, preen.txt, is edited by hand and published with publish-rules.sh.
set -euo pipefail
root=${0:A:h:h}
fetch() {
    local url=$1 name=$2 temp
    temp=$(mktemp)
    curl --fail --silent --show-error --location --max-time 60 -o "$temp" "$url"
    cp "$temp" "$root/Preen/Resources/Rules/$name"
    cp "$temp" "$root/Packages/PreenCore/Tests/PreenCoreTests/Fixtures/$name"
    rm "$temp"
    echo "Updated $name"
}
fetch https://filters.adtidy.org/extension/ublock/filters/17.txt adguard-url-tracking.txt
fetch https://rules2.clearurls.xyz/data.minify.json clearurls.json
