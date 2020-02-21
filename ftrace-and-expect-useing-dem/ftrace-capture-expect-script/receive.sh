#!/usr/bin/expect
set ip root@10.3.153.96
spawn ssh $ip
expect "password"
send "rockchip\r"
expect "*#"
send "killall -9 cat\r"
send "sync\r"
send "exit\r"

spawn scp $ip:/tmp/log ./
expect "password"
send "rockchip\r"
interact

spawn vim ./log
interact
