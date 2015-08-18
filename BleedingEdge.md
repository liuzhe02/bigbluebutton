**Note:** This was a temporary page for information on the 0.71 release.  This page is now marked as depreciated.  Please see [BigBlueButton Google Code Home Page](http://code.google.com/p/bigbluebutton/) for the latest content.

## Introduction ##
This document assumes you are developing from the latest source. So first thing you should do is pull the latest source if you haven't already. It's updated frequently. If you're having a problem with the latest source and this document isn't helping you, come to the #bigbluebutton channel on freenode, or write to the bigbluebutton-dev mailing list.

### Client issues ###
The current client build does not generate the proper config.xml file, it creates an old version that no longer works.  There have been lots of changes to config.xml for 0.71 so it's important to get the latest one.

You can find the latest template for it in the bigbluebutton-client/resources/config.xml.template. Copy this file to src/conf and rename it config.xml.
```
cp ~/dev/source/bigbluebutton/bigbluebutton-client/resources/config.xml.template ~/dev/source/bigbluebutton/bigbluebutton-client/src/conf/config.xml
```

Inside the newly copied config.xml are place holders for your current hostname. Change all instances of HOST inside the file to your server ip. Then recompile the client.

If the client still hangs at load, and the last line in the client log (the icon on the bottom right) is:
```
8/31/2010 21:01:48.446 [DEBUG] JoinService:load(...) http://192.168.0.167/bigbluebutton/api/enter
```

Then the host property of your config.xml file is wrong. See [Client Configuration](http://code.google.com/p/bigbluebutton/wiki/ClientConfiguration#application) for details. In short, you're running the latest client but not the latest bbb-web, so the url of the host property is wrong. It should be:
```
host="http://192.168.0.167/bigbluebutton/conference-session/enter"
```

#### Launching from Flex/Flash Builder ####
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

### Building bbb-apps ###
First you need to go to the bbb-common-message project directory, and build it:
```
cd /home/firstuser/dev/source/bigbluebutton/bbb-common-message/
gradle jar
gradle uploadArchives
```
Then go back to bigbluebutton-apps, and you should be able to compile and deploy it:
```
cd /home/firstuser/dev/source/bigbluebutton/bigbluebutton-apps
gradle war deploy
```
Then restart red5 and you should be good to go

### Client logs out first time when you try to log in ###
the red5 log should throw an error that has to do with freeswitch. When you log in the second time everything will work fine, but if you want to get rid of that initial error you can go to:
```
/usr/share/red5/webapps/bigbluebutton/WEB-INF
vi red5-web.xml
```
Near the bottom you will see a line:
```
<import resource="bbb-voice-freeswitch.xml" />
```
Change it to:
```
<import resource="bbb-voice-asterisk.xml" />
```

### bbb-voice problems ###
When you compile and deploy bbb-voice, you may also need to change the ip in:
```
/usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
```
Near the top there, change the sip.server.host to your ip