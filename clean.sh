#!/bin/bash
set -e
rm -rf install
if [ -f Makefile ]
then
    make clean
fi
rm -f enclave.signed.so
rm -f build
