set -x
if [ ! -f "/sys/class/devfreq/dmc/userspace/set_freq" ];then
	echo userspace > /sys/class/devfreq/dmc/governor
	echo 600000000 > /sys/class/devfreq/dmc/userspace/set_freq
	sleep 1
fi

cd /sys/kernel/debug/tracing
echo 0 > tracing_on
echo "" > trace
echo 50000 > buffer_size_kb
#echo '' > set_ftrace_pid
#echo 0 > set_ftrace_pid
echo $$ > set_ftrace_pid
#-----------------------------------------------------------

#echo "ohci_irq" > set_ftrace_filter
#echo '' > set_ftrace_filter

echo "print-parent" > trace_options
echo "nosym-offset" > trace_options
echo "nosym-addr" > trace_options
echo "noverbose" > trace_options
echo "noraw" > trace_options
echo "nohex" > trace_options
echo "nobin" > trace_options
echo "noblock" > trace_options
echo "trace_printk" > trace_options
echo "annotate" > trace_options
echo "nouserstacktrace" > trace_options
echo "nosym-userobj" > trace_options
echo "noprintk-msg-only" > trace_options
echo "context-info" > trace_options
echo "nolatency-format" > trace_options
echo "record-cmd" > trace_options
echo "overwrite" > trace_options
echo "nodisable_on_free" > trace_options
echo "irq-info" > trace_options
echo "markers" > trace_options
echo "function-trace" > trace_options
echo "display-graph" > trace_options
echo "stacktrace" > trace_options
echo "print-tgid" > trace_options
echo "nofuncgraph-overrun" > trace_options
echo "funcgraph-cpu" > trace_options
echo "funcgraph-overhead" > trace_options
echo "funcgraph-proc" > trace_options
echo "funcgraph-duration" > trace_options
echo "nofuncgraph-abstime" > trace_options
echo "nofuncgraph-irqs" > trace_options
echo "nofuncgraph-tail" > trace_options
echo "sleep-time" > trace_options
echo "graph-time" > trace_options
echo "nofuncgraph-flat" > trace_options

#-----------------------------------------------------------
echo "" > trace
echo 1 > tracing_on
#-----------------------------------------------------------
/tmp/xusb
#exec i2ctransfer -f -y 4 w1@0x10 0x30 r4
#exec media-ctl -d /dev/media2 -p
#exec v4l2-ctl -d /dev/video10 --stream-mmap=2 --stream-to=/tmp/cif0.out --stream-count=4 --stream-poll --set-fmt-video=width=1920,height=1080
#exec v4l2-ctl -d /dev/video10 --stream-mmap=2 --stream-count=4 --stream-poll --set-fmt-video=width=1920,height=1080
#exec v4l2-ctl -d /dev/video10 --stream-mmap=2 --stream-to=/tmp/cif0.out --stream-count=2 --stream-poll
