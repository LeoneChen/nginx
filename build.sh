#!/bin/bash
set -e

PROJ_DIR=$(realpath $(dirname $0))

auto/configure --prefix="${PROJ_DIR}/install" --with-cc-opt="-O0" --with-ld-opt="-g -O0" --with-debug
make -j$(nproc)
make install

cp nginx.conf install/conf/nginx.conf

pushd occlum-instance
    if [ ! -f ".__occlum_status" ]; then
        occlum init
        cp Occlum.json{.template,}
    fi

    rm -rf image
    INSTALL_DIR="${PROJ_DIR}/install" envsubst < bom.yaml.template > bom.yaml
    copy_bom -f bom.yaml --root image --include-dir /opt/occlum/etc/template

    occlum build

    # add gdb pretty printer
    pushd build/lib
        objcopy --add-section .debug_gdb_scripts=<(echo -ne "\x01gdb_load_rust_pretty_printers.py\0") libocclum-libos.signed.so
    popd
popd
