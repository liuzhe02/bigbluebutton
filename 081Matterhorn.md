

# Prerequisites #

You need [BigBlueButton 0.81-RC4](081InstallationUbuntu.md).  On a separate server (not the same server as BigBlueButton) install [Matterhorn 1.4](https://opencast.jira.com/wiki/display/mh14/Installation+and+Configuration)

# Overview #
[Matterhorn](http://opencast.org/matterhorn/) is an open source lecture capture and video management system for education.  When integrated with Matterhorn (see instructions below), BigBlueButton can record video, desktop, and audio and send the files to Matterhorn for processing and playback. This gives you other option for playback apart from the default available in BigBlueButton.


The instructions below show you how to install and configure the Matterhorn ingest and processing scripts.  When called by BigBlueButton, these scripts will create two video files: one with webcam + audio, the other for desktop sharing, along with an XML file (called dublin core) and bundle everything into a single zip file.  It will then scp the zip file to your Matterhorn server for processing.

The Matterhorn ingest and processing will scale the resolution of the desktop video to 640x480 before sending to Matterhorn.

If you encounter any problems with these instructions, please post to [bigbluebutton setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2) mailing list.


## Before you install ##
You'll need to ensure your `/etc/apt/sources.list` has the multiverse enabled.  If you get an error message such as `libfaac-dev can't be found` with the instructions below, see [Dependencies not met](http://code.google.com/p/bigbluebutton/wiki/08InstallationUbuntu#Dependencies_are_not_met).

## Ensure BigBlueButton records video and desktop session ##
BigBlueButton uses two red5 applications -- bbb-video and bbb-deskshare -- to share video and desktop.  In BigBlueButton 0.81, these applications are configured to  record media by default when you create a recorded session.


## Install the Matterhorn workflow (ingest and processing scripts) ##

```
   sudo apt-get install bbb-playback-matterhorn
```

## Configure the Matterhorn server to accept incoming files ##

This workflow will use a public/private key to send files to your Matterhorn server.


### Generate a ssh public key ###

This key will let BigBlueButton server send files to Matterhorn server without prompting a password.  The example below uses the 'root' user on your Matterhorn server.   If you have the matterhorn server running under a different account, use that account instead.

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
# NOTE: Make sure that the directory is writeable by _user_.
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

You must start webcam + desktop sharing +  audio, or desktop sharing + audio. If you omit desktop sharing the recording won't be processed by BigBlueButton's **matterhorn workflow**.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt2.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt2.png)

When you are done presenting, logout from the conference. After a couple of minutes the **matterhorn workflow** will process and publish the captured media and  will send a zip file to your Matterhorn server. You can check in the logs of matterhorn when the zip file is being processed:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt3.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt3.png)

After matterhorn finish processing the zip file, you will be able to reproduce the playback from your Matterhorn server:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt4.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/matterhorn/matt4.png)

# Troubleshooting #

You can check the logs of recording in the  BigBlueButton server: `/var/log/bigbluebutton/matterhorn/process-`_INTERNAL-MEETING-ID_`.log`
and
`/var/log/bigbluebutton/matterhorn/publish-`_INTERNAL-MEETING-ID_`.log`

# Getting Help #

If you have any problems not answered by this document, or you have questions/feedback/bugs, please post to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2).