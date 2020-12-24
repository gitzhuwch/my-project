set -x
cd /sys/kernel/debug/tracing

echo 0 > tracing_on
echo "" > trace

echo 50000 > buffer_size_kb

echo '' > set_ftrace_pid
echo 3328 > set_ftrace_pid
#echo $$ > set_ftrace_pid

echo "function_graph" > current_tracer
echo "" > set_graph_function

#-----------------------------------------------------------
echo "con_write" > set_graph_function
#echo "con_write_room" > set_graph_function
#echo "con_put_char" > set_graph_function
#echo "con_flush_chars" > set_graph_function
#echo "con_write" > set_graph_function
#-----------------------------------------------------------

#echo "noblock" > trace_options
#echo "context-info" > trace_options
echo "overwrite" > trace_options
#echo "irq-info" > trace_options
echo "display-graph" > trace_options
echo "stacktrace" > trace_options

echo "" > trace
echo 1 > tracing_on
#-----------------------------------------------------------
rm -f /home/user/temp/linux/trace.log
cat trace_pipe > /home/user/temp/linux/trace.log
#cat trace_pipe
