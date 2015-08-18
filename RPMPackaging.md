_Note: These instructions are for 0.64 and are now out of date; furthermore, the links are no longer valid.  We are planning on updating them, but don't have a delivery date for the updates.  If you are a commercial company and would like to have supported RPM packages, please post your interest to this [issue](http://code.google.com/p/bigbluebutton/issues/detail?id=624)._





# Introduction #

This document describes how to use RPM packages to install BigBlueButton on **CentOS 5.4 (32-bit and 64-bit)**.  The installation takes about fifteen minutes (depending on your internet connection).

**Notes:**
  * While are many RPM-based linux distributions available (32-bit and 64-bit), for the moment we focused our development and testing on **CentOS 5.4 (32-bit and 64-bit)**.
  * These RPMs are under development as part of BigBlueButton 0.64.  While we've tested them ourselves to ensure they work, we recommend you install them on a test machine.
  * The final URL for the RPM repository is likely to change.
  * These RPMs are kept up-to-date with the latest in BigBlueButton trunk.

# How to Install BigBlueButton on CentOS 5.4 #

To install from RPMs, you can use either the stable repository or the development repository. The stable repository contains the latest release of BigBlueButton, while the development repository contains the latest build from trunk.  To make it easy to install, we created a shell script that first adds all the required repositories on CentOS, then installs BigBlueButton.

First, download the script corresponding to your architecture and repository type.
  * **CentOS 5.4 32-bit Stable:** if you are not sure, this is probably the one you need. Use the following command to download the install script:
```
wget http://ec2-67-202-22-38.compute-1.amazonaws.com/centos/5.4/i386/stable/bbb-install.sh
```

  * **CentOS 5.4 32-bit Development:** use the following command to download the install script:
```
wget http://ec2-67-202-22-38.compute-1.amazonaws.com/centos/5.4/i386/dev/bbb-install.sh
```

  * **CentOS 5.4 64-bit Stable:** use the following command to download the install script:
```
wget http://ec2-67-202-22-38.compute-1.amazonaws.com/centos/5.4/x86_64/stable/bbb-install.sh
```

  * **CentOS 5.4 64-bit Development:** use the following command to download the install script:
```
wget http://ec2-67-202-22-38.compute-1.amazonaws.com/centos/5.4/x86_64/dev/bbb-install.sh
```

The following three commands will install BigBlueButton.  You need to be root to run these commands.
```

chmod u+x bbb-install.sh
./bbb-install.sh
bbb-conf --clean
```

The last command `bbb-conf --clean` does a clean restart of BigBlueButton so all the processes get started in the right order.  BigBlueButton will properly startup upon restart of the machine.

# How to install Desktop Sharing #
Desktop sharing is not installed by default. To install desktop sharing, run the following command:

```
yum install bbb-apps-deskshare
```

Please see [installing desktop sharing](http://code.google.com/p/bigbluebutton/wiki/InstallingDesktopSharing) and why doing so changes the licensing of BigBlueButton (the text on this page uses apt-get to install but the same applies to yum).


# Staying Up to Date #
The development repository is continuously being updated as new changes are committed to trunk. To update your server, use the following command:

```
yum update bbb*
```


# What does bbb-install do? #

The script bbb-install adds all the required repositories needed for the installation. It also checks if you have mySQL installed and, if it exists, will ask you for credentials.

Please refer to the contents of the script for more information.

# Screen Shots #

Here's a screen shot of the script running.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/rpm_install.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/rpm_install.png)

After installation, open a web browser to the URL provided using the IP address of the VM.    You should have a full BigBlueButton server running -- including voice conferencing.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm-join.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm-join.png)

> To start using your BigBlueButton server, enter your and then click Join.  You'll join the default meeting.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm-bbb-running.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/vm-bbb-running.png)


## Troubleshooting ##
If you run BigBlueButton immediately after installation and it is not running properly.

Check that the mysql database bigbluebutton\_dev has been created.

```
mysql -p
mysql> create database bigbluebutton_dev ;
mysql> grant all on bigbluebutton_dev.* to 'bbb'@'localhost' identified by 'secret';
mysql> flush privileges;
mysql> commit;
mysql> quit
```

Next, restart BigBlueButton.

```
bbb-conf -clean
```