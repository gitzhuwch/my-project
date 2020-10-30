#!/bin/bash
#pwd

cd ../build/
arm-rtems5-gdb -x ~/bin/gdbinit arm-rtems5/c/sgr5-expander/testsuites/samples/hello.out
