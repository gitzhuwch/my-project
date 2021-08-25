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

git push https://gitzhuwch:oahcnawuhz123@gitee.com/gitzhuwch/my-project master:master

while true; do git push https://gitzhuwch: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@github.com/gitzhuwch/my-project master:master; if [ $? == 0 ]; then break; fi; done

git branch -u origin/master

git pull
