Note:**This page is now depreciated.  Please see the instructions at [InstallingBigBlueButton](http://code.google.com/p/bigbluebutton/wiki/InstallingBigBlueButton)**


These instructions will walk through installing on Ubuntu from source.  You can start with either a physical machine running Ubuntu or a VM with Ubuntu installed -- both are fine.

If you want to try it out using a VM image:
  * Download a Ubuntu VM image from http://www.vmware.com/appliances/directory/va/147323/download
  * Boot it up in your VMWare Player

The only prerequisite is that your Ubuntu machine has a network connection.

  * To start, check if you have a network connection
```
 > ping www.google.com

If you get an error saying yout eth0 is not connected, then fix it by:

  Check if it is using eth1 

root@ubuntu904server:/usr/local# ifconfig -a
eth1      Link encap:Ethernet  HWaddr 00:0c:29:dd:b4:51
          inet addr:192.168.0.154  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fedd:b451/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4080349 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3932137 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1216680270 (1.2 GB)  TX bytes:822963271 (822.9 MB)
          Interrupt:19 Base address:0x2000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:12938 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12938 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:40299608 (40.2 MB)  TX bytes:40299608 (40.2 MB)

root@ubuntu904server:/usr/local# vi /etc/udev/rules.d/70-persistent-net.rules
Swap the two entries by eidting "NAME=eth1" to "NAME=eth0" and vice versa.

Reboot your machine. Check if you manage to connect to the internet. If you are running on a Virtual Machine, make sure the VM's network adapter is using a Bridged connection instead of NAT. On the VMWare player this is enabled in the Devices menu at the top.

More info can be found here http://ubuntuforums.org/showthread.php?t=221768

```

  * Once you have interner connection, update and upgrade.
```
  > sudo apt-get update
  > sudo apt-get upgrade
```

  * Install Java 6
```
 > apt-get install openjdk-6-jre-headless

```

  * Install MySQL
```
 > apt-get install mysql-server
```

  * Install Tomcat
```
  > apt-cache search tomcat

  > apt-get install tomcat6
```

  * Confirm that tomcat is running
```
  http://<YOUR IP>:8080/
```

  * Install swftools
```
  > apt-get install swftools

```

  * Install ImageMagick
```
  > apt-get install imagemagick

```

  * Install Nginx
```
  > apt-get install nginx
```

  * Install ActiveMQ
```
  > cd opt
  > wget http://apache.mirror.rafal.ca/activemq/apache-activemq/5.2.0/apache-activemq-5.2.0-bin.tar.gz
  > tar zxvf apache-activemq-5.2.0-bin.tar.gz

  Start ActiveMQ
  > /opt/apache-activemq-5.2.0/bin/activemq
```

  * Modify tomcat6 account
```
 > vi /etc/passwd

 Modify tomcat6 entry to this
  tomcat6:x:106:113::/usr/share/tomcat6:/bin/bash

```


  * Install red5
```
  > cd opt
  > wget http://build.xuggle.com/job/red5_jdk6_stable/131/artifact/workingcopy/red5-0.8.RC3-build-hudson-red5_jdk6_stable-131.tar.gz
  > tar zxvf red5-0.8.RC3-build-hudson-red5_jdk6_stable-131.tar.gz
  > mv red5-0.8.RC3-build-hudson-red5_jdk6_stable-131 red5-0.8
  
  Start red5 as tomcat6 user
  > sudo su -l tomcat6
  > red5.sh
```

  * Install oflaDemo
```
http://192.168.0.154:5080/

Click on "Click here to install demos" and then choose oflaDemo java 6.

http://192.168.0.154:5080/demos/

http://192.168.0.154:5080/demos/ofla_demo.html

Edit rtmp://192.168.0.154/oflaDemo and click connect

You would see a list of available videos. Select one to play.

```

  * Prepare to install Asterisk
```
Some info found here http://godson.in/how-to-install-asterisk-on-ubuntu

 > apt-get install build-essential
 > apt-get install linux-headers-`uname -r`
 > apt-get install libssl-dev
 > apt-get install ncurses-dev
 > apt-get install libnewt-dev
 > apt-get install zlib1g-dev
 > apt-get install bison
```

  * Install Dahdi
You may have to find out what the newest version is. Go [here](http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/)
```
 > cd /usr/local/src
 > wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.2.0.2+2.2.0.tar.gz
 > tar zxvf dahdi-linux-complete-2.2.0.1+2.2.0.tar.gz
 > cd dahdi-linux-complete-2.2.0.1+2.2.0
 > make all
 > make install
 > make config
```

  * Install Asterisk
```
  > cd /usr/local/src 
  > wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-1.4.25.tar.gz
  > tar zxvf asterisk-1.4.25.tar.gz
  > cd asterisk-1.4.25
  > more README
  > ./configure
  > make 
  > make install
  > make samples
  > make config
```


  * Modify Extensions
```
  > vi /etc/asterisk/extensions.conf

  Add the following at the bottom of the file

;
; BigBlueButton: Setup sample conference
[bigbluebutton]
exten => s,1,Goto(start-dialplan,s,1)
exten => s,n,Hangup

[start-dialplan]
exten => s,1,Set(TRIES=1)
exten => s,n,Wait(2)
exten => s,n,Answer
exten => s,n,Goto(prompt,s,1)

[prompt]
exten => s,1,Read(CONF_NUM,conf-getconfno,6,,3,10)
exten => s,n,Goto(bbb-conference,s,1)

[bbb-voip]
exten => _XXXX.,1,MeetMe(${EXTEN},cdMsT)

[bbb-conference]
exten => _XXXX.,1,Agi(agi://localhost/findConference?conference=${EXTEN})
exten => _XXXX.,n,GotoIf($[${EXTEN} = ${CONFERENCE_FOUND}]?valid:invalid)
exten => _XXXX.,n(valid),Playback(conf-placeintoconf)
exten => _XXXX.,n,MeetMe(${CONFERENCE_FOUND},cdMsT)
exten => _XXXX.,n(invalid),Goto(handle-invalid-conference,s,1)

[handle-invalid-conference]
exten => s,1,Playback(conf-invalid)
exten => s,n,GotoIf($[${TRIES} < 3]?try-again:do-not-try-again)
exten => s,n(try-again),Set(TRIES=$[${TRIES} + 1])
exten => s,n,Goto(prompt,s,1)
exten => s,n(do-not-try-again),Hangup

[echo-test]
;
; Create an extension, 600, for evaluating echo latency.
;
exten => 600,1,Answer                   ; Do the echo test
exten => 600,n,Playback(demo-echotest)  ; Let them know what's going on
exten => 600,n,Echo                     ; Do the echo test
exten => 600,n,Playback(demo-echodone)  ; Let them know it's over
exten => 600,n,Goto(s,6)                ; Start over

```

  * Create SIP account
```
  > vi /etc/asterisk/sip.conf

  Add the following at the bottom of the file

;
; BigBlueButton: Echo test sample user
[echotest]
type=friend
username=echotest
insecure=very
secret=secret
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=echo-test
allow=all

;
; BigBlueButton: Setup sample user to connect over VoIP
[user1]
type=friend
username=user1
insecure=very
secret=secret
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=bigbluebutton
allow=all

[user2]
type=friend
username=user2
insecure=very
secret=secret
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=bigbluebutton
allow=all

[user3]
type=friend
username=user3
insecure=very
secret=secret
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=bigbluebutton
allow=all

[user4]
type=friend
username=user4
insecure=very
secret=secret
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=bigbluebutton
allow=all

```

  * Create SIP Accounts to be used by Red5Phone
```
 Create a script with the following contents

#!/bin/bash

for i in {3000..3029}
do
   echo "
[$i]
type=friend
username=$i
insecure=very
qualify=yes
nat=yes
host=dynamic
canreinvite=no
context=bbb-voip
disallow=all
allow=ulaw

   " >>  /etc/asterisk/sip.conf 
done

```




  * Test your SIP account
```
 Download Zoiper from here http://www.zoiper.com/zwin.php

 After installing Zoiper, start it and create a SIP account using the echotest user above.

 Then dial 600. You should be connected to the "Echo" application.

```

  * Create AMI account
```
 > vi /etc/asterisk/manager.conf

 Modify "enabled" to yes

[general]

enabled = yes

  Add the following at the bottom of the file

; BigBlueButton: Enable Red5 to connect
[bbb]
secret = secret
permit = 0.0.0.0/0.0.0.0
read = system,call,log,verbose,command,agent,user
write = system,call,log,verbose,command,agent,user

```

  * Configure Nginx
```
 > vi /etc/nginx/sites-available/bigbluebutton

 Paste the following into the file and edit server_name with you IP.

server {
     listen   80;
     server_name  192.168.0.136;

     access_log  /var/log/nginx/bigbluebutton.access.log;

      location ~ (/open/|/close/|/idle/|/send/) {
          proxy_pass         http://127.0.0.1:8088;
          proxy_redirect     off;
          proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;

          client_max_body_size       10m;
          client_body_buffer_size    128k;

          proxy_connect_timeout      90;
          proxy_send_timeout         90;
          proxy_read_timeout         90;

          proxy_buffering            off;
      }


       location /deskshare {
           proxy_pass         http://127.0.0.1:5080;
           proxy_redirect     default;
           proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
           client_max_body_size       10m;
           client_body_buffer_size    128k;
           proxy_connect_timeout      90;
           proxy_send_timeout         90;
           proxy_read_timeout         90;
           proxy_buffer_size          4k;
           proxy_buffers              4 32k;
           proxy_busy_buffers_size    64k;
           proxy_temp_file_write_size 64k;
           include    fastcgi_params;
       }


       location /bigbluebutton {
           proxy_pass         http://127.0.0.1:8080;
           proxy_redirect     default;
           proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;

           client_max_body_size       10m;
           client_body_buffer_size    128k;

           proxy_connect_timeout      90;
           proxy_send_timeout         90;
           proxy_read_timeout         90;

           proxy_buffer_size          4k;
           proxy_buffers              4 32k;
           proxy_busy_buffers_size    64k;
           proxy_temp_file_write_size 64k;

           include    fastcgi_params;
       }

        location / {
          root   /var/www/bigbluebutton-default;
          index  index.html index.htm;
        }

        location /client {
                root    /var/www/bigbluebutton;
                index  index.html index.htm;
        }

        #error_page  404  /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
                root   /var/www/nginx-default;
        }
}

```

  * Enable the bigbluebutton nginx config
```
> ln -s /etc/nginx/sites-available/bigbluebutton /etc/nginx/sites-enabled/bigbluebutton

```

  * Download BigBlueButton
```
 > mkdir /home/user/temp
 > cd /home/user/temp
 > wget http://www.bigbluebutton.org/hudson/job/BBB-Trunk-Apps/ws/dist/bigbluebutton-apps-0.5.tar.gz
 > wget http://www.bigbluebutton.org/hudson/job/BBB-Trunk-Apps-Deskshare/ws/dist/webapps/deskshare.tar.gz
 > wget http://www.bigbluebutton.org/hudson/job/BBB-Trunk-Client/ws/client.tar.gz
 > wget http://www.bigbluebutton.org/hudson/job/BBB-Trunk-Web/ws/bigbluebutton-0.1.war
 > wget http://www.bigbluebutton.org/hudson/job/BBB-Trunk-Config/ws/web//*zip*/web.zip
 > wget http://www.bigbluebutton.org/hudson/job/bbb-trunk-apps-sip/ws/dist/webapps/sip.tar.gz
 > wget http://www.bigbluebutton.org/hudson/job/bbb-trunk-apps-video/ws/dist/webapps/video.tar.gz
```

  * Disable Security settings for TOMCAT6
```
  > vi /etc/default/tomcat6

  Edit and uncomment #TOMCAT6_SECURITY=yes to

  TOMCAT6_SECURITY=no
```

  * setup the database
```
 > mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 33
Server version: 5.0.75-0ubuntu10.2 (Ubuntu)

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

mysql> create database bigbluebutton_dev;
Query OK, 1 row affected (0.05 sec)

mysql> grant all on bigbluebutton_dev.* to 'bbb'@'localhost' identified by 'secret';
Query OK, 0 rows affected (0.04 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)

mysql>
```

  * Install BigBlueButton Web
```
 > cd /var/lib/tomcat6/webapps
 > cp /home/user/temp/bigbluebutton-0.1.war ./bigbluebutton.war
```

  * Determine PDF2SWF, CONVERT and GS applications
```
  Make a note of where pdf2swf is installed
  > which pdf2swf
  
  You should see something like
  /usr/bin/pdf2swf
  
  Make a note of where the convert application is installed
  > which convert

  You shoud see something like.
  /usr/bin/convert

  Note where GhostScript is installed
  > which gs

  You shoud see something like.
  /usr/bin/gs
```

  * Edit bbb-web properties
```
 > vi /var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties

Change the following:
 - swfToolsDir to the directory where pdf2swf is located
 - imageMagickDir to the directory where convert is located
 - ghostScriptExec to point to the gs application
 - change bigbluebutton.web.serverURL=http://<YOUR IP>

Your bigbluebutton.properties should resemble something like this

#
# These are the default properites for BigBlueButton Web application

dataSource.url=jdbc:mysql://localhost/bigbluebutton_dev
dataSource.username=bbb
dataSource.password=secret

swfToolsDir=/usr/bin
imageMagickDir=/usr/bin
presentationDir=/var/bigbluebutton
ghostScriptExec=/usr/bin/gs

beans.presentationService.swfToolsDir=${swfToolsDir}
beans.presentationService.imageMagickDir=${imageMagickDir}
beans.presentationService.presentationDir=${presentationDir}

# Use fullpath to ghostscript executable since the exec names are different
# for each platform.
beans.presentationService.ghostScriptExec=${ghostScriptExec}

#
# This URL needs to reference the host running the tomcat server
bigbluebutton.web.serverURL=http://192.168.0.154

# This is a workaround for a problem converting PDF files, referenced at
# http://groups.google.com/group/comp.lang.postscript/browse_thread/thread/c2e264ca76534ce0?pli=1
noPdfMarkWorkaround=/etc/bigbluebutton/nopdfmark.ps
beans.presentationService.noPdfMarkWorkaround=${noPdfMarkWorkaround}
```

  * Restart Tomcat6
```
 > /etc/init.d/tomcat6 restart
```

  * Check if database tables were created
```
 > mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 56
Server version: 5.0.75-0ubuntu10.2 (Ubuntu)

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

mysql> use bigbluebutton_dev;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-----------------------------+
| Tables_in_bigbluebutton_dev |
+-----------------------------+
| account                     |
| account_conference          |
| account_user                |
| conference                  |
| permission                  |
| role                        |
| role_permission_rel         |
| scheduled_session           |
| user                        |
| user_permission_rel         |
| user_role_rel               |
| voice_conference_bridge     |
+-----------------------------+
12 rows in set (0.00 sec)

mysql> select * from user;
+----+---------+---------------------+-----------+---------------------+------------------------------------------+----------------+
| id | version | date_created        | full_name | last_updated        | password_hash                            | username       |
+----+---------+---------------------+-----------+---------------------+------------------------------------------+----------------+
|  1 |       0 | 2009-06-29 09:51:17 | Admin     | 2009-06-29 09:51:17 | d033e22ae348aeb5660fc2140aec35850c4da997 | admin@test.com |
+----+---------+---------------------+-----------+---------------------+------------------------------------------+----------------+
1 row in set (0.02 sec)

mysql>
```

  * Create the Presentation Upload directory
```
 > mkdir /var/bigbluebutton
 > chown -R tomcat6:adm /var/bigbluebutton
 > chmod -R 777 /var/bigbluebutton
```

  * Install bbb-apps
```
 > cd /opt/red5-0.8/webapps
 > cp /home/user/temp/bigbluebutton-apps-0.5.tar.gz ./
 
 > tar zxvf bigbluebutton-apps-0.5.tar.gz
 >  mv webapps/bigbluebutton ./
 > rm -rf bigbluebutton-apps-0.5.tar.gz webapps/
```

  * Edit BigBlueButton Apps properties
```
 > vi /opt/red5-0.8/webapps/bigbluebutton/WEB-INF/bigbluebutton.properties

# Location for recordings
recordingsDirectory=/var/bigbluebutton


# These properties are for Asterisk Management Interface (AMI)
ami.host=127.0.0.1
ami.port=5038
ami.username=bbb
ami.password=secret
```

  * Uncommet RTMPT section of /opt/red5-0.8/conf/red5-core.xml

  * Install Xuggler
```
 Goto http://www.xuggle.com/xuggler/downloads/

  > cd /usr/local
  >  wget http://com.xuggle.s3.amazonaws.com/xuggler/xuggler-3.1.FINAL/xuggle-xuggler.3.1.818-i686-pc-linux-gnu.sh
  
  > chmod a+x xuggle-xuggler.3.1.818-i686-pc-linux-gnu.sh
  > ./xuggle-xuggler.3.1.818-i686-pc-linux-gnu.sh
```

  * Put Xuggler into PATH
```
  >  vi /etc/profile

 Add the following at the bottom of the file

export XUGGLE_HOME=/usr/local/xuggler
export LD_LIBRARY_PATH=$XUGGLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=$XUGGLE_HOME/bin:$PATH

```

  * Install Desk Share App
```
 > cd /opt/red5-0.8/webapps
 > cp /home/user/temp/deskshare.tar.gz ./
 > tar zxvf deskshare.tar.gz
 >  rm deskshare.tar.gz
```

  * Install Video App
```
 > cd /opt/red5-0.8/webapps
 > cp /home/user/temp/video.tar.gz ./
 > tar zxvf video.tar.gz
 >  rm video.tar.gz
```

  * Install Voice App
```
 > cd /opt/red5-0.8/webapps
 > cp /home/user/temp/sip.tar.gz ./
 > tar zxvf sip.tar.gz
 >  rm sip.tar.gz

 Edit /opt/red5-0.8/webapps/sip/WEB-INF/bigbluebutton-sip.properties
 
 Point sip.server.host to the IP of your Asterisk installation

 sip.server.host=192.168.0.177

```

  * Install BigBlueButton Client
```
  > cd /var/www
  > mkdir bigbluebutton
  > cd bigbluebutton 
  > cp /home/user/temp/client.tar.gz ./
  > tar zxvf client.tar.gz
  > rm client.tar.gz
```

  * Modify BBB client config in /var/www/bigbluebutton/client/conf/config.xml
```

 - Change the uri to your IP address
 - Change host="conf/join-mock.xml" to host="http://<YOUR IP:PORT>/bigbluebutton/conference-session/enter"



<?xml version="1.0" ?>
<config>
    <version>0.4</version>
    <porttest host="192.168.0.136" application="video"/>    
	<modules>

		<module name="VideoModule" url="VideoModule.swf" 
			uri="rtmp://192.168.0.136/video"
			onUserJoinedEvent="START"
			onUserLogoutEvent="STOP"	
		/>
		<module name="ChatModule" url="ChatModule.swf" 
			uri="rtmp://192.168.0.136/bigbluebutton" 
			loadNextModule="PresentationModule"	
			onUserJoinedEvent="START"
			onUserLogoutEvent="STOP"		 
		/>
		<module name="ViewersModule" url="ViewersModule.swf" 
			uri="rtmp://192.168.0.136/bigbluebutton" 
			host="conf/join-mock.xml"
			onAppInitEvent="LOAD" loadNextModule="ChatModule"
			onAppStartEvent="START"
			onUserLogoutEvent="STOP"
		/>	
		<module name="ListenersModule" url="ListenersModule.swf" 
			uri="rtmp://192.168.0.136/bigbluebutton" 
			recordingHost="http://192.168.0.136"
			loadNextModule="DeskShareModule"
			onUserJoinedEvent="START"
			onUserLogoutEvent="STOP"
		/>
		<module name="PresentationModule" url="PresentationModule.swf" 
			uri="rtmp://192.168.0.136/bigbluebutton" 
			host="http://192.168.0.136" 
			loadNextModule="ListenersModule"
			onUserJoinedEvent="START" 
			onUserLogoutEvent="STOP"
		/>
		
		<module name="DeskShareModule" url="DeskShareModule.swf" 
			uri="rtmp://192.168.0.136/deskShare" 
			onUserJoinedEvent="START" 
			onUserLogoutEvent="STOP"
			loadNextModule="PhoneModule"
		/>
		
		<module name="PhoneModule" url="PhoneModule.swf" 
			uri="rtmp://192.168.0.136/sip" 
			onUserJoinedEvent="START" 
			onUserLogoutEvent="STOP"
			loadNextModule="VideoModule"
		/>
	</modules>
</config>
```

  * Install bbb-default pages
```
  > cd /var/www/
  > cp /home/user/temp/web.zip ./
  > apt-get install unzip
  > unzip -dc web.zip
  > mv c/web ./bigbluebutton-default
  > rm -rf c
```

  * Restart server apps
```
 * Start ActiveMQ
 * Start Red5 as tomcat6 user
 * Restart Tomcat
 * Restart Asterisk 
```

  * Try out BigBlueButton
```
 Go to http://<YOUR-IP> which should display the bbb web page.
 
 To use voice conference, using your zoiper, dial 1500 which will prompt you for the conference number.

```

## When things go wrong ##
> Look for logs in the following
```
 /var/log/syslog
 /var/log/tomcat6
 /opt/red5-0.8/logs
 /var/log/asterisk

```

## If you make it successfully through the installation ##
Good stuff!  Post a message to BigBlueButton-dev letting everyone know that you are a real developer and you have installed BigBlueButton from source.  :-)