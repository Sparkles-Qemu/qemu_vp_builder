#!/bin/bash

BSP_FILE=$1
PROJECT_DIR=~/$2

source /opt/Xilinx/petalinux/settings.sh /opt/Xilinx/petalinux

petalinux-create -t project -s $BSP_FILE

mv rootfs_config ${PROJECT_DIR}/project-spec/configs/

cd ${PROJECT_DIR} && \
   petalinux-config --silentconfig && \
   petalinux-build

