#!/usr/bin/env sh

set -eu

ssh-keygen -K -f ~/.ssh/id_yuzukey
ssh -T git@github.com

git clone git@github.com:mostlymaxi/nixconf.git


