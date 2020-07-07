# qemu_vp-docker

Modified from https://github.com/z4yx/petalinux-docker

Builds a full qemu-systemc cosimulation virtual platform

Need to download petalinux 2019.2 and the Xilinx ZCU102 BSP from Xilinx's website. Once downloaded place in ./build/ directory

Rename petalinux install to petalinux_2019.run after moving to build directory

To build:
docker build -t qemu_vp:PLATFORM .

To run:
docker run --hostname builder -it qemu_vp:PLATFORM

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
