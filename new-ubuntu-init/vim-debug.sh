#!/bin/bash
#pwd

cd ../build/
arm-rtems5-gdb -x ~/bin/sub-gdbinit arm-rtems5/c/sgr5-expander/testsuites/samples/hello.out
