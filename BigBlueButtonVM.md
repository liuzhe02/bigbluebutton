

# Welcome #
This guide walks you through how to download and install the BigBlueButton 0.81 virtual machine (VM).

The VM is an easy way to have a fully working BigBlueButton server in a few minutes for testing and development.  The VM runs under VMWare Player, which is available on Windows or Mac (on the Mac it's called VMWare Fusion).   If you're looking to install BigBlueButton on Unix, see [installing on Ubuntu 10.04 64-bit](Installation.md).

If you are a developer, you can use the VM as a basis for setting up a [development environment](Developing.md).

# Before you install #
Running BigBlueButton within a virtualized environment on a desktop computer is good for testing BigBlueButton with small groups of people (the actual number will depend on the speed of your computer and network) and developing and extending BigBlueButton.

However, if your intent is to use BigBlueButton in a production environment, we recommend setting up BigBlueButton on a dedicated server (see [minimum requirements](FAQ#What_are_the_minimum_hardware_requirements_for_the_BigBlueButton.md)).

## Requirements for the BigBlueButton VM ##
The requirements for running the BigBlueButton VM are as follows:
  1. VMWare Player (or VMWare Workstation) for Windows or VM Ware Fusion for Mac
  1. 2 G of free memory to run the VM
  1. A DHCP Server for the VM to acquire an IP address on boot
  1. Ability for the VM to connect to the internet

The forth requirement is important. The VM must be able to connect to the internet on first boot to update from packages.  If the VM cannot connect, it won't be able to finish the setup of BigBlueButton.

Note: If you compare the above requirements with those [in installation from packages](InstallationUbuntu#Before_You_Install.md), you'll note the above requirements are less.  That's because the BigBlueButton VM isn't intended for use in a production environment; rather, for testing with small numbers of users and development of BigBlueButton.

# Setting up the BigBlueButton VM #

## Download ##

  1. Download and uncompress the ZIP file.

Download bigbluebutton081-VM.zip from SourceForge: [Download ](http://sourceforge.net/projects/bigbluebutton/files/)

> 2.  Open the enclosed folder.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm_icons.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm_icons.png)

> 3.  Double-click on the bigbluebutton-vm.vmx icon.

This will start VMWare Player/Workstation (or VMWare Fusion on the Mac) and boot the VM. NOTE: Make sure the networking is set to **Bridged** (not NAT).

The BigBlueButton VM takes about 10 minutes to first initialize.  Sit back, relax, go watch some [YouTube videos](http://www.youtube.com/user/bigbluebuttonshare).  During this time, the BigBlueButton VM goes through its initial startup script, which consists of the following:

  * Set up the networking (acquire an IP address from a DHCP server)
  * Download and install the latest BigBlueButton packages
  * Configure BigBlueButton to use the VM's current IP address
  * Install OpenSSH


## Change Default Password ##

When it's done, you'll see a login prompt.  **NOTE:** The VM has been pre-configured to have the following user-id/password:

> user-id: **firstuser**

> password: **default**

**To secure your server, immediately login with the above user-id/password.**  This password is set to expire immediately, so you'll be asked to enter the password **default** again, then to provide a new password (entering it twice to confirm).  Again, do this now as it will secure your server.

After resetting the default password, you'll receive a welcome message (this appears each time you login as firstuser).  You can access the BigBlueButton server using the URL given in the welcome message.

## Using BigBlueButton ##

At this point, you should have a full BigBlueButton 0.81 server up and running.  Open a web browser to the URL displayed in the welcome message.

If you have any problems, please read through the troubleshooting section below.

# Troubleshooting #

## The console gives an error when booting ##

When the VM first boots, it acquires an IP address and runs a setup script to finish the installation of BigBlueButton.   The script:
  1. updates the packages
  1. installs BigBlueButton

The update step ensures that any updates to packages, issued after the release of the BigBlueButton VM, will be automatically downloaded before installation proceeds.

The most common error that prevents update and installation occurs when the BigBlueButton VM failed to acquire an IP address.  When this occurs, you'll see errors in the console when booting.

You can manually finish the installation process, but you first need to ensure the VM has (1) acquired an IP address and (2) the IP address is accessible by the host computer.

First, check in VMWare Player that has networking set to **bridged**.  Next, type

```
    ping google.com
```

You should get some ping results

```
   PING google.com (72.14.204.99) 56(84) bytes of data.
   64 bytes from iad04s01-in-f99.1e100.net (72.14.204.99): icmp_seq=1 ttl=54 time=4.54 ms
   64 bytes from iad04s01-in-f99.1e100.net (72.14.204.99): icmp_seq=2 ttl=54 time=4.42 ms
```

If not, it means that the VM is unable to acquire an IP address from a DHCP server on the network.  If there is a DHCP server, you can try

```
    sudo /etc/init.d/networking restart
```

Try the ping command again.  If you are unable to acquire an IP address, check out this resource [Ubuntu Networking](https://help.ubuntu.com/10.04/serverguide/C/networking.html).

Next, you can manually finish the setup to BigBlueButton with the following commands:

```
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install bigbluebutton
```

There should be no errors when you type the above three commands.


## bbb-conf command not found ##

When it first launches, if the BigBlueButton VM is unable to connect to the internet, it will not finish the installation.  You'll see this when you type `bbb-conf` command and receive the error "command not found".

The solution is to make sure the VM can connect with the internet.  You should be able to

```
   ping ubuntu.bigbluebutton.org
```

and get a response.  Once connected, do the following commands:

```
   sudo apt-get update
   sudo apt-get dist-upgrade
```

Then you can finish the installation manually by following [these steps](InstallationUbuntu#3.__Install_BigBlueButton.md).


## The IP address of my VM has changed and now BigBlueButton does not work ##
Next, you'll need to ensure that BigBlueButton is listening to the IP address of your VM.  One symptom is when you try to access BigBlueButton through the web browser you get the `Welcome to nginx!` message.

To check your current environment for possible problems that might prevent BigBlueButton from running, type the following command:

```

   sudo bbb-conf --check

```

If there are any problems (i.e. if bbb-conf detects that red5 isn't running), you'll see a warning message at the bottom.

The output from above showed that BigBlueButton's configuration files were listening to IP address 192.168.0.163.  When you type the command, if the IP address shown for your output differs from the IP address of your VM, you can change the IP address that BigBlueButton is using by using `bbb-conf`.

For example, if the output from `ifconfig` shows your VM is listening to IP address 192.168.0.125, then issue the following command

```

  sudo bbb-conf --setip 192.168.0.125

```


If you need to restart BigBlueButton, do the command

```

   bbb-conf --clean

```

and this will do a clean restart.


## Check if you have an internet connection ##

```
ping www.google.com
```

If you get an error saying your eth0 is not connected, check if the VM is using eth1:

```
ifconfig -a
```

If it shows the following:

```
eth1      Link encap:Ethernet  HWaddr 00:0c:29:dd:b4:51
          inet addr:192.168.0.154  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fedd:b451/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4080349 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3932137 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1216680270 (1.2 GB)  TX bytes:822963271 (822.9 MB)
          Interrupt:19 Base address:0x2000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:12938 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12938 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:40299608 (40.2 MB)  TX bytes:40299608 (40.2 MB)
```

Make it use eth0 instead
```
vi /etc/udev/rules.d/70-persistent-net.rules
```

This will show:
```
# This file was automatically generated by the /lib/udev/write_net_rules
# program, run by the persistent-net-generator.rules rules file.
#
# You can modify it, as long as you keep each rule on a single
# line, and change only the value of the NAME= key.

# PCI device 0x1022:0x2000 (pcnet32)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:0c:29:23:d1:b3", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"

# PCI device 0x1022:0x2000 (pcnet32)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:0c:29:dd:b4:51", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"

```

Swap the two entries by editing "NAME=eth1" to "NAME=eth0" and vice versa.

Reboot your machine. Check if you managed to connect to the internet. Make sure the VM's network adapter is using a Bridged connection instead of NAT. On the VMWare player this is enabled in the Devices menu at the top.

More info can be found here http://ubuntuforums.org/showthread.php?t=221768

## I can't cut-and-paste into the terminal window ##

When running the BigBlueButton VM, you can't use the clipboard in the terminal window provided by VMWare.

On Windows, we recommend you download and run [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html), a terminal emulation program that supports cut-and-paste.

On Mac, you can open a Terminal window and ssh into the VM using it's IP address.


## I'm still having problems ##

If you've tried both the above commands and your BigBlueButton server is not working, use Google to search for help.  Enter a brief description of your problem or the error message you are seeing.  The reason we recommend using Google first is there are now over 14k posts in our mailing lists and they are all indexed by Google -- there is an excellent chance that you'll find a solution right away.

If you're unable to find a solution, please post your question to the [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2) mailing list.  Please be as descriptive as possible so we can help you.