#!/bin/bash

git add . && \
git add -u && \
git commit -m $'Routine Commit: '"Committed on $(date)"$'\n@arfazhxss' && \
git push origin HEAD
