#!/bin/bash
set -e

PROJECT_ROOT=$(realpath ../..)

./auto/configure --prefix=${PROJECT_ROOT}/src/nginx/install --with-http_ssl_module --with-openssl=${PROJECT_ROOT}/src/libressl-2.4.1/
make install -j$(nproc)

cp ${PROJECT_ROOT}/conf/nginx/* install/conf/

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${PROJECT_ROOT}/src/nginx/install/conf/cert.key -out ${PROJECT_ROOT}/src/nginx/install/conf/cert.crt -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"

ln -s ../libressl-2.4.1/crypto/enclave.signed.so
