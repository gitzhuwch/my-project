#!/usr/bin/expect
set ip root@10.3.153.96
spawn vim ./capture-ftrace.sh
interact
spawn sync

spawn scp ./capture-ftrace.sh $ip:/tmp/
expect "password"
send "rockchip\r"
interact
