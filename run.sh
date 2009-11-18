#!/bin/bash

set -e

# FILES="header.md tammer.md chad.md footer.md contributions.md"
# cat $FILES > all.md
slidedown all.md > slides.html 
open slides.html
