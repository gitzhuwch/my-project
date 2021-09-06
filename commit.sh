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

while true; do git push https://gitzhuwch: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@github.com/gitzhuwch/my-project; if [ $? == 0 ]; then break; fi; done

git branch -u origin/master

git pull

# git push https://gitzhuwch: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@github.com/gitzhuwch/my-project
