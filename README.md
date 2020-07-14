# qemu_vp-docker

Modified from https://github.com/z4yx/petalinux-docker

Builds a full qemu-systemc cosimulation virtual platform

Need to download petalinux 2019.2: https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2019.2-final-installer.run
and the Xilinx ZCU102 BSP: https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zcu102-v2019.2-final.bsp from Xilinx's website. 
Once downloaded place in ./build/ directory

Please note that an account with Xilinx is needed to download the above files, additionally, they can only be downloaded by IPs from specific countries, otherwise the website will spit out an export control violation and prevent the download from happening. If you're attempting to download from an unauthorized area, reach out to COE or ... you know ... be creative. There are ways to solve these kinds of problems. 

Rename petalinux install to petalinux_2019.run after moving to build directory

To build:
docker build -t qemu_vp:PLATFORM .

To run:
docker run --hostname builder -it qemu_vp:PLATFORM
Please note that run command needs to be modified to allow debugging. 

To detach from container press CTRL+p CTRL+q

SSH access is available. After running container run the command:
sudo service ssh start 

Add the following the your ~/.ssh/config file

	Host qemu_vp
        	Hostname 172.17.0.2
        	User peta
        	UserKnownHostsFile /dev/null
        	StrictHostKeyChecking no

Then upload your sshkey using ssh-copy-id peta@qemu_vp

Now you access the container via ssh with the command ssh peta@qemu_vp

The container has one user "peta" who's password is 123456789

Total build time is around 30 minutes on an i7-9700k with 32 GB ram. 

To compile aarch64 binaries within the container (Will be included by default in future commits)
1) ssh into container
2) cd ~
3) wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
4) sudo sudo tar -xvzf gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz /usr/bin
5) sudo chmod -R u+rwx /usr/bin/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/

/usr/bin should be in path by default but if the compiler doesn't show up right away, just:
1) echo "export PATH=\$PATH:/usr/bin" >> ~/.bashrc
2) source ~/.bashrc
