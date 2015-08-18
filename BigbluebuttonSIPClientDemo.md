# Summary of how to install or build the SIP applet.

_This document is depreciated._




# Installation of Coral CEA Release #

To test the SIP Client applet we will need to install the Coral CEA version of the Bigbluebutton. The Coral CEA version is based on the Bigbluebutton 0.71 codebase. The Coral CEA release includes other feature that we have been working on such as [API Partitioning](BigBlueButtonAPIPartitioning.md), "Full Screen" feature, and "Chat History " feature.

In the next sections we are going to provide the steps for installing the Coral CEA release either from packages or from source.


## Installing from packages ##

This section contains instructions for installing the Coral CEA release on a Ubuntu 10.04 32-bit or 64-bit serve. The instructions are similar to the Bigbluebutton installation.

**Prerequisites**

The minimum system requirements that is recommended for the original !Bigbluebutton installation are the following:

  1. An Ubuntu 10.04 32-bit or 64-bit server
  1. 2 GB of memory
  1. Root access to the server
  1. 5G of free disk space
  1. Port 80 is not in use by other applications

Note: BigBlueButton uses nginx, which listens on port 80 for http access and tunneling.  If you have Apache already running on your server, then you'll need to configure Apache to listen on a different port.
To do this, edit `/etc/apache2/ports.conf` and change the entry for 80 to another number, such as 8081.  Avoid using 8080 in apache as BigBlueButton uses tomcat6 which binds to that port.

### 1. Install the Coral CEA apt-get repository key ###
**For 32-bit installation,**
```
# Install the package key
wget http://173.195.48.104/coralcea.asc -O- | sudo apt-key add - 

# Add the Coral CEA repository URL and ensure the multiverse is enabled

echo "deb http://173.195.48.104/lucid_dev/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list

echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | sudo tee -a /etc/apt/sources.list
```

**For 64-bit installation,**

```
# Install the package key
wget http://173.195.48.99/coralcea.asc -O- | sudo apt-key add - 

# Add the Coral CEA repository URL and ensure the multiverse is enabled

echo "deb http://173.195.48.99/lucid_dev/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list

echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | sudo tee -a /etc/apt/sources.list
```

### 2. Install a Voice Conference Server ###

Install the voice system, (you will need to install [Asterisk](http://www.asterisk.org/), [FreeSwitch](http://www.freeswitch.org/) not tested yet)

```
sudo apt-get update
sudo apt-get install bbb-voice-conference
```

### 3. Install the Coral CEA release of !Bigbluebutton ###

After setting up the key for the Coral CEA packages and the repository for the COral CEA release. The Bigbluebutton installation is the same as described [here](http://code.google.com/p/bigbluebutton/wiki/InstallationUbuntu?ts=1300500710&updated=InstallationUbuntu#3._Install_BigBlueButton)

```
sudo apt-get install bigbluebutton
sudo bbb-conf --clean
sudo bbb-conf --check
```

## Upgrading from Bigbluebutton 0.71 release or earlier releases ##

For upgrading to the latest Coral CEA release, this can be done by executing the commands listed below:

```
#Stop the Red5 process
#Note: if command below does not work you can kill the Red5 process manually as well 
# Use command "kill PID", where PID is the Red5 process ID# 

sudo /etc/init.d/red5 stop

#Update the packages and upgrade with the current release 
sudo apt-get update
sudo apt-get dist-upgrade
```

## Upgrading from Bigbluebutton 0.71 release or earlier releases ##

In case of having Bigbluebutton already installed on the system, we can upgrade to Coral CEA release(s) by following the steps below:

### 1. Remove the old Bigbluebutton packages ###
```
sudo /etc/init.d/red5 stop
sudo apt-get --force-yes -y purge red5

echo "Removing old copy of BigBlueButton"
sudo apt-get --force-yes -y purge bbb-apps
sudo apt-get --force-yes -y purge bbb-apps-deskshare
sudo apt-get --force-yes -y purge bbb-apps-sip	
sudo apt-get --force-yes -y purge bbb-apps-video
sudo apt-get --force-yes -y purge bbb-client
sudo apt-get --force-yes -y purge bbb-config
sudo apt-get --force-yes -y purge bbb-common
sudo apt-get --force-yes -y purge bbb-freeswitch-config
sudo apt-get --force-yes -y purge bbb-freeswitch
sudo apt-get --force-yes -y purge bbb-openoffice-headless
sudo apt-get --force-yes -y purge bbb-web
sudo apt-get --force-yes -y remove swftools-0.9.1
sudo apt-get --force-yes -y remove bbb-voice-conference 
sudo apt-get --force-yes -y remove asterisk 
sudo apt-get --force-yes -y remove asterisk-config 
                 sudo apt-key del 328BD16D

```

### 2. Install the Coral CEA apt-get repository key ###

### 3. Update the packages source repository with Coral CAE ###

### 4. Install Coral CEA release of !Bigbluebutton ###




## Building from source code ##

In case we  have already the BigBlueButton 0.71 installed on our system, we can try to upgrade to Coral CEA release by checking out the code and build the different system components and deploy them.

**Prerequisites**

Bigbluebutton 0.71a virtual machine

**Instructions**

This section contains instructions for checking out the code from  [Coral CEA](https://github.com/coralcea) git repository or [Realwat](https://github.com/realwatcm) git repository for latest changes regarding the Bigbluebutton SIP applet and SIP phone.
Below are the steps on how to check out the source code and build from realwat git repository
### 1. Backup your source code ###

Remove or backup folder /home/firstuser/dev/source/bigbluebutton

### 2. Checkong out the source code ###

Check out the source code from realwat git repository or Coral CEA repository

```
$ git clone git://github.com/realwatcm/bigbluebutton.git 
OR
$ git clone git://github.com/coralcea/bigbluebutton.git
```

### 3. Build bbb-common-message library ###

```
$ cd /home/firstuser/dev/source/bigbluebutton/bbb-commom-message
$ gradle jar
$ gradle uploadArchives
```

### 4. Build bigbluebutton-web ###

```
$ cd /home/firstuser/dev/source/bigbluebutton/bigbluebutton-web
$ bbb-conf --setup-dev  web
$ gradle copyToLib
$ ant war
$ sudo /etc/init.d/tomcat6 stop
$ sudo rm –rf /var/lib/tomcat6/webapps/bigbluebutton*
$ sudo cp bigbluebutton-0.71dev.war  /var/lib/tomcat6/webapps/bigbluebutton.war
$ sudo touch /var/lib/tomcat6/webapps/bigbluebutton/demo/bbb_api_conf.jsp
$ sudo vi /var/lib/tomcat6/webapps/bigbluebutton/demo/bbb_api_conf.jsp
```
Add these lines to the file:
```
		<%
			String salt = “[securitySalt]”;
			String BigbluebuttonURL = “http:// [IP] /bigbluebutton/”;
		%>
```

```
$ sudo /etc/init.d/tomcat6 start
```

We can obtain  securitySalt from “/var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties”

### 5. Build bigbluebutton-apps ###
```
$ sudo /etc/init.d/red5 stop
$ cd /home/firstuser/dev/source/bigbluebutton/bigbluebutton-apps
$ bbb-conf --setup-dev  apps
$ gradle resolveDeps
$ gradle war deploy
$ sudo /etc/init.d/red5 start
```

### 6. Build bbb-video ###
```
$ cd /home/firstuser/dev/source/bigbluebutton/bbb-video
$ ant resolve
$ ant dist
$ ant deploy
```
### 7. Build bbb-voice ###
```
$ cd /home/firstuser/dev/source/bigbluebutton/bbb-voice
$ gradle resolveDependencies
$ gradle war deploy
```

### 8. Build Deskshare ###
```
$ cd /home/firstuser/dev/source/bigbluebutton/deskshare
$ gradle copyToLib
$ cd app
$ gradle war deploy
$ cd ../applet
$ gradle jar
$ ant create-signing-key  ( if you haven’t create keypair yet )
$ ant sign-jar
$ cp build/libs/bbb-deskshare-applet-0.71.jar  ../../bigbluebutton-client/resources/prod
```

### 9. Build SIP Client Applet (sipphone) ###
```
$ cd /home/firstuser/dev/source/bigbluebutton/sipphone
$ ant build
$ ant sign-jar
$ cp dist/sip.jar  ../bigbluebutton-client/resources/prod/
```

### 10. Build bigbluebutton-client ###
```
$ cd /home/firstuser/dev/source/bigbluebutton/bigbluebutton-client
$ bbb-conf --setup-dev client
$ ant
```

### 11. Copy web to bigbluebutton-default ###
```
$ sudo cp –R /home/firstuser/dev/source/bigbluebutton/bigbluebutton-config/web/*  /var/www/bigbluebutton-default
```

### 12. Install bbb-voice-conference ###
```
$ sudo apt-get install bbb-voice-conference
$ sudo bbb-conf --conference konference
$ cd /home/firstuser/dev/source/bigbluebutton/bigbluebutton-apps
$ gradle war deploy
$ sudo bbb-conf –clean
$ sudo bbb-conf --check
```


## Potential problems ##

1. If you can’t see listeners when the applet is launched, please reboot the server.

2. If you cannot call the api to start or stop module or new user is redirect to a different room, it is because your bbb-common-message-0.7.jar is compiled in different time. To resolve this problem you have to recompile the bbb-common-message

```
$ cd /home/firstuser/dev/source/bigbluebutton/bbb-common-message
$ gradle jar
# Remove the old jar file in the red5-webapps and replace it with the new version

$ rm -f /usr/share/red5/webapps/bigbluebutton/WEB-INF/lib/bbb-common-message-0.7.jar
$ cp /home/firstuser/dev/source/bigbluebutton/bbb-common-message/build/libs/bbb-common-message-0.7.jar  /usr/share/red5/webapps/bigbluebutton/WEB-INF/lib/

# Remove the old jar file in the Tomcat-webapps and replace it with the new version
$ rm –f /var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/lib/bbb-common-message-0.7.jar
$ cp /home/firstuser/dev/source/bigbluebutton/bbb-common-message/build/libs/bbb-common-message-0.7.jar  /var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/lib/

$ sudo service tomcat6 restart
$ sudo service red5 restart
```

## How to run the SIP Client Applet ##

Before running the applet we might need to perform some steps to make sure that our system has the minimum requirements to run the applet. You can find related information [here](http://www.titook.net/faq/index.php/BigBlueButton)

After making sure our system is configured properly now we can run the SIP Client applet for the Bigbluebutton.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet.jpg](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet.jpg)


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet2.jpg](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet2.jpg)


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet5.jpg](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet5.jpg)


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet6.jpg](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/SIP_APPLET_IMG/BBBApplet6.jpg)