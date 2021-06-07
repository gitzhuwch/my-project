#!/bin/bash
set -x
git add .
git commit -m "fixed"

# git push origin

# while true; do git push github; if [ $? == 0 ]; then break; fi; done

git push --all https://gitee.com/gitzhuwch/my-project

while true; do git push --all https://github.com/gitzhuwch/my-project; if [ $? == 0 ]; then break; fi; done
