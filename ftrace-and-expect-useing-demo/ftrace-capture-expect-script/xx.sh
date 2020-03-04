#!/usr/bin/expect
set ip root@10.3.153.98
spawn vim ./capture-ftrace.sh
interact
spawn sync

spawn scp ./capture-ftrace.sh $ip:/tmp/
expect "password"
send "rockchip\r"
interact

spawn ssh $ip
expect "password:"
send "rockchip\r"
expect "*#"
send "echo 0 > /sys/kernel/debug/tracing/tracing_on\r"
expect "*#"
send "echo '' > /sys/kernel/debug/tracing/trace\r"
expect "*#"
send "echo nop > /sys/kernel/debug/tracing/current_tracer\r"
expect "*#"
send "echo function_graph > /sys/kernel/debug/tracing/current_tracer\r"
expect "*#"
send "killall -9 cat\r"
expect "*#"
send "cat /sys/kernel/debug/tracing/trace_pipe > /tmp/log&\r"
expect "*#"

send "/tmp/capture-ftrace.sh\r"
expect "qqqqq"
send "sync\r"
expect "*#"

send "echo 0 > /sys/kernel/debug/tracing/tracing_on\r"
expect "*#"
send "sync\r"
expect "*#"
send "killall -9 cat\r"
expect "*#"
send "sync\r"
expect "*#"
send "exit \r"
interact


spawn scp $ip:/tmp/log ./
expect "password"
send "rockchip\r"
interact

spawn vim ./log
interact

#expect and send comlete auto interaction
#interact complete manul interaction

#spawn ssh root@10.3.153.96
#expect "password:"
#send "rockchip\r"
#expect "*#"
#
#send "echo userspace > /sys/class/devfreq/dmc/governor\r"
#expect "rk3399"
#send "echo 800000000 > /sys/class/devfreq/dmc/userspace/set_freq\r"
#expect "rk3399"
#send "cd /sys/kernel/debug/tracing\r"
#expect "rk3399"
#send "echo 0 > tracing_on\r"
#expect "rk3399"
#send "echo "" > trace\r"
#expect "rk3399"
#send "echo function > current_tracer\r"
#expect "rk3399"
#send "cat trace_pipe > /tmp/ftrace.log &\r"
#expect "rk3399"
#send "echo 1 > tracing_on\r"
#expect "rk3399"
#send "v4l2-ctl -d /dev/video10 --stream-mmap=2 --stream-to=/tmp/cif0.out --stream-count=2 --stream-poll\r"
#expect "rk3399"
#send "echo 0 > tracing_on\r"
#expect "rk3399"
#send "killall -9 cat\r"
#expect "rk3399"
#send "cd -\r"
#expect "rk3399"
#
#interact

#8,13g/send/s/"$/\\r"$/
#8,31s/.*\n/\0expect "rk3399"\r/
