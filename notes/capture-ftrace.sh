set -x
cd /sys/kernel/debug/tracing
echo 0 > tracing_on
echo "" > trace
echo 50000 > buffer_size_kb
echo '' > set_ftrace_pid
#echo 0 > set_ftrace_pid
#echo $$ > set_ftrace_pid
#-----------------------------------------------------------
echo "redraw_screen" > set_graph_function
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
#echo "print-tgid" > trace_options
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
#echo "nofuncgraph-flat" > trace_options
echo nooverwrite > trace_options
#echo nooverwrite > /sys/kernel/debug/tracing/trace_options
#-----------------------------------------------------------
echo "" > trace
echo 1 > tracing_on
#-----------------------------------------------------------
#echo "========================================================================" > /sys/kernel/debug/tracing/trace_marker
#echo abcd
