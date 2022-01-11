set -x
cd /sys/kernel/debug/tracing

echo 0 > tracing_on
echo "" > trace

echo 50000 > buffer_size_kb

echo '' > set_ftrace_pid
# echo 4115 > set_ftrace_pid
echo $$ > set_ftrace_pid

echo "function_graph" > current_tracer
echo "" > set_graph_function

#-----------------------------------------------------------
echo "do_sys_open" > set_graph_function
# echo "ksys_read" >> set_graph_function
# echo "proc_*" >> set_graph_function
# echo "*hot*" >> set_graph_function
#-----------------------------------------------------------

echo "noblock" > trace_options
echo "nofuncgraph-irqs" > trace_options
echo "nocontext-info" > trace_options
echo "overwrite" > trace_options
echo "noirq-info" > trace_options
echo "display-graph" > trace_options
echo "stacktrace" > trace_options

#-----------------------------------------------------------
echo "" > trace
echo 1 > tracing_on
#-----------------------------------------------------------
cat trace_pipe > /home/user/temp/linux/trace.log &
exec cat /proc/sys/kernel/hotplug
#cat trace_pipe
