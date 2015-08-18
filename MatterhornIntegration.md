_This page is depreciated.  Please see [Matterhorn](Matterhorn.md) for the latest documentation on Matterhorn integration._



# Prerequisites #

You need to have to have installed [BigBlueButton 0.8](08InstallationUbuntu.md).  On a separate server (not the same server as BigBlueButton) install [Matterhorn 1.1](http://opencast.jira.com/wiki/display/MHDOC/Install+Source+Linux+All+in+One++V1.1) , [Matterhorn 1.2](http://opencast.jira.com/wiki/display/MHDOC/Install+Source+Linux+V1.2) or [Matterhorn 1.3 (recommended)](http://opencast.jira.com/wiki/display/MHDOC/Install+Source+Linux+v1.3).

**Note:**
If you follow Matterhorn 1.2 installation steps, it will be a good idea to change the current checkout url (http://opencast.jira.com/svn/MH/tags/1.2.0/) by this tag http://opencast.jira.com/svn/MH/tags/1.2.1-rc1/. Matterhorn 1.2.1 has not been officially released but this tag fixes some problems with 3rd party source packages.

# Overview #
[Matterhorn](http://opencast.org/matterhorn/) is an open source lecture capture and video management system for education.  When integrated with Matterhorn (see instructions below), BigBlueButton can record video, desktop, and audio and send the files to Matterhorn for processing and playback.

From a technical point of view, in the BigBlueButton API, when you pass the parameter 'record=true' with [create](API#Create_Meeting.md), BigBlueButton will create a session and record the slides, chat, audio, desktop, and webcam for later processing.

After the session finishes, the BigBlueButton server will run one (or more) ingest and processing scripts that will process the captured data into a format for playback.

The instructions below show you how to install and configure the Matterhorn ingest and processing scripts.  When called by BigBlueButton, these scripts will create two video files: one with webcam + audio, the other for desktop sharing, along with an XML file (called dublin core) and bundle everything into a single zip file.  It will then scp the zip file to your Matterhorn server for processing.

The Matterhorn ingest and processing will scale the resolution of the desktop video to 640x480 before sending to Matterhorn.

If you encounter any problems with these instructions, please post to [bigbluebutton setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2) mailing list.


## Before you install ##
You'll need to ensure your `/etc/apt/sources.list` has the multiverse enabled.  If you get an error message such as `libfaac-dev can't be found` with the instructions below, see [Dependencies not met](http://code.google.com/p/bigbluebutton/wiki/08InstallationUbuntu#Dependencies_are_not_met).

## Ensure BigBlueButton records video and desktop session ##
BigBlueButton uses two red5 applications -- bbb-video and bbb-deskshare -- to share video and desktop.  In BigBlueButton 0.8-beta-4, these applications are configured to not record media by default (to reduce disk space usage).

To record video, edit `/usr/share/red5/webapps/video/WEB-INF/red5-web.xml` and set `recordVideoStream` to `true`.

```
         <bean id="web.handler" class="org.bigbluebutton.app.video.VideoApplication">
                <property name="recordVideoStream" value="true"/>
                <property name="eventRecordingService" ref="redisRecorder"/>
        </bean>
```

To record desktop sharing, edit `/usr/share/red5/webapps/deskshare/WEB-INF/red5-web.xml` and at line 41 set the value for `constructor-arg` to true.

```
  <bean id="streamManager" class="org.bigbluebutton.deskshare.server.stream.StreamManager">
    <constructor-arg index="0" value="true"/>
    <constructor-arg index="1" ref="recordingService"/>
  </bean>
```

After you make the changes, you need to restart BigBlueButton.

```
   sudo bbb-conf --restart
```

## Install ffmpeg ##

To install ffmpeg, login to your BigBlueButton server with root access.  Copy the following script and and save as a file  `install_ffmpeg.sh` on your server

```
# Install dependencies
sudo apt-get install build-essential git-core checkinstall yasm texi2html libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev zlib1g-dev --yes


# Setup libvpx
if [ ! -d /usr/local/src/libvpx ]; then
  cd /usr/local/src
  sudo git clone http://git.chromium.org/webm/libvpx.git
  cd libvpx
  sudo ./configure
  sudo make
  sudo make install
fi

# Install ffmpeg
cd /usr/local/src
sudo wget http://ffmpeg.org/releases/ffmpeg-0.11.2.tar.gz
sudo tar -xvzf ffmpeg-0.11.2.tar.gz
cd ffmpeg-0.11.2
sudo ./configure  --enable-version3 --enable-postproc  --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis  --enable-libvpx
sudo make
sudo checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no --deldoc=yes --default

```


Run the script using the following commands

```
chmod +x install_ffmpeg.sh
./install_ffmpeg.sh
```

This script will take about thirty minutes to run, depending on your internet connection.

## Install Ingest and Processing package for Matterhorn ##

```
   sudo apt-get install bbb-playback-matterhorn
```

## Configure the Matterhorn server to accept incoming files ##

The ingest and processing scripts will use a public/private key to move files to the Matterhorn server.


### Generate a ssh public key ###

This key will let BigBlueButton server send files to Matterhorn server without prompting a password.  The example below uses the 'root' user on your Matterhorn server.   If you have the matterhorn server running under a different account, such as matterhorn\_user, use that account in the instructions below instead of the root account.

```
   ssh-keygen -t rsa
```

When it asks for a passphrase, just press enter (we don’t want to be prompted for a password). The public key will be generated in `/home/firstuser/.ssh/id_rsa.pub`.


Next, we'll copy the private key to the BigBlueButton scripts directory change it’s permissions to 600 (otherwise, the publish script will fail to push the recording to the Matterhorn server).

```
sudo cp ~/.ssh/id_rsa /usr/local/bigbluebutton/core/scripts/matt_id_rsa
sudo chmod 600 /usr/local/bigbluebutton/core/scripts/matt_id_rsa
sudo chown tomcat6:tomcat6 /usr/local/bigbluebutton/core/scripts/matt_id_rsa
```

Set configuration parameters about BigBlueButton-Matterhorn connection in `/usr/local/bigbluebutton/core/scripts/matterhorn.yml`

These parameters will be read during publish phase.


```
# The ip address of the matterhorn server.
server: 192.168.0.147
# The username we use to SCP the processed recording to matterhorn.
user: root
# The private key to use to SCP into matterhorn
key: /usr/local/bigbluebutton/core/scripts/matt_id_rsa
# The directory in the matterhorn server where the
# processed recording will be delivered for publishing to matterhorn.
# NOTE: Make sure that the directory is writeable by the above user.
inbox: /opt/matterhorn/felix/inbox/
```

In Matterhorn server

Create a directory for ssh  keys
```
sudo mkdir /root/.ssh
```
Create a file for authorized keys (only if it does not exist)
```
sudo nano /root/.ssh/authorized_keys
```
Add the public key generated in BigBlueButton server to authorizes keys in Matterhorn server.
Copy the content of  the file
`/home/firstuser/.ssh/id_rsa.pub` that is located in BigBlueButton server to `/root/.ssh/authorized_keys` in Matterhorn server

### Test SSH Connection ###
You can do a small test for checking the ssh connection by running a remote command, for example you can use the `ls` command and list the files inside the matterhorn folder

```
sudo -su tomcat6 ssh -i /usr/local/bigbluebutton/core/scripts/matt_id_rsa  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o CheckHostIP=no root@192.168.0.147 'ls /opt/matterhorn/felix/'
```

The output will be similar to this
```

Could not create directory '/usr/share/tomcat6/.ssh'.
Warning: Permanently added 'xxx.xxx.xx.x' (RSA) to the list of known hosts.
root@xxx.xxx.xx.x's password: 

bin
bundle
conf
DEPENDENCIES
doc
etc
felix-cache
inbox
LICENSE
LICENSE.kxml2
load
logs
matterhorn
NOTICE

```

You can ignore the message
```
Could not create directory '/usr/share/tomcat6/.ssh'.
```

at the beginning of the output, it won't affect the ssh connection.

Now ingestion should work during the publish phase.


### About Matterhorn ingestion ###
  * By default the directory where zipped packages are ingested in Matterhorn server is `$FELIX_HOME/inbox`

To change inbox directory, change the parameter `felix.fileinstall.dir`  in `/opt/matterhorn/1.1.0/docs/felix/load/org.apache.felix.fileinstall-inbox.cfg`

  * A zipped package is deleted from inbox after it is ingested

  * If the zipped package  sent from BigBlueButton is not a valid media package it is sent to `${org.opencastproject.storage.dir}/files/collection` where `org.opencastproject.storage.dir` is a parameter configured in `$FELIX_HOME/conf/config.properties`

# Your First Recording #
Open the home page on the BigBlueButton server. For example:
```
   http://192.168.0.35/
```

Click "View API Examples".  Click "Record (Matterhorn)".  Fill out the entry for the meeting.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt1.png)

Create and Start the BigBlueButton Session. Now:
  * Join to the voice conference
  * Start the webcam
  * Start desktop sharing

You must start all three, if you omit one then the recording will not be processed by BigBlueButton's matterhorn scripts.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt2.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt2.png)

When you are done presenting logout from the conference. After a couple of minutes the process and publish phase will start and it will send a zip file with the files necessary for matterhorn to process. You can check in the logs of matterhorn when the zip file is being processed:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt3.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt3.png)

After matterhorn finish processing the zip file, you will be able to reproduce the playback from the matterhorn server:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt4.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt4.png)

# Troubleshooting #

You can check the logs of recording in the  BigBlueButton server: `/var/log/bigbluebutton`

# Getting Help #

If you have any problems not answered by this document, or you have questions/feedback/bugs, please post to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2).