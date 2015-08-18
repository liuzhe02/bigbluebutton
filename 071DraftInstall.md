**Note:** This was a temporary page for information on the 0.71 release.  This page is now marked as depreciated.  Please see [BigBlueButton Google Code Home Page](http://code.google.com/p/bigbluebutton/) for the latest content.



# Prerequisites #

This document contains instructions for installation **BigBlueButton 0.71-beta** on a new server using Ubuntu packages.  These packages are still being developed, so if you have questions/feedback/bugs, please post to [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2).

If you want to upgrade from BigBlueButton 0.70, please see [Upgrading from BigBlueButton 0.70](#Upgrading_from_BigBlueButton_0.70.md).

Before you install BigBlueButton 0.71-beta, you'll need:
  1. **An Ubuntu 10.04 32-bit or 64-bit server**
  1. **2G of memory of memory**
  1. Root access to the server
  1. 5G of free disk space
  1. Port 80 is free

Note: BigBlueButton uses nginx, which listens on port 80 for http access and tunneling.  If you have apache already running on your server, then you'll need to configure apache to listen on a different port.  To do this, edit `/etc/apache2/ports.conf` and change the entry for 80 to another number, such as 8081.  Avoid using 8080 in apache as BigBlueButton uses tomcat6 which binds to that port.

We recommend you install BigBlueButton on a dedicated server.

# Installation of BigBlueButton 0.71-beta #

## 1. Install the BigBlueButton apt-get repository key ##

First, install the BigBlueButton apt-get repository key and URL.

**Note:** The URL has changed from 0.70.

```
   # Install the package key
   wget http://archive.bigbluebutton.org/bigbluebutton.asc 
   sudo apt-key add bigbluebutton.asc 

   # Add the BigBlueButton repository URL and ensure the multiverse is enabled
   # is enabled
   echo "deb http://ubuntu.bigbluebutton.org/lucid/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
   echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | sudo tee -a /etc/apt/sources.list
```

## 2. Install a Voice Conference Server ##

BigBlueButton now lets you choose to use either Asterisk or FreeSWITCH for voice conferencing.  We provide configuration packages for both, so it's easy to install either one.  We recommend FreeSWITCH.

To install FreeSWITCH:
```
  sudo apt-get install python-software-properties 
  sudo add-apt-repository ppa:freeswitch-drivers/freeswitch-nightly-drivers
  sudo apt-get update
  sudo apt-get install bbb-freeswitch-config
```

Or, instead, to install Asterisk:
```
   sudo apt-get update 
   sudo apt-get install bbb-voice-conference

```

Again, install only one of the above

## 3. Install BigBlueButton ##

We're now ready to install BigBlueButton.  Type:

```
   sudo apt-get install bigbluebutton
```

This single command is where all the magic happens.  This command will install **all** of BigBlueButton components with with their dependencies.  Here's a screen shot of the packages it will install.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71apt-get.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71apt-get.png)

Type 'y' and press Enter.  Then sit back.  After a few moments, if you don't have mysql installed, the mysql package script will ask to specify a password for the mysql 'root' user.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/mysql.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/mysql.png)

Enter a password for mysql's 'root' user (you'll need to enter it twice).  Almost immediately, the package script for bbb-web will prompt you for that mysql root password (shown below).  BigBlueButton needs to access the mysql to create a database.  Enter the the same password your did a moment ago for mysql.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71web.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71web.png)


## 4. Do a Clean Restart ##

To ensure BigBlueButton has started cleanly, enter the following commands:

```
   sudo bbb-conf --clean
   sudo bbb-conf --check
```

The output from `sudo bbb-conf --check` will display your current settings and, after the text, " Potential problems described below ", print any configuration or startup problems it has detected.  Normally, there is no text following this message.

## Trying out your server ( 14:42 minutes later) ##

You've got a full BigBlueButton server up and running (don't you just love the power of Ubuntu/Debian packages). Open a web browser to the URL of your server.  You should see the BigBlueButton welcome screen.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71welcome.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71welcome.png)

To start using your BigBlueButton server, enter your name and click the 'Join' button.  You'll join the Demo Meeting.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/07bbb.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/07bbb.png)

If this is your first time using BigBlueButton, take a moment and watch these [overview videos](http://bigbluebutton.org/content/videos).

Also check out our [Frequently Asked Questions.](http://code.google.com/p/bigbluebutton/wiki/FAQ)  For example, a common question is  [How do I setup multiple virtual classrooms?](http://code.google.com/p/bigbluebutton/wiki/FAQ#Can_I_run_multiple_virtual_classrooms_in_a_single_BigBlueButton)

# Upgrading from BigBlueButton 0.70 #

If you are running BigBlueButton 0.70 on Ubuntu 10.04 32-bit or 64-bit, you can upgrade your server by entering the following commands.

First, change the URL for the BigBlueButton apt-get repository.

```
  echo "deb http://ubuntu.bigbluebutton.org/lucid/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
```

Next, update your packages

```
  sudo apt-get update
  sudo apt-get dist-upgrade
```

Finally, do a clean restart of your BigBlueButton server and use `bbb-conf` to check that everything is running smoothly.

```
  sudo bbb-conf --clean
  sudo bbb-conf --check
```

You should now be running 0.71-beta.

# Troubleshooting #


## Troubleshooting your setup ##
We've built in a BigBlueButton configuration utility, called `bbb-conf`, to help you configure your BigBlueButton server and trouble shoot your setup if something doesn't work right.

If you think something isn't working correctly, the first step is enter the following command.

```
   bbb-conf --check
```

This will check your setup to ensure the correct processes are running, the BigBlueButton components have correctly started, and look for common configuration problems that might prevent BigBlueButton from working properly.  For example, here's the output on one of our internal servers:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71check.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71check.png)


If you see text after the line `** Potential problems descirbe below **`, then `bbb-conf` detected something wrong with your setup.

## Changing your BigBlueButton server's hostname (or IP address) ##

A common problem is the address in BigBlueButton's configuration files is different than the IP address of the host server.  To change all of BigBlueButton's configuration files to use a different IP address, enter

```
   bbb-conf --setip <ip_address>
```

## Errors in shutting down red5 ##

The red5 server will start without issues, but on occasion it will throw an exception when shutting down.

```

Doing a clean restart of BigBlueButton ...
 * Stopping Red5 Server red5
   Waiting for BigBlueButton to finish starting up before shutting down: .
Running on  Linux
Starting Red5
Attempting to connect to RMI port: 9999
Red5 Tomcat loader was found
Calling shutdown
java.util.ConcurrentModificationException
        at java.util.HashMap$HashIterator.nextEntry(HashMap.java:810)
        at java.util.HashMap$EntryIterator.next(HashMap.java:851)
        at java.util.HashMap$EntryIterator.next(HashMap.java:849)
        at java.util.HashMap.putAllForCreate(HashMap.java:452)
        at java.util.HashMap.clone(HashMap.java:686)
        at org.apache.catalina.loader.WebappClassLoader.clearReferencesStaticFinal(WebappClassLoader.java:1799)
        at org.apache.catalina.loader.WebappClassLoader.clearReferences(WebappClassLoader.java:1718)
        at org.apache.catalina.loader.WebappClassLoader.stop(WebappClassLoader.java:1622)
```

If this occurs, just kill the red5 process and do `sudo bbb-conf --clean` again.