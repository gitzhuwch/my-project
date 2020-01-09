if [ ! -e /bin/on ]; then
	touch /bin/on
	chmod +x /bin/on
	echo "echo 1 > /sys/kernel/debug/tracing/tracing_on" > /bin/on
fi

if [ ! -e /bin/off ]; then
	touch /bin/off
	chmod +x /bin/off
	echo "echo 0 > /sys/kernel/debug/tracing/tracing_on" > /bin/off
fi

#cd /sys/kernel/debug/tracing 
echo 0 > /sys/kernel/debug/tracing/tracing_on 
echo function_graph > /sys/kernel/debug/tracing/current_tracer 
echo nofuncgraph-irqs > /sys/kernel/debug/tracing/trace_options 
echo funcgraph-proc > /sys/kernel/debug/tracing/trace_options 
#echo $$ > /sys/kernel/debug/tracing/set_ftrace_pid 
echo '' > /sys/kernel/debug/tracing/trace 
#echo 1 > /sys/kernel/debug/tracing/tracing_on 
cat /sys/kernel/debug/tracing/trace_pipe 
#echo "=============================" > /sys/kernel/debug/tracing/trace_marker 

