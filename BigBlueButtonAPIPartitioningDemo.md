# Checkout the code and try out the API's #

_This document is depreciated._

You can check out the code for the API partitioning from the following repository ` git://github.com/coralcea/bigbluebutton.git ` and here are the steps to checkout the code:

  1. Create a directory to check out your code there, such as "/bigbluebutton\_api/".
  1. Run command `git init` to initialize the directory as a local git repository.
  1. Clone the main repository ` git://github.com/coralcea/bigbluebutton.git ` by using the command `git clone git://github.com/coralcea/bigbluebutton.git`.


After checking out the code, follow the steps for building and deploying the different pieces that are related to the API and here is how:

  1. bigbluebutton-client part, follow the instructions on how to build and run the client code as described on the [DevelopingBBB](DevelopingBBB.md) page at [here](http://code.google.com/p/bigbluebutton/wiki/DevelopingBBB#Working_on_the_Client_side)
  1. bbb-common-message, follow the instructions on the the [DevelopingBBB](DevelopingBBB.md) page [here](http://code.google.com/p/bigbluebutton/wiki/DevelopingBBB#BigBlueButton_Commons_Libraries) to build and resolve dependencies (i.e copy required .jar files for BBB).
  1. bigbluebutton-apps, follow the instructions on how to build and run the client code as described on the [DevelopingBBB](DevelopingBBB.md) page [here](http://code.google.com/p/bigbluebutton/wiki/DevelopingBBB#BigBlueButton_Apps)
  1. bigbluebutton-web, follow the instructions on how to build and run the client code as described on the [DevelopingBBB](DevelopingBBB.md) page  [here](http://code.google.com/p/bigbluebutton/wiki/DevelopingBBB#BigBlueButton_Web)


## How to try out the code ##

Here are the available API calls so far:

  * Before starting anything you have to create a meeting room by calling the "create" API call. This should bring up the Bigbluebutton Demo page (see below), then you can log in.

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/API_PART/BBB-API-DemoScreen.jpg' />

  * After logging in the Bigbluebutton client will load all the Bigbluebutton modules but  only 2 frames will be shown (Listeners and Viewers)(See image below). The rest of the modules (i.e. Chat, Presentation, Video, and Voice) are not started until a command is sent to start or stop.

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/API_PART/BBB-API-MainScreen.jpg' />

  * You can start and stop the chat module for the Bigbluebutton within the Bigbluebutton client canvas so far (we are aiming to load each module in its own frame independently)

  * To start Chat Module use (see image for Chat module started only)
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=ChatModule&cmd=start`

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/API_PART/BBB-API-Chat Module started.jpg' />

  * To stop Chat Module use
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=ChatModule&cmd=stop`

  * You can load up, start and stop the presentation module for the Bigbluebutton within the Bigbluebutton client canvas so far (the same goes for aiming to load independently)

  * To start Presentation Module use (see image for Presentation module started only)
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=PresentModule&cmd=start `

<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/API_PART/BBB-API-Presentaion Module started.jpg' />

  * To stop Presentation Module use
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=PresentModule&cmd=stop `

  * To start Voice Module use
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=dummy&cmd=init_voice` , then you can click the "Headset" button to join or leave a voice conference.

  * To start Video Module use
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=dummy&cmd=init_video` , the click on the "Camera" button to start your video.

  * All Modules wildcard API Call(s): To make the call for starting or stop all the module use the command

`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=All&cmd=<start/stop> `

**NOTE**: The Desktopshare API call is still not implemented, but we are planning on executing it soon.
To try out the API calls follow these steps:

  1. Start you Bigbluebutton server.
  1. Call the Bigbluebbutton welcome page (i.e. http://YOUR_IP/), Bigbluebutton welcome page should come up with only Listers and Viewers windows.
  1. Open another browser window and paste the link associated with the action you want (i.e. start chat, stop chat, etc) basically we are sending an HTTP POST to call the method.


**NOTE:**
  * In case of using the command
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=VideoconfModule&cmd=start ` will result starting multiple instances of the BBB the video module which reults having multiple Camera buttons on the toolbar and will not start a new Webcam window.
  * Using the command
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=VideoconfModule&cmd=stop ` results disabling the Camera button(s) and killing (closing) the Webcam view window.

  * In case of using the command
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=PhoneModule&cmd=start ` will reult it will show the Headset button on the toolbar

  * Using the command
`http://YOUR_IP_ADDRESS/bigbluebutton/api/moduleCmd?meetingID=Demo+Meeting&module=phoneModule&cmd=stop ` will kill (removes) the Headset button from the toolbar.



## Potential Problems ##

  * When building the client make sure that the /tools/ directory exists otherwise the client won't build. This tends to happen if you are developing Bigbluebutton client code outside the VM environment.

  * Another problem associated with deploying the bigbluebutton-web: you have to call ‘ant war’ command for you bigbluebutton-web and then deploy the resulted war file
  1. Rename created file: bigbluebutton-0.71dev.war to bigbluebutton.war
  1. Delete file bigbluebutton.war and directory bigbluebutton under /var/lib/tomcat6/webapps/
  1. Copy the new bigbluebutton.war to /var/lib/tomcat6/webapps/
  1. Re-start the Tomcat server.


  * A client/user joining a conference room after calling the "moduleCommand" will not have the started modules loaded into his Bigbluebutton canvas and the started modules has to be initiated again.




_Note: Any comments or input is more welcome to improve our work_

_To be added_