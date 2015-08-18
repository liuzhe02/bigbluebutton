note: **This page is out of date.  Please see [Developing BigBlueButton](DevelopingBBB.md)**.




# Setting up a BigBlueButton Development Environment #
We want it to be easy for others to develop and extend BigBlueButton.  To achieve this, rather than writing lots of code and throwing a tarball over the wall, we've tried to provide you the tools and documentation setup your own BigBlueButton development environment, giving you the ability to edit, test, and deploy changes to your BigBlueButton server.

One of these tools is the BigBlueButtonVM itself.  Currently, there are over fourteen OpenSourceComponents in BigBlueButton, and it's no small feat to [set everything up from scratch](InstallingBigBlueButton.md).  In the beginning, when we started developing BigBlueButton, we did everything on Windows.  Later, we would manually install the components on a Unix server.  That was a pain as the differences between running BigBlueButton on Windows and Linux caused us lots of support headaches.  Next, we created Ubuntu packages so [installation](InstallationUbuntu.md) on Unix would only take a few minutes.  Then we configured a [Hudson server](http://bigbluebutton.org/hudson/) to automatically compile and build the packages when developers check in updates to our Google Code SVN.  The pain reduced, but we were still building and running BigBlueButton in Windows, then running it on Unix.

The last step was to edit on Windows, but compile and run on Linux.  We did this by running a custom Linux VM (using VMWare player) that had all the development environment setup.  In parallel, we were also shipping a BigBlueButton VM that had all the runtime environment setup.  (You can see where this is heading).  We evolved our process to create a BigBlueButton VM that is (a) a fully functional implementation of BigBlueButton _and_ (b) a complete development environment.  Not only did we save ourselves a lot of effort, but we can offer you the same environment we use to develop BigBlueButton.

The BigBlueButton VM runs Ubuntu 9.04.  Of course, you may not be developing using Ubuntu, nor may you want to run the VM.  In that case, the VM provides you with a working, reference implementation; by looking through the configuration (and using the docs below), you should be able to configure your own development environment on the Unix OS of your choice.

The first half of this document begins by showing you how to make quick changes to BigBlueButton's and immediately see the updates in the your VM.  The second half of this document shows how to setup Eclipse and Flex Builder to do day-to-day development.  Our approach is to use Windows for running Eclipse and Flex Builder, but the files are written to a BigBlueButton VM (via a Samba network share).


## Getting Started ##
First, setup a BigBlueButtonVM if you have not already done so.  If you are totally new to BigBlueButton, you should read the [Architecture Overview](ArchitectureOverview.md).  Doing so will make the following instructions much easier to understand.

Briefly, there are three main components to BigBlueButton.  Each component has it's own runtime environment and, correspondingly, each is built using different tools.

  * bigbluebutton-web, referred as _bbb-web_, is the scheduling and web interface for BigBlueButton.  This component is written in grails and is built using goovy.
  * bigbluebutton-client, referred to as _bbb-client_, is the real-time Flash client.  This component is written in actionscript v3 using the Flex framework.
  * bigbluebutton-apps, referred to as _bbb-apps_, is the red5 webapp that provides the synchronization logic for the bbb-client.  This component is written in straight up Java.

## Setting up access to the VM from windows ##

(Skip this if you are developing completely on Unix and are pure of heart.)  On Windows, you'll want to access the BigBlueButton source tree on your VM.  To do this, login to the VM as `firstuser` and issue the following command

```
  bbb-conf --setup-samba
```

This script will share the `/home/firstuser/dev` on your VM so you can access it as `\\<ip>\firstuser` from within Windows.  Some editors (such as Eclipse) can only access drives (not network shares).  To map this network share to a windows drive (e.g. V:), open Windows Explorer, hit the Alt key, and choose the menu command Tolls -> Map Network Drive.

Note: `bbb-conf` is a bash utility script included in the BigBlueButton VM. It's located in `/usr/local/bin/bbb-conf`.  If you want to see what happens when you invoke `bbb-conf`, just crack open the script; you can see all the commands it executes.  Doing this will help you understand how to setup your own development environment on a different Unix OS.


# How to make simple changes to BigBlueButton #
We will start by making a simple change to the BigBlueButton Flash client (bbb-client).

Note: If you want to jump right into setting up a complete environment, we recommend going through at least one of the examples below before skipping ahead to the next section on "Setup a Full Development Environment"

Let's begin.

## Making changes to the BigBlueButton Flex client: bbb-client ##

When building the client locally on the VM, the output will go into `/home/firstuser/dev/bbb-client`.  To setup a development environment for bbb-web, enter the following command

```
  bbb-conf --setup-dev bbb-client
```


You will be prompted to enter your password for `firstuser` as the script needs root access to run.   This script does the following:

  1. run `svn checkout http://bigbluebutton.googlecode.com/svn/trunk/bigbluebutton-client bbb-client`
  1. Modify the root for '/client' in the nginx configuration for BigBlueButton to point to `/home/firstuser/dev/bbb-client`
  1. Restart nginx
  1. Copy the `config.xml` from `/var/www/bigbluebutton/client/conf` into `~/dev/bbb-client/bin/conf/config.xml`

The first step anonymously checks out the source for bbb-client.  The next tells nginx to load your client (instead of the client in `/var/www/bigbluebutton`).

The last steps copies the current settings for `config.xml` into your local development directory.  This way, the local BigBlueButton client has the same configuration.

Everything is now setup to compile the local version of bbb-client.

```
  cd ~/dev/bbb-client
  ant localization
  ant
```

The first ant task runs the localization of the client, which builds language swf files from provided txt files.

The next line runs the default task (cleanandmake) and uses the mxmlc compiler to rebuild the client from source. The resulting client is stored into `~/dev/bbb-client/bin`.  If the IP address for your BigBlueButtom VM is 192.168.0.182, you should be able to browse to http://192.168.0.182/, login to the web interface, and see your new client load.

Okay, at this point it looks the same.  (Actually, it may look different because you are building from trunk, which likely will have changes from a release version).  Behind the scenes, nginx is loading the client from `~/dev/bbb-client/bin`.

Let's dive in and make a change.  Notice at the top of the client it says "You are logged in as ...".  To find where this string is specified in the code, enter the following command.

```
$ find . -exec grep -H "You are logged" '{}' \;
```

You should get a few matches, including the following:

```
./src/org/bigbluebutton/main/view/components/MainToolbar.mxml: \ 
loggedInUserLbl.text = "You are logged in as " + name + " to " + \
room + " as role " + role + ".";
```

Edit `./src/org/bigbluebutton/main/view/components/MainToolbar.mxml` and change the text "You are logged in as" to "You are NOW logged in as".  Type `ant` to rebuild the client.  Now open your web browser, login to BigBlueButton, and launch the client.  You should see the change at the top.

To revert back to the bbb-client installed from packages, edit `/etc/nginx/sites-available/bigbluebutton` and make the entry for `/client' match the following.

```
        location /client {
                root    /var/www/bigbluebutton;
                index  index.html index.htm;
        }
```

Then restart nginx.

```
   /etc/init.d/nginx restart
```

## Making changes to the BigBlueButton web interface: bbb-web ##

The BigBlueButton web interface is written in grails, so the development environment different from building the bbb-client.  As before, the first step is to use `bbb-conf` to setup the environment.

```
  bbb-conf --setup-dev bbb-web
```

This script does the following steps:

  1. svn checkout http://bigbluebutton.googlecode.com/svn/trunk/bigbluebutton-web bbb-web
  1. set your local IP address into  `~/.grails/bigbluebutton-config.properties`
  1. make all files in `/var/bigbluebutton` writable by everyone

The second step sets up a global property for grails so it knows the IP address of your server when it runs.  The third step opens the permissions to slides directory so `firstuser` can upload a presentation.

Note: If you get an error upload slides when running bbb-web as `first user`, run the command `sudo chmod -R ugo+rwx /var/bigbluebutton`.

Before you can compile and run your version of bbb-web, you need to stop tomcat.

```
  sudo /etc/init.d/tomcat6 stop
```

Next, let's compile and run bbb-web

```
  cd ~/dev/bbb-web
  ant
```

Note: The first time you do this you'll connection errors on `com.mysql.jdbc.Driver`. Just run `ant` again and it will each time afterwards.

The default task for ant here is to make sure your libraries are up-to-date (using ivy), then execute the command `grails run-app`.  This will output the console to the command line, making it easier for you to see any exceptions through by grails.  To stop the grails server, just hit CTRL-C.

If you want to revert back to the web interface installed by the package bbb-web, stop grails and restart the tomcat6 server.

```
  sudo /etc/init.d/tomcat6 start
```


## Making changes to the BigBlueButton red5 webapp: bbb-apps ##

The BigBlueButton web apps runs within the red5 server.  Unlike development with bbb-web and bbb-client, where we could leave the packaged versions installed, because there is only one red5 server on the VM, we need to remove the existing bbb-apps first.  (Don't worry, you can easily restore it as shown at the end of this section).

To setup a development environment for bbb-apps, enter the following command

```
  bbb-conf --setup-dev bbb-apps
```

This will

  1. checkout bbb-apps to `~/dev/bbb-apps`.
  1. Enable write access to `/usr/share/red5/webapps`
  1. Uninstall the existing `bbb-apps` package
  1. Creates a `~/.bbb-apps-build.properties` file that sets the property `red5.home = /usr/share/red5`

Uninstalling the existing `bbb-apps` package will stop the red5 server, remove the directory `/usr/share/red5/webapps/bigbluebutton`, and restart red5.

At this point red5 is still running.  Before we deploy the local version of bbb-apps, let's stop the red5 server.  Open a new terminal window (if you are on windows, we recommend installing [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/)) and enter the command.

```
    sudo /etc/init.d/red5 stop
```

We'll come back to this separate terminal window in a moment.  Now, let's build and deploy the local copy of bbb-apps.

```
    gradle war
```

At this point, the ant script has copied the local build of bbb-apps to `/usr/share/red5/webapps/bigbluebutton`.  Now switch back to the second terminal window and enter the following command:

```
    cd /usr/share/red5
    sudo -u red5 ./red5.sh
```

You'll now see all the output from red5 directly at the console.  Like running the grails server at the command line, running red5 from the command line gives you easy visibility to any errors or exceptions.

If you want to revert back to the packaged version of BigBlueButton apps, do the following

```
    rm -rf /usr/share/red5/webapps/bigbluebutton
    sudo apt-get install bbb-apps
    sudo /etc/init.d/red5 start
```

---


# Setup a Full Development Environment #

## Pre-requisites ##
On Windows:
  * Install Eclipse
  * Install FlexBuilder
  * Install [Subclipse plugin](http://subclipse.tigris.org/servlets/ProjectProcess?pageID=p4wYuA) for both Eclipse and FlexBuilder
  * Install JDK 6 and add JAVA\_HOME in your environment variables
  * Install Grails 1.1.1 and add GRAILS\_HOME in your environment variables


## Videos on how to develop with different bbb components ##
### Client ###
  * [bbb-client video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-client/index.html)
### Web-app ###
  * [bbb-web video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-web/index.html)
NOTE: If you encounter an error with the webapp redirecting to an invalid client, open the file grails-app/conf/bigbluebutton.properties and edit the line bigbluebutton.web.serverURL to point to the url of your machine.

### Server apps ###
  * [bbb-apps video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-apps/index.html)
```
Use these commands instead of the ant commands for 0.63:

gradle copyToLib
gradle war
gradle deploy

then restart red5
```

### Video app ###
  * [bbb-video video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-video/index.html)
### Voice app ###
  * [bbb-voice video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-voice/index.html)
```
Use these commands instead of the ant commands for 0.63:

gradle copyToLib
gradle war
gradle deploy

then restart red5
```
### Desktop Sharing app ###
  * [bbb-deskshare video](http://www.bigbluebutton.org/sites/all/videos/dev-env/bbb-deskshare/index.html)

## TIPS ##

**Remove BBB packages**

List the BBB packages by typing
```
dpkg -l | grep bbb
```

which results:
```
rc  bbb-apps                          0.35.0-1ubuntu113                         Red5 applications for BigBlueButton
ii  bbb-apps-deskshare                0.4.0-1ubuntu53                           Red5 applications for BigBlueButton deskshar
ii  bbb-apps-sip                      0.5.0-1ubuntu14                           Red5 applications for BigBlueButton SIP modu
ii  bbb-apps-video                    0.5.0-1ubuntu8                            Red5 applications for BigBlueButton Video mo
ii  bbb-config                        0.4.0-1ubuntu63                           Configuration setup for BigBlueButton

```

  * To remove, type e.g. `apt-get remove bbb-apps`


