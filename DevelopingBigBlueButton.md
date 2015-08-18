# Introduction #

Note: Real Developers like to setup their own development environment.  However, if you want to use a pre-built development environment, check out the [BigBlueButton Virtual Machine](http://code.google.com/p/bigbluebutton/wiki/BigBlueButtonVM).


  1. Download Red5 from http://build.xuggle.com/ . Choose red5\_jdk5\_stable ot red5\_jdk6\_stable depending on what version of Java you have installed on your machine.
  1. Start Red5 and then go to http://localhost:5080 and install the oflaDemo application. You should see a video instruction on how to do this when you go to http://localhost:5080

Once you got that working, let's configure your development environment.

  1. Make sure you have created JAVA\_HOME environment variable.
  1. Install Ant http://ant.apache.org and create an ANT\_HOME environment variable.
  1. Download Eclipse IDE for Java Developers from http://www.eclipse.org/downloads/
  1. Download Flex Builder Eclipse Plugin from https://www.adobe.com/cfusion/tdrc/index.cfm?product=flex. You need to create an account if you don't have one. You may also install the standalone Flex Builder available at the Adobe website.
  1. Install subclipse from [Subclipse](http://subclipse.tigris.org/) website. The instruction to install can be found [here](http://subclipse.tigris.org/servlets/ProjectProcess?pageID=p4wYuA).
  1. Switch to Subclipse Perspective in Eclipse. Click anywhere inside the SVN Repository window to create a new repository location. Enter `http://bigbluebutton.googlecode.com/svn/` as the repository location.
  1. Checkout bigbluebutton-apps, bigbluebutton-web, and bigbluebutton-client from trunk using this [instruction](http://subclipse.tigris.org/servlets/ProjectProcess?pageID=rr1TIx) from subclipse.

## BigBlueButton Apps ##
  1. Install groovy 1.5.6 (http://groovy.codehaus.org/Download), add GROOVY\_HOME env variable and %GROOVY\_HOME%\bin in your PATH
  1. Copy build.properties to your home directory and edit red5\_home of your copy to point to `RED5_HOME`.  If you are on windows, you'll need to user forward slashes, as in `red5_home = c:/tools/Red5-2`.
  1. Open build.xml under bigbluebutton-apps within eclipse. On the Outline Window, right-click on `resolve` and choose `Run As -> Ant Build`. This will resolve all library dependencies for bigbluebutton-apps.
  1. Configure your build path to include the jar files in the lib folder.
  1. Edit recordingsDirectory=c:/temp/bigbluebutton of `webapps/bigbluebutton/WEB-INF/bigblluebutton.properties`. This is where the recordings will be saved.
  1. When successful, right-click on `deploy` and choose `Run As -> Ant Build`. This will compile and deploy bigbluebutton-apps into the `RED5_HOME` directory you created above.

## BigBlueButton Web ##
  1. Install MySQL and create database using commands in INSTALL file.
  1. Install [SWFTOOLS](http://www.swftools.org) in e.g. swftools directory and [www.imagemagick.org ImageMagick] in e.g. imagemagick and [GhostScript](http://www.ghostscript.com)
  1. Install GRAILS 1.0.4 (http://www.grails.org/1.0.4+Release+Notes) and create GRAILS\_HOME env variable as well as add it to your PATH
  1. Copy grails-app/conf/bigbluebutton.properties to your home directory `${USER_HOME}/.bigbluebutton/bigbluebutton.properties` and edit the properties with the correct values.
  1. The open a shell/command window and type `grails run-app` to run the application.
  1. Open your browser and go to http://localhost:8080/bigbluebutton
  1. Login using default accounts in grails-app/conf/Bootstrap.groovy
  1. Create and schedule a conference


# Learning Red5 #
Below are some exercises you can do to learn how to develop Red5 applications.

**Exercise 1:**
Take a look at the chat module on bigbluebutton-client and chatServer on bigbluebutton-server and understand how it works. You can learn about Shared Objects by searching on Google for examples. Or you can click Help->Help Contents and Search "Shared Object" from Eclipse.

**Exercise 2:**
Modify chat module so that the client sends a message by setting an attribute on the shared object instead of calling a method which is how the current module sends a message to others.

The SharedObject [doc](http://livedocs.adobe.com/flex/3/langref/flash/net/SharedObject.html) explains how SharedObject works.

**Exercise 3:**
Modify chat module on the client so that when the message begins with "HANDLER", the message is sent to a handler on chatServer which converts the message to UPPERCASE and sets the shared object attribute (you defined on Exercise 2) with the message on the server.

**Exercise 4:**
Use a job in the server to send the server time every minute to the client.

Read this [Migration Guide](http://jira.red5.org/confluence/display/docs/Chapter+5.+Migration+Guide) to be able to do the above exercises.

  1. When testing your changes on chatServer, stop the server under `RED5_HOME`. Compile and deploy `bigbluebutton-apps` by right-clicking "deploy" on build.xml as mentioned in BigBlueButton Apps instruction above.
  1. To test the client, just follow the "Starting the Client" instruction above.


---

## Virtualized BigBlueButton Development Environment ##
NOTE: This is still in draft and will be fleshed out.

We have packaged BigBlueButton into a VMWare image so you will be able to try out and start developing as soon as possible.

### Downloads ###
  1. Download VMWare player from http://www.vmware.com
  1. Download BigBlueButton VMWare image.
  1. Bootup the image inside your VMWare.

### Try out BigBlueButton ###

### Setup your Development Tools ###
  1. Setup Samba
  1. Setup development tools.
  1. Checkout code.
