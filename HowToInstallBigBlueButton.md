**Note:** These instructions are depreciated.  We no longer support installation of BigBlueBtton on Windows.  For up-to-date installation instructions, please see the [Installation of BigBlueButton](http://code.google.com/p/bigbluebutton/wiki/Installation) wiki page.

Note: These instructions are for version 0.3 and will soon be updated for version 0.4.

# Overview #
These instructions show you how to install BigBlueButton on a Windows XP/Vista computer.  If you computer is running XP/Vista with at least 1GB of memory and 8GB of free disk space, you're good to go.

There are three core servers needed to run BigBlueButton:
  * bigbluebutton server (built on red5)
  * activeMQ server
  * tomcat server

You'll also need to install an Asterisk server for voice conferencing.  However, for these instructions, we'll just cover the above servers.  That's enough to get you running with sharing of slides, video, and chat.

For the tomcat server, there are two additional components to install:
  * bigbluebutton.war -- a Java application that handles the upload of slides
  * client -- the HTML files (including the flash SWF) files for the BigBlueButton client

For bigbluebutton.war, it uses two supporting command-line applications  to convert PDF slides to SWF images:
  * pdftk -- breaks up PDF files into individual pages
  * pdf2swf -- converts a PDF file to SWF

For an overview of how the files work together, see [http://code.google.com/p/bigbluebutton/wiki/GettingStarted | Getting Started](.md)

# Before you begin #

First, you'll need to create some directories.  These instructions use the `c:` drive, but you can use any drive and any directory for installation.

  1. Create `c:\tools` (referred as `TOOLS_DIR`)

  1. Create `c:\temp`  (referred as `TEMP_DIR`)

We'll use `TOOLS_DIR` and `TEMP_DIR` through these instructions.  For example, to point the variable `JAVA_HOME` to `TOOLS_DIR\jdk`, you would define it as `c:\tools\jdk`.

Also, you will need to know the host name (or IP address) of your computer (referred to as `HOSTNAME`).  This could be a fully qualified domain name, such as mycomputer.network.com, or an IP address, as 192.168.0.150.

Enough intro -- let's get installing.

## Install Base Applications ##
For the downloads below, just grab the latest version of each open source application.  If your computer already has the application installed, such as tomcat, you can of course skip that installation step.


### Java Development Kit ###

  1. Download the [JDK 6](http://java.sun.com/javase/downloads/index.jsp) (not the JRE) installer.
  1. Install the JDK to `TOOLS_DIR` - e.g. `TOOLS_DIR\jdk`.  (Note, you can call the directory whatever you like, such as `TOOLS_DIR\jdk1.6`.)
  1. Click `Start -> Control Panel -> System -> Advanced tab -> Environment Variables` on your computer.
  1. Add a system variable `JAVA_HOME` pointing to `JAVA_HOME = TOOLS_DIR\jdk` (i.e. `c:\tools\jdk`).
  1. Open a command prompt and run `java -version`. You should see the java version (JDK 1.6 or above) displayed.


### ActiveMQ ###

  1. Download [ActiveMQ](http://activemq.apache.org) version 5.2.0.
  1. Install ActiveMQ in `TOOLS_DIR\activemq`.
  1. Open a command prompt and `cd` to `TOOLS_DIR\activemq\bin\win32`.
  1. Run `activemq.bat`.
  1. You should set the AcitveMQ startup messages with no errors.


### Tomcat ###
  1. Download [Tomcat](http://tomcat.apache.org) version 6 zip file.
  1. Uncompress the ZIP file into `TOOLS_DIR\tomcat`.
  1. Open a command prompt and `cd` to `TOOLS_DIR\tomcat\bin`.
  1. Run `catalina.bat start`.
  1. Open your browser to URL `http://HOSTNAME:8080`.
  1. You should see the Tomcat welcome page displayed.

By default, tomcat listens on port 8080.  You can easily change tomcat's settings to listen on port 80.  Edit the `TOOLS_DIR\tomcat\server.xml` file and find the string `port=”8080″` and change it to `port=”80″`. Omit the port 8080 qualifier from the rest of these instructions if you do this.


### SWF Tools and PDF Toolkit ###
  1. Download the latest version of [SWF Tools](http://www.swftools.org).
  1. Install in `TOOLS_DIR\swftools`.
  1. Download the latest version of [PDF Toolkit](http://www.accesspdf.com/pdftk).
  1. Install in `TOOLS_DIR\pdftk`.

If you've been following step-by-step, at this point your TOOLS\_DIR looks like this:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/folders_layout.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/folders_layout.png)


(The JRE is automatically installed by the JDK, but we'll be using the JDK.)  OK, let's start installing the BigBlueButton specific components.



## Install BigBlueButton Client ##

First, let's download the BigBlueButton client by grabbing the latest version from the Google Code downloads.

  1. Download the latest bbb-client (ZIP file) from the [Downloads](http://code.google.com/p/bigbluebutton/downloads/list).
  1. Unzip bbb-client into `TOOLS_DIR\tomcat\webapps\ROOT`. (You'll now have a `ROOT\bin` directory.)
  1. Rename the `ROOT\bin` directory to `ROOT\client`.

If you’ve left the tomcat server running, you should be able to open http://HOSTNAME:8080/client/BigBlueButton.html (tomcat is case sensitive) and see the login screen.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/first_login_prompt.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/first_login_prompt.png)

Note, you won't be able to login yet -- there's no Red5 server running yet for the Flash client to connect.


## Install BigBlueButton Server ##

The BigBlueButton server is the Red5 server with some additional applications.

We've packaged up a slimmed-down version of the Red5 server.
  1. Download the latest bbb-server (ZIP file) from the [Downloads](http://code.google.com/p/bigbluebutton/downloads/list).
  1. Unzip bbb-server into `TOOLS_DIR\bbb-server`.
  1. Download the latest bigbluebutton-apps(ZIP file) from the [Downloads](http://code.google.com/p/bigbluebutton/downloads/list).
  1. Unzip bigbluebutton-apps it in `TOOLS_DIR\bbb-server\webapps`.

At this point, your `bbb-server` directory should look like this:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/bbb-server_layout.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/bbb-server_layout.png)

We're almost ready to login for real.  Before we do this, we need to ensure there are some conference room (ID) defined for users to join.

  1. Edit `TOOLS_DIR\bbb-server\webapps\conference\conferences\conferences.xml` to create conference rooms.
  1. Copy the text below and save it to this file.

Note: This file was created under UNIX, so it's missing the carriage returns Windows expects.  You can edit it by using a programmer's editor (such as [textpad](http://www.textpad.com/)), or, as indicated above, paste in the following:

```
<?xml version="1.0" encoding="UTF-8" ?>
<conference-rooms>
    <conference-room>
        <name>85115</name>
        <mod-password>modpass</mod-password>
        <view-password>viewpass</view-password>
    </conference-room>

    <conference-room>
        <name>85101</name>
        <mod-password>modpass</mod-password>
        <view-password>viewpass</view-password>
    </conference-room>
</conference-rooms> 	
```

Next, we need to edit `modules.xml`.  On startup, the BigBlueButton client uses this XML file to retrieve the hostname (or IP address) for the Red5 server for each module it loads, along with the URL to upload slides to the tomcat server.

  1. Edit `TOOLS_DIR\tomcat\webapps\ROOT\client\conf\modules.xml`.
  1. Change all instances of `localhost` to `HOSTNAME`.
  1. Change the `host` attribute for `PresentationModule` to `HOSTNAME:8080`.   (If you changed tomcat to listen on port 80, you can omit this step.
  1. Save the file.

For example, if you are using the IP address 192.168.0.150 for `HOSTNAME` and your tomcat server is running on port 8080, then `modules.xml` should contain the following values:
```
<modules>
	<module name="VideoModule" url="VideoModule.swf" uri="rtmp://192.168.0.150/oflaDemo" />
	<module name="ChatModule" url="ChatModule.swf" uri="rtmp://192.168.0.150/chatServer" />
	<module name="ViewersModule" url="ViewersModule.swf" uri="rtmp://192.168.0.150/conference" />
	<module name="ListenersModule" url="ListenersModule.swf" uri="rtmp://192.168.0.150/astmeetme" />
	<module name="PresentationModule" url="PresentationModule.swf" 
		uri="rtmp://192.168.0.150/presentation" host="http://192.168.0.150:8080" />
</modules>
```


## Login Check ##

At this point we have installed enough components to login.  First, let's make sure all the servers are running.

## Start activeMQ server ##
If not already running, start the activeMQ server.
  1. Open a new command window.
  1. Change directory to `TOOlS_DIR\activeMQ\bin`
  1. type `activemq.bat`

## Start tomcat server ##
If not already running, start the tomcat server.
  1. Open a new command window.
  1. Change directory to `TOOlS_DIR\tomcat\bin`
  1. type `catalina.bat start`

## Start BigBlueButton server ##
If not already running, start the BigBlueButton server.
  1. Open a new command window.
  1. Change directory to `TOOLS_DIR\bbb-server`
  1. type `red5.bat`

Tthe BigBlueButton server (Red5 server) takes about 10 seconds to first startup.

After it's running, open `http://HOSTNAME:8080/client/BigBlueButton.html` and login with your name, conference ID `85115`, and password `modpass`.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/real_login.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/real_login.png)

You should see the main screen.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/first_login_success.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/first_login_success.png)

At this point, you can start multiple clients from multiple browser and chat.  You can also share your web cams.  However, before you can upload slides, you'll need to configure the `bigbluebutton.war` servle.


## Configure bigbluebutton.war ##

This servlet accepts the upload of PDF slides from the BigBlueButton client.  The servlet uses pdftk and pdf2swf to convert the uploaded file into individual SWF images that the BigBlueButton client can display.

  1. Download the latest bigbluebutton.war file from the [Downloads](http://code.google.com/p/bigbluebutton/downloads/list).
  1. Put into `TOOLS_DIR\tomcat\webapps`.
  1. Start the tomcat server (no need to restart if it's already running).  In the tomcat server console you should see it unpacking the WAR file into the webapps directory).
  1. After the unpacking is finished, edit `TOOLS_DIR\tomcat\webapps\bigbluebutton\WEB-INF\bigbluebutton.properties` specify the locations for pdf2swf, pdftk, and the upload directory.

If you've been using the suggested defaults in this guide, you can copy and paste the following configuration:
```
# Define these to prevent warning messages   
openoffice.host=localhost
openoffice.port=8100

# Edit to point to your pdf2swf executable
swftoolLocation=c:/tools/swftools/pdf2swf

# Edit to point to your pdftk executable
pdfExtractor=c:/tools/pdftk/pdftk

# The base directory where uploaded slides are extracted
presBaseDirectory=c:/temp/uploads
extractedFolder=extracted
```


## Try uploading a PDF file ##

You are ready to share slides.  To upload a PDF file, you need to make yourself presenter.  to make yourself presenter, first click on your name to highligh it, then click the Make Presenter button.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step1.png)

Next, click the Upload PDF button.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step2.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step2.png)

Next, click the '+' button to select a PDF file to upload.  If you don't have one ready, there's one installed with Tomcat in `TOOLS_DIR\tomcat\webapps\docs\architecture\requestProcess\requestProcess.pdf`.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step3.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/make_presenter_step3.png)

Click Upload button.

You should see the slides converting, then displayed.



## Troubleshooting ##

### Security Error on Upload of slides ###

If you get a security error when trying to upload slides

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/security_error.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/install_win/security_error.png)

then check the value for `host` in `TOOLS_DIR\tomcat\webapps\ROOT\client\conf\modules.xml`.  For example, if this value is `http://92.168.0.150:8080`, then try entering that URL into your browser.  You should get the welcome page for the tomcat server.

### Upload is successful, but there are no converting 1 of N, 2 of N messages ###

Try shutting down the activeMQ, tomcat, and BigBlueButton servers.  Then start activeMQ first, then tomcat and BigBlueButton servers.  Try again.