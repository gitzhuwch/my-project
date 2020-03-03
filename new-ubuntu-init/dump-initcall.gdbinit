#set serial baud 1500000
#target remote /dev/ttyUSB0

set auto-load safe-path /
shell export EDITOR=/usr/bin/vim
set pagination off
set logging file glog.txt
set logging overwrite on
set logging on
set print pretty on
set case-sensitive off
shell export EDITOR=/usr/bin/vim

define dump_init_setup_section
	set $pps=(struct obs_kernel_param*)&__setup_start
	set $ppe=(struct obs_kernel_param*)&__setup_end
	while ($pps != $ppe)
		p *$pps
		set $pps=$pps+1
	end
end
document dump_init_setup_section
end

define dump_param_section
	set $pstart=(struct kernel_param*)&__start___param
	set $pstop=(struct kernel_param*)&__stop___param
	while ($pstart != $pstop)
		p *$pstart
		set $pstart=$pstart+1
	end
end
document dump_param_section
end

define dump_initcall_section
	set $pinitcalls=(long *)(&__initcall_start)
	set $pinitcalle=(long *)(&__initcall_end)
	while ($pinitcalls != $pinitcalle)
		p (initcall_t*)$pinitcalls
		p (initcall_t)(*$pinitcalls)
		set $pinitcalls=$pinitcalls+1
	end
end
document dump_initcall_section
end


