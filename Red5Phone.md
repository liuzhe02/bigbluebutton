_**Note:** This content is now out of date.  We've merged the Red5 phone into the BigBlueButton trunk.  For more information, see the source at [Red5Phone](http://code.google.com/p/bigbluebutton/source/browse/#svn/vendors/red5phone) in the SVN repository._

# Introduction #

This page provides steps to run [Red5Phone](http://code.google.com/p/red5phone/), the workarounds, as well as observations/findings.

# Install Red5 #
  1. Download Red5 from http://osflash.org/red5/070final, in this instruction we use the Java 6 windows release
  1. Extract the downloaded file (e.g. c:\red5-0.7.0 -- let's call this RED5\_HOME)
  1. Download the hotfix (http://osflash.org/red5/070hotfix) and put the jetty jars into `RED5_HOME/lib`. Otherwise, you'll see this
```
      Exception in thread "main" java.lang.ClassNotFoundException: org.mortbay.jetty.Server
```
> > You can get the jetty libs from http://red5.googlecode.com/svn/repository/jetty/ Remove the old jetty jar versions. Ignore the update jar files from hotfix link as we are only interested in the jetty jars.  If you have SVN installed you can do this by:
> > "svn co http://red5.googlecode.com/svn/repository/jetty/"
  1. Download the red5.jar from the red5phone site (http://red5.4ng.net/red5.jar). Put it in `RED5_HOME` and name it red5-sip-0.7.jar so as not to overwrite the original red5.jar
  1. Download the sip app (http://red5.4ng.net/sip.zip) and extract it into `RED5_HOME/webapps`
  1. Check if there is a `RED5_HOME/wrapper` folder. If not, create it. Delete everything inside the wrapper folder.
  1. Copy `RED5_HOME/red5.bat` to `RED5_HOME/wrapper`.  1. Edit the `RED5_HOME/wrapper/red5.bat` and change
```
    "%JAVA_HOME%/bin/java" -Djava.security.manager -Djava.security.policy=conf/red5.policy -cp red5.jar;conf;bin org.red5.server.Standalone
```
> > to
```
    "%JAVA_HOME%/bin/java" -Djava.security.manager -Djava.security.policy=../conf/red5.policy -cp ../red5-sip-0.7.jar;../conf;../bin org.red5.server.Standalone
```


> The reason for this is that SIPUser.java assumes red5 was started under a "wrapper" directory.
```
       SIPUser.java

	public SIPUser(String sessionID, IConnection service, int sipPort, int rtpPort) throws IOException {
		p("SIPUser Constructor: sip port " + sipPort + " rtp port:" + rtpPort);

		try {

			String appPath = System.getProperty("user.dir");
			appPath = appPath.substring(0, (appPath.length() - 8));   // removing /wrapper sub folder from path

			configFile = appPath + "/webapps/sip/sip.cfg";

			this.sessionID = sessionID;
			this.service = service;
			this.sipPort = sipPort;
			this.rtpPort = rtpPort;

			sipInputStream = new PipedInputStream();
			rtmpOutputStream = new PipedOutputStream(sipInputStream);

		}  catch (Exception e) {
			p("SIPUser constructor: Exception:>\n" + e);

		}
	}
```

  1. Edit webapps/sip/WEB-INF/classes/logback.xml with this change
```
     <File>log/sip.log</File>
```
  1. Create `RED5_HOME/wrapper/log` folder.
  1. Run wrapper/red5.bat
  1. Connect to http://localhost:5080/sip and click on the Flex Phone Template link
  1. Enter relevant information and click Login. Make sure that your SIP user (in Asterisk) does not have a "secret" (password) entry. Otherwise, registration will fail (http://code.google.com/p/red5phone/issues/detail?id=4). If it does not work, take a look at logs/sip.log for clues. You can also use WireShark (http://www.wireshark.org/) to capture packets and determine why your client won't register.


