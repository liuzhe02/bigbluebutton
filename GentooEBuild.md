**Note:** These instructions are out-of-date an need to be updated for 0.71.

# Introduction #

Note: This is a BigBlueButton Labs project and, as such, is not part of the core release.  If you have questions, please post them to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2).

This document describes how to install BigBlueButton from a gentoo ebuild on a 32-bit install. The installation time required depends on how many dependencies you have installed and on the speed on your computer.

# How to install BigBlueButton on your computer #

To install BigBlueButton you need to download and install Apache-ActiveMQ and Red5 first.
Let's start with Apache-ActiveMQ.
Go to your local repository such as ` /usr/portage ` or create a local repository on your own in ` /usr/local/portage `
Create a new directory structure as following ` net-im/apache-activemq ` and inside this folder create a files folder. If you are still unsure about the folder structure, look in ` /usr/portage ` and choose any of the other directories and look up their structures. Download the files afterwards and copy them into the corresponding folders.

**Apache-ActiveMQ** files to download
```
 http://bigbluebutton.org/downloads/dist-gentoo/apache-activemq/apache-activemq-5.3.0.ebuild
 http://bigbluebutton.org/downloads/dist-gentoo/apache-activemq/files/activemq-q 
```

As next Red-5 needs to be installed. For installing Red-5 please follow the same way we used for Apache-ActiveMQ.

**Red-5** files to download
```
 http://bigbluebutton.org/downloads/dist-gentoo/red5/red5-0.8.ebuild
 http://bigbluebutton.org/downloads/dist-gentoo/red5/files/red5-g
```

The next step is to download and install the BigBlueButton ebuild, which will download all the files needed to use the ebuild. The ebuild has a few dependencies, and I will list the versions which I have installed.

**BigBlueButton files**
```
 http://bigbluebutton.org/downloads/dist-gentoo/bigbluebutton/bigbluebutton-0.63.ebuild
 http://bigbluebutton.org/downloads/dist-gentoo/bigbluebutton/files/bbb-openoffice-headless
```

**BigBlueButton dependencies**
```
 mysql-5.0.76-r1
 tomcat-6.0.20
 swftools-0.9
 imagemagick-6.5.2.9
 nginx-0.8.33
 asterisk-1.6.2.2-r1
 bind-tools-9.4.3_p5
 openoffice-bin-3.2.0
```

If you have any of those tools installed and their version is lower than listed, please update the programs to a current version.
There are 2 use flags which you can activate, but are not supported yet. They are for deskshare and meetme. Support will be given in the future for this ebuild.

After the ebuild installed BigBlueButton you can download following file:
```
 http://bigbluebutton.googlecode.com/svn/trunk/bigbluebutton-config/bin/bbb-conf
```
This script allows you to change the host ip, watch the debug output and some more.

If you want BigBlueButton to be able to run after you started your Gentoo, please put the following programs in your default runlevel

After the installation, simply open a browser and put in your eth0 address.
![http://bigbluebutton.org/downloads/dist-gentoo/images/bbb.png](http://bigbluebutton.org/downloads/dist-gentoo/images/bbb.png)

To start using your BigBlueButton server, enter your name and then click Join. You'll join the default meeting.
![http://bigbluebutton.org/downloads/dist-gentoo/images/bbbuser.png](http://bigbluebutton.org/downloads/dist-gentoo/images/bbbuser.png)

### Services to start ###
```
 activemq
 asterisk
 red5 
 tomcat6
 nginx
 bbb-openoffice-headless
```

## When things go wrong ##
```
You can find separate logs you can look for
 /var/log/syslog
 /var/log/tomcat6
 /usr/share/red5/log
 /var/log/asterisk
```

## Editing any configuration files ##
As far of the ebuild stage, there is no need to edit any of the configuration files. Several scripts run to scan some folders and the ip address from the current system and applies those to the configuration files which are being installed.

## Troubleshooting ##
It might be possible that you need to install bash-4.x and update the portage version for some commands in the ebuild to run.

I rebooted my computer and now BigBlueButton does not work anymore:
Did you check for your ip address? It should be the same as before. If not, simply run following script as root:
```
 bbb-conf --setip <yourip>
```
This will update your ip address in the configuration files.

**_This ebuild is in a testing stage and currently not supported_**. However, if there are any troubles with the installation of the BigBlueButton ebuild, please feel free to ask for help in the mailing list.