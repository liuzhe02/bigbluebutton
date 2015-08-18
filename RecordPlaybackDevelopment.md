**WARNING: the page is out-of-date, please check bigbluebutton mailing list for recording and playback development**
# Setup Recording Application #

The Recording Application is deployed in the tomcat server as a web application.

Checkout the latest code in the recording-and-playback-feature branch
```
git checkout record-and-playback-feature
git pull origin record-and-playback-feature
```

Compile BBB Commons

```
cd ~/dev/source/git/bigbluebutton/bbb-common-message
gradle jar 
gradle uploadArchives
```

Setup the development for bigbluebutton-apps, and change the following line in:
bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/BigBlueButtonApplication.java

```
boolean record = (Boolean)params[6];
```
to:
```
boolean record = true;//(Boolean)params[6];
```

Compile and deploy bigbluebutton-apps, just in case stop red5 server before:

```
cd ~/dev/source/git/bigbluebutton/bigbluebutton-apps
gradle resolveDeps
gradle war
gradle deploy
```

Compile and deploy events-recorder app, just in case stop tomcat server before:

```
cd ~/dev/source/git/bigbluebutton/record-and-playback/events-recorder

# check that the info is correct in src/main/webapp/WEB-INF/application.properties
gradle copyToLib
gradle war
gradle deploy
```

Start tomcat and red5, test with the demo conference and check the database

# Setup Playback Web Application #

the application get the events stored in the database and it presents in xml format. The following details are required for setup:

Pull the latest code in the recording-and-playback-feature branch
```
git pull origin record-and-playback-feature
```

Stop tomcat server
```
/etc/init.d/tomcat6 stop
```

Compile and deploy the playback-web app of record-and-playback
```
cd ~/dev/source/bigbluebutton/record-and-playback/playback-web

# this will generate a playback-web-01.war
grails war

# rename and move to the tomcat webapp directory the war file
mv playback-web-01.war playback-web.war
cp playback-web.war /var/lib/tomcat6/webapps
```

Start the tomcat server
```
/etc/init.d/tomcat6 start
```

For listing all the conferences stored:
```
http://<your-ip>:8080/playback-web/event/conferences.xml
```

For get a recorded session:
```
http://<your-ip>:8080/playback-web/event/xml?confid=<conferenceid>
```

# Future Plans #

  1. maybe recording application will be integrated to bigbluebutton-apps