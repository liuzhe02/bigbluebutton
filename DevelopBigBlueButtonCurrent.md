<font color='44388'><i>This document is currently a Draft</i></font>



# Getting Help #
We're developers as well, and we know the importance of both well-written documentation and accessible developer support.bbb-web-setup.png

If you have any problems when following the documentation below, please post your questions to [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2&pli=1) mailing list, or visit the #bigbluebutton channel on Freenode, using IRC.

# Setting up a BigBlueButton Development Environment #
The easiest way to develop BigBlueButton is through an already setup Virtual Machine, which you can download [here](BigBlueButtonVM.md). The VM has tools already set up which will get you up and running quickly. The VM has an added benefit in that you can develop on it from your Windows or Mac environment, where you can get access to Flash Builder. This document explains how to develop with the VM in mind.

**Tip**: For connecting to your BigBlueButton VM via a terminal we recommend [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/).

## Acessing your VM ##
From your Windows environment, you'll want to access the BigBlueButton source code that resides on your VM.  To do this, login to the VM as `firstuser` and issue the following command

```
bbb-conf --setup-samba
```

This script will share the `/home/firstuser/dev` on your VM so you can access it from within Windows.  Some editors (such as Eclipse) can only access drives (not network shares).  To map this network share to a windows drive (e.g. V:), open Windows Explorer, hit the Alt key, and choose the menu command Tools -> Map Network Drive. For the path, enter `\\<ip>\firstuser`, the ip being the local address of your VM.

See the [BBBConf](BBBConf.md) page for troubleshooting tips.


## Check Out the Source Code ##
Type the following command to checkout BigBlueButton from our [github repository](http://www.github.com/bigbluebutton).
```
bbb-conf --checkout
```

This will checkout into `/home/firstuser/dev/source/bigbluebutton`.

If you want to learn more about Git, read the book [Pro Git](http://progit.org/book/) especially chapters 1, 2, 3, 5. [GitHub Help](http://help.github.com/) has a lot of information too.

# Developing Components of BigBlueButton #

## Working on the Client side ##
To setup a development environment for bbb-client, enter the following command
```
bbb-conf --setup-dev client
```
This will setup some directories and modify nginx config to use your development client.

Everything is now setup to compile bbb-client.

To compile the client:
```
cd ~/dev/source/bigbluebutton/bigbluebutton-client
ant
```

Behind the scenes, nginx is now loading the client from `~/dev/source/bigbluebutton/bigbluebutton-client/bin`.
If the IP address for your BigBlueButtom VM is 192.168.0.211, you should be able to browse to http://192.168.0.211/, login to the web interface, and see your new client load.

Every time you make a change to the client source, you need to rebuild it using the 'ant' command in order for the changes to show in your browser. If you haven't changed the localization files then you only need to run
```
ant modules
```
This will skip building the localization .swf files, and save you a lot of time.

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/dev/bbb-client-setup.png' />

### Using Flex/Flash Builder ###
To develop the client using Flash Builder, follow these steps:
  1. Install Flash Builder on your Windows/Mac machine.
  1. Setup samba on the VM and mount the VM drive as described earlier in this document.
  1. In Flash Builder, import the project by going to File -> Import -> Flash Builder Project.
    1. Select the Project Folder radio
    1. Click Browse and choose the bigbluebutton-client directory in your VM. For example W:\dev\source\bigbluebutton\bigbluebutton-client
    1. Click finish.
  1. Right click on the project, go to Properties -> Flex Compiler, and change the Flex version to 3.5. (BigBlueButton does not yet work with Flex 4)
  1. In the same window, make sure the Flash Player specific version is set to at least 10.0.0.
  1. In the Flex Modules section of the properties window, add all the modules that you would like compiled with bbb-client. The modules are mxml files located in the src/ directory (default package).
  1. In the Package Explorer navigate to src/(default package) and _Right Click_ on BigBlueButton.mxml and click on Set As Default Application.
  1. Compile the client in Flash Builder, then open the client in your browser by going to the VM IP. The client running there should now be the client in your Flash Builder environment.

This approach is limited in the sense that you can't use the Run button within Flash Builder to launch the client. You also can't use the Flex debugger. To be able to launch the client from Flash Builder, do the following:
  1. On the client code, edit `src/conf/config.xml` and near the top change the line:

```
<application uri="rtmp://<HOST-IP>/bigbluebutton" host="http://<HOST-IP>/bigbluebutton/api/enter" />
```
to
```
<application uri="rtmp://<HOST-IP>/bigbluebutton" host="conf/join-mock.xml" />
```
  1. You should now be able to launch from Flash Builder using the Run/Debug button.

### Your First Modification of BigBlueButton ###
At this point we are going to adorn our rubber boots and jump right in.  We are going to make a small modification to the UI so that you can start perusing the code.
  1. In the Package Explorer navigate to src -> org.bigbluebutton -> main -> views -> MainApplicationShell.mxml
  1. Scroll down to near the end of the document and look for `<mx:Label text="{ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2',[appVersion])}" id="copyrightLabel2"/>`.  This string is the Footer label that contains copyright data, version, etc.
  1. Modify the text property to change the text that is displayed. For example:
```
 <mx:Label text="My Modified BigBlueButton Client" id="copyrightLabel2"/>
```
> <img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/dev/FlashBuilderModify.png' height='500' />
  1. To recompile the project save the file you just edited just save the file.

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/dev/ModifiedBBBClient.png' height='500' />

Congradulations, you have now made your first change to BigBlueButton.

## Working with BigBlueButton Web - The API part of BBB ##
The BigBlueButton web interface is written in grails, so the development environment different from building the Client (bbb-client).  As before, the first step is to use `bbb-conf` to setup the environment.

Configure the environment
```
bbb-conf --setup-dev web
```
> This script does the following steps:
    1. sets your local IP address into  `~/.grails/bigbluebutton-config.properties`
    1. make all files in `/var/bigbluebutton` writable by everyone
> The first step sets up a global property for grails so it knows the IP address of your server when it runs.  The second step opens the permissions to slides directory so `firstuser` can upload a presentation.
> > <img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/dev/bbb-web-setup.png' />


> <b>Note</b>:  If you get an error upload slides when running bbb-web as `firstuser`, run the command `sudo chmod -R a+rwx /var/bigbluebutton`.

Stop Tomcat so you can compile your bbb-web
```
sudo service tomcat6 stop
```
Compile and run bbb-web
```
cd ~/dev/source/bigbluebutton/bigbluebutton-web
ant
```

The default task for ant here is to make sure your libraries are up-to-date (using ivy), then execute the command `grails run-app`.  This will output the console to the command line, making it easier for you to see any exceptions thrown by grails.  To stop the grails server, just hit CTRL-C.

## Working with BigBlueButton-Apps ##

The BigBlueButton web apps run within the red5 server.  Unlike development with bbb-client and bbb-web, where we could leave the packaged versions installed, there is only one red5 server on the VM.  In order to do development with it we need to remove the existing bbb-apps first.  (Don't worry, you can easily restore them as shown at the end of this section).

Configure the environment
```
bbb-conf --setup-dev apps
```

> This will

  1. Enable write access to `/usr/share/red5/webapps`
  1. Uninstall the existing `bbb-apps` package
  1. Creates a `~/.bbb-apps-build.properties` file that sets the property `red5.home = /usr/share/red5`
> <img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/dev/bbb-apps-setup.png' />

> Uninstalling the existing `bbb-apps` package will stop the red5 server, remove the directory `/usr/share/red5/webapps/bigbluebutton`, and restart red5.

At this point Red5 would have restarted.  However, before we deploy the local version of bbb-apps, we need to stop the Red5 server.  Open a new terminal window (you will need to start and stop Red5 as you develop) and stop Red5.
```
sudo service red5 stop
```

We'll come back to this separate terminal window in a moment.  Now, let's build and deploy the local copy of bbb-apps.

```
cd ~/dev/source/bigbluebutton/bigbluebutton-apps/
gradle war deploy
```

At this point, the ant script has copied the local build of bbb-apps to `/usr/share/red5/webapps/bigbluebutton`.  Now switch back to the second terminal window and enter the following command:

```
cd /usr/share/red5
sudo -u red5 ./red5.sh
```

You'll now see all the output from red5 directly at the console.  Like running the grails server at the command line, running red5 from the command line gives you easy visibility of any errors or exceptions that may occure.

# Using an IDE - Eclipse instructions #

## Pre-requisites ##
At this point it is assumed you have gone through setting up the client, bbb-web and bbb-apps environments and will be working with the BigBlueButton Virtual Machine.  In this section, we will be Windows with Eclipse and Flash Builder.

The following tools are installed in the Virtual Machine:
  1. JDK 6 and add JAVA\_HOME in your environment variables
  1. Grails 1.1.1 and add GRAILS\_HOME in your environment variables

The following tools are needed on Windows:
  1. Eclipse
  1. Flash Builder
  1. [Scala Eclipse plugin](http://www.scala-ide.org/)
  1. [Groovy Eclipse plugin](http://groovy.codehaus.org/Eclipse+Plugin)

## BigBlueButton Commons Libraries ##
The bbb-commons contain classes that are common to bbb-web and bbb-apps.
  1. Switch to the location of `bbb-commons`
```
cd ~/dev/source/bigbluebutton/bbb-common-message
```
  1. Generate Eclipse project files
```
gradle eclipse
```
  1. Import to your Eclipse by File->New->Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/bbb-common-message`
  1. Setup the build path. Right-click on the project, chose Build Path->Configure Build Path
  1. Click on the Source tab and add folder `src/main/java`
  1. Compile the classes
```
gradle jar  
```
  1. Copy the jar file to /home/firstuser/dev/repo
```
gradle uploadArchives 
```

## BigBlueButton Web ##
  1. Change directory to `bigbluebutton-web`
```
cd ~/dev/source/bigbluebutton/bigbluebutton-web
```
  1. Download all dependencies specifically bbb-commons from `/home/firstuser/dev/repo`
```
gradle copyToLib 
```
  1. Import to your Eclipse by File->New->Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/bigbluebutton-web`
  1. Start bbb-web
```
ant 
```

**NOTE**: If you encounter an error with the webapp redirecting to an invalid client, open the file `./grails-app/conf/bigbluebutton.properties` and edit the line bigbluebutton.web.serverURL to point to the url of your machine.

## BigBlueButton Apps ##
  1. Change directory to `bigbluebutton-apps`
```
cd ~/dev/source/bigbluebutton/bigbluebutton-apps
```
  1. Generate Eclipse project files
```
gradle eclipse
```
  1. Download all dependencies specifically bbb-commons from /home/firstuser/dev/repo
```
gradle resolveDeps
```
  1. Import to your Eclipse by File->New->Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/bigbluebutton-apps`
  1. Right-click on the project and add Scala Nature and Groovy Nature
  1. Setup your build path and library
  1. Build the application
```
gradle war
```
  1. Deploy the application to Red5 (`/usr/share/red5/webapps`)
```
sudo gradle deploy
```

## Video App ##
  1. Import to your Eclipse by File->New->Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/bbb-video`
```
cd ~/dev/source/bigbluebutton/bbb-video
```
  1. Download all dependencies
```
ant resolve
```
  1. Build the application
```
ant dist
```
  1. Deploy the application to Red5 (`/usr/share/red5/webapps`)
```
ant deploy
```

## Voice App ##
  1. Import to your Eclipse by File -> New -> Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/bbb-voice`
```
cd ~/dev/source/git/bigbluebutton/bbb-video
```
  1. Download all dependencies
```
gradle copyToLib
```
  1. Build the application
```
gradle war
```
  1. Deploy the application to Red5 (`/usr/share/red5/webapps`)
```
gradle deploy
```

## Desktop Sharing App ##
  1. Import to your Eclipse by File->New->Java Project and then choose Create project from existing source pointing to your `~/dev/source/git/bigbluebutton/deskshare`
```
cd ~/dev/source/bigbluebutton/deskshare
```
  1. Download all dependencies
```
gradle copyToLib
```
  1. Build the server component
```
cd app
gradle war
```
  1. Deploy the application to Red5 (`/usr/share/red5/webapps`)
```
gradle deploy
```
  1. To build the applet
```
cd applet
gradle jar
```
  1. Create the signing key
```
ant create-signing-key
```
  1. Sign the applet
```
ant sign-jar
```
  1. Copy deskshare/applet/build/libs/bbb-deskshare-applet-0.64.jar to ~/dev/source/bigbluebutton/bigbluebutton-client/resources
```
cp ~/dev/source/bigbluebutton/deskshare/applet/build/libs/bbb-deskshare-applet-0.64.jar ~/dev/source/bigbluebutton/bigbluebutton-client/resources/prod
```
  1. compile the bbb-client (see Developing with bbb client)

## Tips ##
**Run bbb-conf --check**
Run `sudo bbb-conf --check` to see if there are any potential problems.

### Running Red5 ###

It is better to have multiple ssh windows while developing. On one window, you can start and stop Red5.
  1. Stop Red5
```
sudo service red5 stop
```
  1. cd to Red5 directory
```
cd /usr/share/red5
```
  1. Start Red5 as red5 user
```
sudo -u red5 ./red5.sh
```

In another window, you can make your code changes and deploy to Red5, e.g.
```
cd ~/dev/source/git/bigbluebutton/bigbluebutton-apps
```
  1. Make some changes
  1. Build
```
gradle war
```
  1. Deploy
```
gradle deploy
```


### Removing BBB packages ###

List the BBB packages by typing
```
dpkg -l | grep bbb
```

which results:
```
ii  bbb-apps                        0.71ubuntu2             BigBlueButton applications for Red5
ii  bbb-apps-deskshare              0.71ubuntu2             BigBlueButton deskshare module for Red5
ii  bbb-apps-sip                    0.71ubuntu2             BigBlueButton SIP module for Red5
ii  bbb-apps-video                  0.71ubuntu2             BigBlueButton video module for Red5
ii  bbb-client                      0.71ubuntu15            BigBlueButton Flash client
ii  bbb-common                      0.71ubuntu6             BigBlueButton common files
ii  bbb-config                      0.71ubuntu6             BigBlueButton group package
ii  bbb-freeswitch-config           0.71ubuntu2             BigBlueButton group package
ii  bbb-openoffice-headless         0.71ubuntu2             BigBlueButton wrapper for OpenOffice
ii  bbb-voice-conference            0.71ubuntu3             BigBlueButton voice conference files
ii  bbb-web                         0.71ubuntu4             BigBlueButton web interface
ii  bigbluebutton                   0.71ubuntu4             Open Source Web Conferencing System (bbb)
```

  * To remove a package type `apt-get remove <package name>`
> Example, if you want to remove bbb-apps
```
sudo apt-get remove bbb-apps
```

## Creating a new BigBlueButton Module ##
Follow this short [tutorial](SampleModule.md).


# Troubleshooting #

## Returning to the Packaged Client ##
If you ever wish to revert back to the bbb-client installed from packages, edit `/etc/nginx/sites-available/bigbluebutton` and make the entry for `/client` match the following.

```
location /client {
	root    /var/www/bigbluebutton;
	index  index.html index.htm;
}
```

Then restart nginx.

```
sudo service nginx restart
```

## Returning to the Packaged BBB-Web ##
If you want to revert back to the web interface installed by the package bbb-web, stop grails and restart the tomcat6 server.
```
sudo service tomcat6 start
```

<b>Note</b>: After starting the tomcat server, try to join a conference. If you receive the message "_The page you are looking for is temporarily unavailable. Please try again later._", then the grails server could still be running and not tomcat. Enter the following command
```
sudo bbb-conf -c
```

Look under the Potential Problems heading to see if a problem has been detected.  If grails is still running then to resolve this we need to kill it.

  1. Determine its pid (process id)
```
ps -aef | grep grails
```
  1. Kill it!
```
sudo kill -9 <Grails PID>
```
  1. Finally, we need to start Tomcat
```
sudo service tomcat6 start
```

## Returning to the Packaged BBB-Apps ##
If you want to revert back to the packaged versions of BigBlueButton apps, do the following
```
rm -rf /usr/share/red5/webapps/bigbluebutton
sudo apt-get install bbb-apps
sudo service red5 start
```

## Debugging FreeSWITCH ##
To start FreeSWITCH so you can see any errors produced by it run:
```
sudo /opt/freeswitch/bin/fs_cli
```

If voice isn't working in the BBB interface or your listeners are not showing up the most likely reason is that FreeSWITCH and Red5 are not communicating properly.
Check the configuration files and make sure that FreeSWITCH and Red5 are pointing at each other.
Edit `/opt/freeswitch/conf/autoload_configs/event_socket.conf.xml`.
```
vi /opt/freeswitch/conf/autoload_configs/event_socket.conf.xml
```
Check the listen-ip parameter
```
<param name="listen-ip" value="192.168.0.211"/>
```

Edit `/usr/share/red5/webapps/bigbluebutton/WEB-INF/bigbluebutton.properties`
Set esl.host to your IP
```
esl.host=192.168.0.211
```

Lastly, make sure that the sip.server.host property in `/usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties` is set to your FreeSWITCH server.
```
vi /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
```
Edit the host address to match you own.
```
sip.server.host=192.168.0.211
```

**Note**: Make sure your two Red5 IPs are ponting to FreeSWITCH and that your FreeSWITCH IP ip pointing to your Red5 sever.  Otherwise, Red5 won't know what SIP server to use and both FreeSWITCH and Red5 won't be able to communicate events with eachother (stopping the voice users from showing up in the Listeners Window).

## Launching from Flex/Flash Builder ##
If you get the compile error:
```
unable to open 'W:\dev\source\bigbluebutton\bigbluebutton-client\tests\unit'	bigbluebutton-client		Unknown	Flex Problem
```
Just create the missing directories. This is a problem caused by an improperly generated .actionScriptProperties file in bbb-client/


If you get the compile error:
```
The style 'backgroundImage' is only supported by type 'flexlib.mdi.containers.MDIWindow' with the theme(s) 'halo'.	DesktopPublishWindow.mxml	/bigbluebutton-client/src/org/bigbluebutton/modules/deskshare/view/components	line 33	Flex Problem
```
Right click on your project, go to Flex Compiler. Change SDK to 3.5, and Flash Player version to 10.0.0.

If the client hangs at startup:
and the last line in the log is:
```
8/31/2010 21:16:28.795 [DEBUG] Join FAILED = <join>
  <returncode>FAILED</returncode>
  <message>Could not find conference null.</message>
</join>
```
Make sure your config.xml file has the host property "conf/join-mock.xml".

If your client throws an error at startup saying it cannot find the join-mock.xml, make sure you copy it over from bbb-client/resources/dev into bbb-client/src/conf.

## Helpful Hints ##
If you run into issues, please send email to the bigbluebutton-dev mailing list.
### Gradle ###
`gradle copyToLib` has been changed to `gradle resolveDeps`, if one doesn't work, try the other as not all instances have been converted.

### The Client ###
If you notice you are running a version other than the newest here is how to bring your copy of the code upto date.

The Git Repository is tagged to not give out the latest development version.  This way the code you are using is never broken.  To get the `master` version:
```
git pull origin master
```

### BigBlueButton Web ###
You will need to run the grails version of bigbluebutton-web which will allow you to see debugging information.  Make sure tomcat6 is stopped and swich to the `bigbluebutton-web` directory.
```
sudo service tomcat6 stop
cd ~/dev/source/bigbluebutton/bigbluebutton-web
```
  * Did you already run "bbb-conf --setup-dev web"? If not setup [BigBlueButton Web](DevelopBigBlueButtonCurrent#BigBlueButton_Web.md)
Now run the war file
```
grails run-war
```