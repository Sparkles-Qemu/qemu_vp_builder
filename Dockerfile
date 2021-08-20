FROM asultan123/qemu_vp:LATEST_V0.2

ARG PETA_RUN_FILE=petalinux_2019.run
ARG BSP_FILE=xilinx-zcu102-v2019.2-final.bsp
ARG PROJ_DIR=xilinx-zcu102-2019.2
ARG SYSC_DIR=systemctlm-cosim-demo

COPY ./build/accept-eula.sh ./build/${PETA_RUN_FILE} /home/peta/

# run the install
RUN chmod a+rx /home/peta/${PETA_RUN_FILE} && \
  chmod a+rx /home/peta/accept-eula.sh && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u peta -i /home/peta/accept-eula.sh /home/peta/${PETA_RUN_FILE} /opt/Xilinx/petalinux

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER peta
ENV HOME /home/peta
ENV LANG en_US.UTF-8

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/peta/.bashrc

COPY --chown=peta:peta ./build/${BSP_FILE} ./build/rootfs_config ./build/create_proj.sh /home/peta/ 
RUN sudo -u peta -i /home/peta/create_proj.sh ${BSP_FILE} ${PROJ_DIR} && \
  rm -f /home/peta/${BSP_FILE} /home/peta/create_proj.sh

COPY --chown=peta:peta ./build/launch.sh /home/peta/${PROJ_DIR}/

RUN mv /home/peta/qemu-devicetrees /home/peta/${PROJ_DIR}/ && \
  cd /home/peta/${PROJ_DIR}/qemu-devicetrees && make

RUN cd /home/peta/${SYSC_DIR} && make

RUN rm -rf /home/peta/${BSP_FILE} && \
  rm -rf /home/peta/accept-eula.sh && \
  rm -rf /home/peta/${PETA_RUN_FILE} && \
  rm -rf /home/peta/petalinux_installation_log

ENTRYPOINT service ssh start && bash
