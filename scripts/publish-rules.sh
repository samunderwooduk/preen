#!/bin/zsh
# Publishes Preen's own rules, Preen/Resources/Rules/preen.txt, to the address installed copies
# refresh them from, so they pick up a change within a day without an update to the app.
# It needs the Cloudflare login the release script uses.
set -euo pipefail
root=${0:A:h:h}
list=$root/Preen/Resources/Rules/preen.txt
url=https://updates.samunderwood.co.uk/preen/rules.txt

# Every installed copy takes the list within a day, so it has to be the one on main.
git -C "$root" fetch --quiet origin main
changes=$(git -C "$root" status --porcelain)
head=$(git -C "$root" rev-parse HEAD)
main=$(git -C "$root" rev-parse origin/main)
if [[ -n $changes || $head != $main ]]; then
    echo "Publish from a clean checkout of origin/main." >&2
    exit 1
fi

# A list the tests reject would be turned away by installed copies, or do nothing.
swift test --package-path "$root/Packages/PreenCore"

cf --profile main r2 objects put preen/rules.txt --bucket-name app-updates --file "$list" --content-type "text/plain; charset=utf-8" -q >/dev/null
cf --profile main cache purge -z samunderwood.co.uk --force --body "{\"files\":[\"$url\"]}" >/dev/null
curl --fail --silent --show-error --max-time 60 "$url" | cmp -s - "$list" || { echo "$url doesn't match $list yet." >&2; exit 1 }
echo "Published $url"
