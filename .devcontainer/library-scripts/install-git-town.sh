#!/usr/bin/env bash

curl -s https://api.github.com/repos/git-town/git-town/releases/latest | pv \
  | grep "git-town" \
  | grep "git-town_.*_linux_intel_64.deb" \
  | cut -d '"' -f 4 \
  | wget -qi -

echo "File Matched: $deb"
result=$(find git-town_*deb)
echo "Found: $result"
sudo dpkg -i $result
sudo chmod +x /usr/local/bin/git-town
rm --force $result
