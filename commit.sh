#!/bin/bash
set -x

if [ $# -ge 1 ]; then
    message="$@"
else
    message='fixed'
fi

git add .

git commit -m "$message"

# git push origin

# while true; do git push github; if [ $? == 0 ]; then break; fi; done

git push https://gitee.com/gitzhuwch/my-project master:master

while true; do git push https://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@github.com/gitzhuwch/my-project master:master; if [ $? == 0 ]; then break; fi; done

git branch -u origin/master

git pull
