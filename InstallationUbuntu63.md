**NOTE: This article is still a draft**

# Installing BigBlueButton using Ubuntu Packages #

Using Ubuntu packages, it's very easy to get a  BigBlueButton server up and running on Ubuntu 9.04 in about ten minutes (depending on your download speed). Unlike previous versions, this installation will install all the components including Asterisk (which provides voice conferencing)

> The following instructions will install and configure all the components except Asterisk (see Installing BigBlueButton for how to install Asterisk, which provides the voice conferencing).

## Prerequisites ##

You'll need root access to your Ubuntu 9.04 machine (it can be server or workstation).

Also,  BigBlueButton uses nginx, which listens on port 80 for http access and tunneling, so if you have apache running, you'll need to tell apache to listen to a different port by editing /etc/apache2/ports.conf and changing the entry for 80 to another number, such as 8081.  Avoid setting apache2 to port 8080 as  BigBlueButton uses tomcat6 which listens on that port.

## Let's go ##

First, you need to add the  BigBlueButton key and repository URL to apt-get, then instruct apt-get to update the list of available packages.

```
   wget http://archive.bigbluebutton.org/bigbluebutton.asc 
   sudo apt-key add bigbluebutton.asc 
   echo "deb http://archive.bigbluebutton.org/ bigbluebutton main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
   sudo apt-get update 
```

Next, enter the following command

```
   sudo apt-get install bigbluebutton 
```

This is where all the work is done.  Through figuring out dependencies, apt-get will present you a list of all the packages that need to be installed on your machine.


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/add_packages.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/add_packages.png)

Enter 'Y'.  After a few moments, if you don't have mysql installed, the mysql setup script will ask to provide a password for the mysql user 'root'.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu/setup_mysql.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu/setup_mysql.png)

Next, bbb-web, the scheduling component for a  BigBlueButton conference, needs to access the mysql database, so just give it the same password you did a moment ago.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu/setup_bbb-web.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu/setup_bbb-web.png)

## Trying out your server ( 4:42 minutes later) ##

Once apt-get installs everything, your done.  Near the end of the installation, you'll see the install script for bbb-web output the URL to load  BigBlueButton.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/bbb-url.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/bbb-url.png)

Enter this URL in your web browser and you should have  BigBlueButton home page. Join the session and start using  BigBlueButton!

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/bbb-screen-shot.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_ubuntu_63/bbb-screen-shot.png)

There you have it -  a  BigBlueButton server, including voice conferencing, up and running in about 5 minutes.

Want to keep your machine up-to-date with the latest  BigBlueButton release?  No problem, just enter

```
  # apt-get update
  # apt-get upgrade
```

and apt-get will download and install any updates to  BigBlueButton.  Don't you just love the power of Ubuntu/Debian packages?

## How to install desktop sharing ##
Desktop sharing is now a separate component.  Don't worry, you can install it with a single apt-get command. Please see [how to install desktop sharing](http://code.google.com/p/bigbluebutton/wiki/InstallingDesktopSharing) and why doing so changes the licensing of BigBlueButton.

## Amazon EC2 ##

Amazon EC2 uses an internal IP address of 10... and an external DNS host name, so you'll need to tell  BigBlueButton to use the external DNS name, as described in the next section).

You'll also need to open two ports: 1935 (for RTMP) and 9123 (for desktop sharing) on your EC2 instance.

### Changing the host (or IP) address for  BigBlueButton ###
If you need to change the hostname (or IP address), you can use `bbb-setip`, a utility shell script included in the  BigBlueButton install, to make the global changes necessary to  BigBlueButton's configuration files.

For example, to switch the  BigBlueButton server to use IP address 192.168.0.100, enter the follwoing

```
sudo bbb-conf --setip 192.168.0.100
```