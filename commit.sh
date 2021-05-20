#!/bin/bash
git add .
git commit -m "fixed"
git push origin
while true; do
git push github
if [ !$? ]
    break
fi
done
