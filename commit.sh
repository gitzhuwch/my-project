#!/bin/bash
set -x
git add .
git commit -m "fixed"

# git push origin

# while true; do git push github; if [ $? == 0 ]; then break; fi; done

git push --set-upstream https://gitee.com/gitzhuwch/my-project master:master

while true; do git push --set-upstream https://github.com/gitzhuwch/my-project master:master; if [ $? == 0 ]; then break; fi; done
