#!/bin/zsh
# Publishes a Preen update with SamKit's shared release script; see the top of
# $SAMKIT_DIR/Tools/Release/release.sh for the options and what each Mac needs.
#   scripts/release.sh              a release
#   scripts/release.sh --dry-run    everything except uploading
#   scripts/release.sh --first      the very first release, when there is no appcast yet
# Bump MARKETING_VERSION and CURRENT_PROJECT_VERSION in project.yml first.
set -euo pipefail
samkit=${SAMKIT_DIR:-$HOME/Developer/SamKit}
if [[ ! -x $samkit/Tools/Release/release.sh ]]; then
    echo "SamKit isn't at $samkit. Clone github.com/samunderwooduk/samkit there, or set SAMKIT_DIR." >&2
    exit 1
fi
# Installed copies use the published Preen rules in place of the ones they came with, so a release
# whose rules aren't published yet would run without its new rules. A dry run carries on.
if ! curl --fail --silent --show-error --max-time 60 https://updates.samunderwood.co.uk/preen/rules.txt | cmp -s - "${0:A:h:h}/Preen/Resources/Rules/preen.txt"; then
    echo "The published Preen rules don't match Preen/Resources/Rules/preen.txt. Run scripts/publish-rules.sh before releasing." >&2
    (( ${@[(Ie)--dry-run]} )) || exit 1
fi
exec "$samkit/Tools/Release/release.sh" "${0:A:h}/release.conf" "$@"
