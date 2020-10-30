#!/bin/bash
#pwd

cd ../build/
../rtems-5.0.0-m2006-2/configure --prefix=$HOME/quick-start/rtems/5  --enable-maintainer-mode --target=arm-rtems5 --enable-rtemsbsp=sgr5-expander --disable-networking
make -j4

mv ./arm-rtems5/c/sgr5-expander/testsuites/samples/minimum.exe  ./arm-rtems5/c/sgr5-expander/testsuites/samples/minimum.out
mv ./arm-rtems5/c/sgr5-expander/testsuites/samples/capture.exe  ./arm-rtems5/c/sgr5-expander/testsuites/samples/capture.out
mv ./arm-rtems5/c/sgr5-expander/testsuites/samples/hello.exe   ./arm-rtems5/c/sgr5-expander/testsuites/samples/hello.out

