# FAQ #
Added by daccattato, last edited by Paul Gregoire on Apr 22, 2009  (view change)
Labels:
faq, rtmp, rtmps, rtmpt, amf


# Frequency Asked Questions #

The best way you can help make this FAQ more useful is by asking questions: either in any of the places above, or by leaving your questions in the comments below.

  * Bugs and requests for new features can be submitted to JIRA.
  * Ideas for new features can be talked about in the discussion space

## GENERAL ##

  * What is Red5?
  * What version of Java do I need?
  * What does Red5 stand for?
  * Is there a migration guide from FMS to Red5?
  * How do I create new applications?
  * What are configuration files?
  * Is there a mailing list?
  * What is the mailing list etiquette? (TODO)
  * What Ports does Red5 use?
  * I'm interested in helping the project. How can I help?
  * Who is on the Red5 Team?
  * Are there any benchmarks? (TODO)

## DOCUMENTATION ##

  * Where is the official documentation?
  * Can I get the documentation in PDF format?
  * Where can I find the latest javadocs?

## CONFIGURATION ##

  * How to disable Socket policy checking for 443 (rtmps and https)?
  * How to change the way Red5/java listens on interfaces (change ipv6 to ipv4) ?
  * How can I have Red5 bind to multiple ports?

## STREAMING ##

  * How do I stream to/from custom directories?

  * How to detect the end of recording?
  * How can I record RTMP streams from Red5?
  * Does Red5 support multicast streaming?
  * Can Red5 stream using UDP?
  * What is up with H.264?

## CODECS ##

  * What\_Codecs\_does\_Red5\_Support?
  * What is RTMFP and when will it be available in Red5?

## DATABASE ##

  * What databases are supported?
  * Can I use Hibernate with Red5?


## SCRIPTING ##

  * What scripting languages are available?
  * Does Red5 support Actionscript 1?
  * Does Red5 support Actionscript 3?

## SHARED OBJECTS ##

  * What is a Remote SharedObject
  * How do you setup a Remote SharedObject?
  * How can I set a Remote SharedObject from the server (TODO)
  * How can I make a Remote SharedObject persistant on the server?
  * What are remote SharedObject slots?

## LEGAL STUFF ##

  * Licence Information
  * Is Red5 Legal?

  * Codec Licenses (TODO)
  * Third Party Licenses (TODO)

## Red5 WAR version ##

  * Is there any documentation on the Red5 war version?

## MISC ##

  * Is there an IRC channel?

  * Are there forums?
  * Are there any frameworks that I can start with?
  * What is Paperworld3D?
  * What is Jedai?
  * Are there free tools (TODO)
  * Are there development tools?
  * Are there video tutorials (TODO)
  * Are there any examples on the web?
  * Is there professional support?
  * Are there hosting solutions?
  * What Red5 groups can I join?
  * Do we support third party chat programs?

## TROUBLESHOOTING ##

  * Why am I receiving "closing due to long handshake?
  * IvyDE is complaining: Impossible to resolve dependencies of red5#server;working@

# Answers #
## GENERAL ##

**WHAT IS RED5?**

Red5 is an open source Flash RTMP server written in Java that supports:

  * Streaming Audio/Video (FLV and MP3)
  * Recording Client Streams (FLV only)
  * Shared Objects
  * Live Stream Publishing
  * Remoting



**What version of Java do I need?**

Version 1.5 or later is required. Java 5 is equal to version 1.5 just as Java 6 is equal to version 1.6. The prefered version to use is 1.6.


**What does Red5 stand for?**

Originally referenced to Star Wars.  Red5 was the "one who did the impossible".

**Is there a migration guide from FMS to Red5?**

Yes: docs:Chapter 5. Migration Guide

**How do I create new applications?**

see docs:Chapter 11. Create new applications in Red5

**What are configuration files?**

see: docs:Chapter 4. Configuration files used by Red5

**Is there a mailing list?**

  * Announcements mailinglist
  * Users mailinglist
  * Developers mailinglist
  * Tickets mailinglist
  * SVN Commits mailinglist

**What Ports does Red5 use?**
```
   http.port=5080            // tomcat or jetty servlet container
   rtmp.port=1935            // traditional rtmp
   rtmpt.port=8088           // rtmp tunneled over http
   rtmps.port=8443           // rtmp tunneled over https (secure)
   mrtmp.port=9035           // used with an edge/origin setup
   proxy.source_port=1936    // used to debug
```

These default ports can be changed in "[RED5\_HOME](RED5_HOME.md)\conf\red5.properties"

Additionally, most users only forward port 1935 and 5080

**I'm interested in helping the project. How can I help?**

You can create a new JIRA ticket for any contributions you want to make, attach the files there or link it. make sure you signup on the mailinglist as well..

**Who is on the Red5 Team?**

The Red5 Project (red5 AT osflash.org)

- Project Managers -
Chris Allen (mrchrisallen AT gmail.com)
John Grden (johng AT acmewebworks.com)

- Active Members -
Dominick Accattato (daccattato AT gmail.com)
Steven Gong (steven.gong AT gmail.com)
Paul Gregoire (mondain AT gmail.com)
Thijs Triemstra (info AT collab.nl)
Dan Rossi (electroteque AT gmail.com)
Anton Lebedevich (mabrek AT gmail.com)
Art Clarke (aclarke AT theyard.net)

- Inactive Members -
Luke Hubbard (luke AT codegent.com)
Joachim Bauch (jojo AT struktur.de)
Mick Herres (mickherres AT hotmail.com)
Grant Davies (grant AT bluetube.com)
Steven Elliott (steven.s.elliott AT gmail.com)
Jokul Tian (tianxuefeng AT gmail.com)
Michael Klishin (michael.s.klishin AT gmail.com)
Martijn van Beek (martijn.vanbeek AT gmail.com)

DOCUMENTATION

**Where is the official documentation?**
docs:Users Reference Manual

**Can I get the documentation in PDF format?**
TODO

**Where can I find the latest javadocs?**
http://red5.newviewnetworks.com/hudson/docs/
http://api.red5.nl
API Search http://www.google.com/coop/cse?cx=011206679171198660486:j6hkdxs2a_k

### CONFIGURATION ###

How to disable Socket policy checking for 443 (rtmps and https)?
You can change the port to something over 1024 like 8443 or comment out the RTMPS section.

How to change the way Red5/java listens on interfaces (change ipv6 to ipv4) ?

If you want Red5 to listen only using ipv4 instead of ipv6 then add this option in your startup-scripts:

```
 -Djava.net.preferIPv4Stack=true


e.g.

[Red5.sh]

 JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Dred5.root=$RED5_HOME -Djava.security.manager -Djava.security.policy=$RED5_HOME/conf/red5.policy $JAVA_OPTS"

```

**How can I have Red5 bind to multiple ports?**

inside red5-core.xml copy the "rtmpTransport" bean.  Rename the new bean and change the port.
```
    <!-- RTMP Mina Transport -->
    <bean id="rtmpTransport1" class="org.red5.server.net.rtmp.RTMPMinaTransport" init-method="start" destroy-method="stop">
        <property name="ioHandler" ref="rtmpMinaIoHandler" />
        <property name="address" value="${rtmp.host}" />
        <property name="port" value="${rtmp.port1}" />
        <property name="receiveBufferSize" value="${rtmp.receive_buffer_size}" />
        <property name="sendBufferSize" value="${rtmp.send_buffer_size}" />
        <property name="eventThreadsCore" value="${rtmp.event_threads_core}" />
        <property name="eventThreadsMax" value="${rtmp.event_threads_max}" />
        <property name="eventThreadsQueue" value="${rtmp.event_threads_queue}" />
        <property name="eventThreadsKeepalive" value="${rtmp.event_threads_keepalive}" />
        <!-- This is the interval at which the sessions are polled for stats. If mina monitoring is not
                enabled, polling will not occur. -->
        <property name="jmxPollInterval" value="1000" />

        <property name="tcpNoDelay" value="${rtmp.tcp_nodelay}" />
    </bean>
```

Then open up red5.properties and add the new port property under the default one.  Make sure it's a separate port.

### STREAMING ###

**How do I stream to/from custom directories?**
docs:Chapter 13. Customize Stream Paths

**How to detect the end of recording?**
see: http://red5.newviewnetworks.com/hudson/docs/org/red5/server/api/stream/IStreamAwareScopeHandler.html

**How can I record RTMP streams from Red5?**
see: http://ptrthomas.wordpress.com/2008/04/19/how-to-record-rtmp-flash-video-streams-using-red5

And a command line FLVRecorder application also built upon this code

http://jira.red5.org/confluence/display/appserver/FLV+Recorder

**Does Red5 support multicast streaming?**

It should be noted that multicasting support is not available in the Flash Player. For that reason, no media server can deliver a multi-casting solution to the Flash Player. In addition, many networks have multicasting turned off so it may not be realiable for other platforms either such as Windows Media Player. These solutions usually fall back to unicasting when clients cannot receive muliticasted media. In regards to Unicasting, Red5 already has this functionality. In addition, we have an edge-origin solution sometimes referred to as stream-reapeating.

**Can Red5 stream using UDP?**

No. Even though Java can stream using UDP, the Flash Player can not receive data sent using UDP.

**What is up with H.264?**
see here: codecs:h264 FAQ
CODECS

**What Codecs does Red5 Support?**

Video codecs:
```
ScreenVideo
On2 VP6
Sorenson H.263
h.264 (Coming Soon) see here: codecs:h264 FAQ
```

Audio codecs:
```
ADPCM
NellyMoser
MP3
Speex see here codecs:Speex Codec
AAC / MP4A (Coming soon)
```

**What is RTMFP and when will it be available in Red5?**
RTMFP stands for "RTMFP (Real Time Media Flow Protocol". You can read more about it in the release notes. Just search the following page: http://labs.adobe.com/technologies/flashplayer10/releasenotes.html

To understand what this protocol is and does, read the following FAQ: http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_rtmfp_faq_071708.pdf

Red5 does not support RTMFP. At the moment, there isn't enough exposure to RTMFP and discussion can resume once it is released and more is known about the protocol.

### DATABASE ###

**What databases are supported?**
Red5 is built with Java. So any database that has a JDBC driver will work.

**Can I use Hibernate with Red5?**
Yes an example of a simple hibernate setup on a single table and database with caching is here docs:Red5 and Hibernate

### SCRIPTING ###

**What scripting languages are available?**
Scripting support (JavaScript, Groovy, Beanshell, JRuby, Jython)

**Does Red5 support Actionscript 1?**
Not yet, but there is development in this area and proof of concepts have been presented at conferences.

**Does Red5 support Actionscript 3?**
Not yet, but there is development in this area and proof of concepts have viewed by Red5 team members.

### SHARED OBJECTS ###

**How can I make a Remote SharedObject persistant on the server?**
http://livedocs.adobe.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000607.html

**How do you setup a Remote SharedObject?**
see: http://livedocs.adobe.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000607.html

**How can I make a Remote SharedObject persistant on the server?**
see: http://livedocs.adobe.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000607.html

see: http://livedocs.adobe.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000607.html

### LEGAL STUFF ###

Licence Information
http://www.opensource.org/licenses/lgpl-license.php

For an easier explanation, please see: http://jira.red5.org/confluence/display/docs/Red5+License+%28LGPL%29

**Is Red5 Legal?**
Please read our response: http://osflash.org/red5/fud
Red5 WAR version

**Is there any documentation on the Red5 war version?**
read: docs:Chapter 12. Deploying Red5 to Tomcat

### MISC ###

**Is there an IRC channel?**
Yes: #red5 on irc.freenode.net

Flash non-IRC based chat: http://red5.newviewnetworks.com/iChatBar2/#

Are there any examples on the web?

Below is a list of applications that use Red5. Feel free to add your own!

  * http://www.snappmx.com/ - a Rapid Application Development System that supports the creation of Red5 applications.
  * http://code.google.com/p/openmeetings - by Sebastian Wagner.
  * http://www.dokeos.com - videconf module by Sebastian Wagner.
  * http://spreed.com
  * http://www.videokent.com/videochat.php
  * http://www.weekee.tv - an online video editing site by Weekee team.
  * http://blipback.com - BlipBack is a video comment widget that you can embed on any number of social network sites or blogs you have. Blipback lets you or your friends record short video comments directly to your page.
  * http://artemis.effectiveui.com - Bridge AIR applications to the Java runtime.
  * http://jooce.com - Jooce is your very own, private online desktop - with public file sharing capabilities. A highly-secure, online space to keep, view, listen to - and instantly share with friends - all your files, photos, music and video.
  * http://facebook.com/video - Video uploading/recording/messaging system that allows you to record a video on the upload page or send a private message to another user and attach a video.
  * http://www.f-ab.net - F-ab is a simple browser for Flash movies. F-ab has "FLVPhone", which is a video conferencing telephone using the Flash movie. Red5 is embedded in F-ab to communicate with the remote FLVPhone.
  * http://www.streamingvideosoftware.info - Streaming video chat software script is a RED5 based system that allows you to build a comprehensive pay per minute / pay per view video chat site.
  * http://pixelquote.com - Huge Pixelwall where visitors can simply add Pixels with their Messages - by Simon Kusterer.
  * http://nonoba.com/chris/fridge-magnets - Classical fridge magnet toy.
  * http://www.quarterlife.com - Video blogging
  * http://www.avchat.net - Red5 Flash Audio/Video Chat Software
  * http://www.avchat.net/fms-bandwidth-checker.php - Red5 bandwidth checker with upload/download and latency tests
  * http://www.justepourrire-nantes.fr - Red5 Flash Video streaming
  * http://www.nielsenaa.com/TV/tv.php - Red5 Flash Php/MySql/Ajax driven scheduled & streamed multi channel TV - VOD
  * http://www.videoflashchat.com - VideoFlashChat - Red5 version for Web Based Video Chat
  * http://www.videogirls.biz - VideoGirls BiZ - Red5 version for Pay Per View Video Chat Software
  * http://www.ligachannel.com - Ligachannel.com - Italian singer site. Red5 used for VOD Protected Streaming and audio/video recording widgets
  * http://www.sticko.com/ - Video portal with widgets for popular social networking sites
  * http://www.zingaya.jp/ - VOIP server built on Red5 for Flashphone
  * http://www.gchats.com/red5chat/visichat/ - Visichat, flash video and audio chat with red5
  * http://www.agileagenda.com/ - The AgileAgenda web service was written with Red5
  * http://www.videoondemandsoftware.com - RED5 based Video on demand HD-TV quality pay per view/minutes software
  * http://www.videochatsoftware.org - Flash red5 video chat software
  * http://www.hubbabubba.com/ - HubbaBubba world
  * http://www.deltastrike.org/ - DeltaStrike - free online realtime multiplayer strategy game

**Is there any professional support?**
Companies Listed:

  * Infrared5 ([www.infrared5.com])

  * Red5Server ([www.red5server.com])

**Are there hosting solutions?**

  * Red5Server ([www.red5server.com])

**Are there forums?**
see: http://red5server.com/forum/

**What is Jedai?**
see: [jedai.googlecode.com]

**Are there any frameworks that I can start with?**
see: [jedai.googlecode.com]
see: [paperworld3d.googlecode.com]

**Are there development tools?**
see: http://www.red5.org/projects/red5plugin/#

**What is Paperworld3D?**
see: [www.paperworld3d.org]

**What Red5 groups can I join?**
Linked in Red5 group: http://www.linkedin.com/e/gis/64004/24689F7691AB

**Do we support third party chat programs?**
No. The Red5 team does not support the following 3rd party chat programs!

  * red5chat
  * flashpioneer chat
  * etc...

### TROUBLESHOOTING ###

**Why am I receiving "closing due to long handshake?**
issue: Closing RTMPMinaConnection from [IP\_ADDRESS](IP_ADDRESS.md) : 2610 to [IP\_ADDRESS](IP_ADDRESS.md) (in: 3415 out 3212 ), with id 512231886 due to long handshake

solution: Have you installed the example your trying to connect to? The examples are installed on demand starting with Red5 0.8. Just check the welcome page http://localhost:5080/ and look for a link that allows you to install them. After an example is installed, you should be able to run the examples.

solution: You are probably connecting from your client to a non-existing application. Make sure the application is running and that you are using the right name. If your application is called "myapp" then connect to "rtmp://yourserver.com/myapp"

notes: We are improving this so that if an example is chosen, it will be installed.

Impossible to resolve dependencies of red5#server;working@
from the command line issue this command:
ant -Divy.conf.name="java6, eclipse" dist

The problem is that the IvyDE plugin has not caught up to the released version of Ivy of which there is a snapshot in the lib directory, that the ant script uses.
http://gregoire.org/tag/ivy/

Comments  (Hide)

Dominick, I can't seem to edit the FAQ directly, but for the "closing due to long handshake" problem check the following:

  1. Does your application exist in $RED5\_HOME/webapps/YOUR-APP-NAME
    1. If not, put it there.
> 2. Do you have any libraries in $RED5\_HOME/webapps/YOUR-APP-NAME/WEB-INF/lib that are also in $RED5\_HOME/lib?
    1. If so, delete the duplicate libraries in $RED5\_HOME/webapps/YOUR-APP-NAME/WEB-INF/lib
> 3. Do you see any error messages on the console with YOUR-APP\_NAME in it when running $RED5\_HOME/red5.sh?
    1. If so, track them down.  Common errors are mis-named class-names in your red5-web.xml file
> 4. Do you have logging messages in your appStart() handler on your Red5 application?
    1. If not, add some.
> > 2. If you don't trust the log4j stuff that's currently in Red5, System.out.println() works for debugging too, don't be shy.