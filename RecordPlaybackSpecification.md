

## Overview ##
The first part of this document describes the long-term vision and scope for implementing record and playback into BigBlueButton. The second part outlines the work implemented for the initial record and playback release in 0.8.

The purpose of this document is to provide a clear understanding of the business needs, the long-term vision to address the needs, and the constraints that are being faced during this phase of this project.  It also details the requirements and specifications for implementation of the first iteration. The document also attempts to foresee and mitigate any risks that for the first iteration.

This document assumes the reader understands the current BigBlueButton architecture. To get an overview of the architecture see http://code.google.com/p/bigbluebutton/wiki/ArchitectureOverview.

The terms "virtual meeting", "virtual classroom", and "sessions" all refer to a virtual meeting within a BigBlueButton server.

## Vision ##

The long-term vision for Record and Playback is to enable a university or college to capture, store, search, and retrieve lectures without any additional effort on the part of the teacher or students.

The implementation of this vision would extend the current API to enable third-party plugins -- such as those for Moodle, Sakai, WordPress, and so on -- to give the teacher control over creating the recordings and provide students easy access to the recordings.

The success of this vision would be measured in the number of educational institutions that actively use BigBlueButton to capture and distribute their lectures.

## Phases ##
Record and playback can be broken down into the following phases (The details of the technical implementation for the first iteration are covered later in this document):
  1. Capture
  1. Archive
  1. Ingest and Process
  1. Publish
  1. Playback

### Capture Phase ###
The Capture phase involves enabling the BigBlueButton modules (chat, presentation, video, voice, etc.) to emit events over an event bus for capture on the BigBlueButton server.  Components that generate media (webcam, voice, desktop sharing) must also store their data streams on the server as well.

### Archive Phase ###
The Capture Archive phase involves one or more server-based tools that subscribe to the event bus and store the emitted events (such as "advance to slide 3 at 12:34:32") together with the associated media (slides, audio, video, and other media streams) into a repository (database or file system) for later processing.

You can think of a server-based tool functioning as a VCR: it sees and records all the events and media generated during a BigBlueButton session without affecting the session itself.

### Ingest and Process Phase ###
The Ingest and Process Phase involves one or more tools that process the recorded events and media into a format for later playback.  A tool may process all or a subset of the recorded events and media.

For example, a tool can extract and process only the slides, slide transition events, and audio to create one of the following output formats:
  * a video file that could be uploaded to YouTube for playback,
  * a set of data files that could be loaded by a custom end-user Flash application that enables the user to navigate the recorded session by slide transitions, or
  * a set of data files that could be loaded by a custom HTML5 application that would enable the user to playback the recorded session on an iPad, iPhone, iPod touch.

The vision for this phase includes giving the moderator (or teacher or administrator) the ability to
  1. configure the output options for the recording (Flash, HTML5, video, etc),
  1. edit a recorded session, such as trimming content from the start or end of the recording, or deleting unwanted sections of the recording,
  1. schedule and monitor the processing of recorded content (such as in the case where video encoding takes significant time) and receive notifications when recorded material is ready for viewing.

### Publish Phase ###
The Public Phase provides one or more tools to manage the publication and access to the recorded sessions.  For example, a Distribution Management tool could upload a video file of a recorded session to external sites like YouTube, iTunesU, and others.

The vision for this phase includes the ability for an administrator to
  * easily distribute content to iTunesU, Youtube, etc,
  * monitor the access to content (such as views),
  * monetize access to the content,
  * transfer the media to a content distribution nework,
  * access the the recorded sessions from within 3rd party applications, such as WordPress or Joomla, using an associate BigBlueButton plug-in.

### Playback Phase ###
In the Playback Phase, the user loads a client tool -- such as video player, custom Flash client, or custom HTML5 client -- to playback a recorded session.

For example, the client tool could be an HTML interface the allows the user to do keyword searching through past recordings.  A student could enter the keyword "ecosystem" and the tool would search through all recorded session, display thumbnails of slides that contain that specific keyword, and start playback on a specific slide when the user clicks a thumbnail.

## High Level Architecture ##

### Record and Playback core directory ###
```
/usr/local/bigbluebutton/
└── core
    ├── Gemfile
    ├── Gemfile.lock
    ├── lib
    │   ├── recordandplayback
    │   │   ├── audio_archiver.rb
    │   │   ├── deskshare_archiver.rb
    │   │   ├── events_archiver.rb
    │   │   ├── generators
    │   │   │   ├── audio_processor.rb
    │   │   │   ├── audio.rb
    │   │   │   ├── events.rb
    │   │   │   ├── matterhorn_processor.rb
    │   │   │   ├── presentation.rb
    │   │   │   └── video.rb
    │   │   ├── presentation_archiver.rb
    │   │   └── video_archiver.rb
    │   └── recordandplayback.rb
    └── scripts
        ├── archive
        │   └── archive.rb
        ├── bbb-rap.sh
        ├── bigbluebutton.yml
        ├── cleanup.rb
        ├── process
        │   ├── README
        │   └── slides.rb
        ├── publish
        │   ├── README
        │   └── slides.rb
        ├── rap-worker.rb
        └── slides.yml
```

### Capture ###

  * bbb-web stores meeting info into redis
  * bbb-apps stores presentations in `/var/bigbluebutton/meetings/<meeting-id>/presentations/`
  * bbb-apps stores events into redis
  * deskshare records into `/var/bigbluebutton/deskshare/`
  * video records into `/usr/share/red5/webapps/video/streams/<meeting-id>/`
  * freeSWITCH records into `/var/freeswitch/meetings/`

**Raw Recording Directory**
The directories below are where the different subsystems will write the recordings:
  * `/var/bigbluebutton/<meeting-id>/presentations/`
  * `/var/freeswitch/meetings/`
  * `/usr/share/red5/webapps/video/streams/<meeting-id>/`
  * `/var/bigbluebutton/deskshare/`

**BBB Web API**
  * Called by 3rd-party apps through the API setting a record parameter to TRUE
  * Stores meeting info into Redis

**BBB - Apps**
  * Stores meeting events into Redis
  * Informs FreeSWITCH to start and stop recording
  * Listens start recording and stop recording events from FreeSWITCH

**Deskshare**
  * Records the deskshare stream as FLV in /var/bigbluebutton/deskshare/
  * Stores a start recording and stop recording event into redis

The capture of desktop sharing is turned off by default in BigBlueButton 0.8.  To enable capture of desktop sharing as a video file, edit

```
  /usr/share/red5/webapps/deskshare/WEB-INF/red5-web.xml
```

and set the constructor-arg for index 0 to `true`

```
  <bean id="streamManager" class="org.bigbluebutton.deskshare.server.stream.StreamManager">
    <constructor-arg index="0" value="true"/>
    <constructor-arg index="1" ref="recordingService"/>
  </bean>
```

then restart BigBlueButton

```
   sudo bbb-conf --restart
```


**Webcam**
  * Records the webcam stream as FLV in `/usr/share/red5/webapps/video/<meeting-id>`
  * Stores a start recording and stop recording event into redis

The capture of webcam is turned off by default in BigBlueButton 0.8.  To enable capture of webcam, edit

```
  /usr/share/red5/webapps/video/WEB-INF/red5-web.xml
```

and set `recordVideoStream` to `true`

```
        <bean id="web.handler" class="org.bigbluebutton.app.video.VideoApplication">
                <property name="recordVideoStream" value="true"/>
                <property name="eventRecordingService" ref="redisRecorder"/>
        </bean>
```

then restart BigBlueButton

```
   sudo bbb-conf --restart
```



### Raw Archiving ###
During archiving, scripts will copy the raw recordings into the following directories:
  * `/var/bigbluebutton/archive/<meeting-id>/events.xml`
  * `/var/bigbluebutton/archive/<meeting-id>/audio/`
  * `/var/bigbluebutton/archive/<meeting-id>/presentations/`
  * `/var/bigbluebutton/archive/<meeting-id>/video/`
  * `/var/bigbluebutton/archive/<meeting-id>/deskshare/`

**Archive Scripts**
In `/usr/local/bigbluebutton/core/scripts/archive`, there will be an archive (archive.rb) script. This archive script will be invoked when the meeting ends. The archive script contains functions for archiving components of the recording.

The archive\_events fuction will extract from redis the meeting info and the recorded events. These will be written into `/var/bigbluebutton/archive/<meeting-id>/events.xml`

The archive-**functions will copy all raw recordings into `/var/bigbluebutton/archive/<meeting-id>/`**

**archive.done**
The archive.done file is a status file where the scripts can store the archive status steps. This way, if something goes wrong on the first pass of archiving, another process (a cron job) can take a look at the archive.done file and attempt to continue archiving.

After several attempts, if there are still problems, the administrator needs to be notified.
Sample archive.done with convention [attempts status](type.md)

**events.xml**
```
   <recording>
     <meeting>
       <title>Business Ecosystem</title>
       <subject>TTMG 5001</subject>
       <description>How to manage your product's ecosystem</description>
       <creator>Richard Alam</creator>
       <contributor>Tony B.</contributor>
       <language>En-US</language>
       <identifier>TTMG5001-Week2-20110121</identifier>
     </meeting>
     <event timestamp="1296681157242" module="PARTICIPANT"
             name="ParticipantJoinEvent">
          <status>{raiseHand=false, hasStream=false, presenter=false}</status>
          <userId>1</userId>
          <role>MODERATOR</role>
     </event>
     …
   </recording>
```

### Ingest and Processing to Engage ###
In this phase, scripts are provided to take the raw recordings from the archive and process them into a format required for playback

In this release of BigBlueButton, we will provide 2 playback formats: simple playback and matterhorn

The output of the process phase should be stored in
  * `/var/bigbluebutton/process/<meeting-id>/simple`
  * `/var/bigbluebutton/process/<meeting-id>/matterhorn`

There should be a process.done file to keep the status of each process step.

### Properties ###
```
# Default maximum number of users a meeting can have.
# Doesn't get enforced yet but is the default value when the create
# API doesn't pass a value.
defaultMaxUsers=20

# Default duration of the meeting in minutes.
# Current default is 0 (meeting doesn't end).
defaultMeetingDuration=0

# Remove the meeting from memory when the end API is called.
# This allows 3rd-party apps to recycle the meeting right-away
# instead of waiting for the meeting to expire (see below).
removeMeetingWhenEnded=false

# The number of minutes before the system removes the meeting from memory.
defaultMeetingExpireDuration=1

# The number of minutes the system waits when a meeting is created and when
# a user joins. If after this period, a user hasn't joined, the meeting is
# removed from memory.
defaultMeetingCreateJoinDuration=5
```


## Requirements ##
These sections capture the more specific requirements for the first iteration of Record and Playback (BigBlueButton 0.8).

### System Requirements ###
The system requirements are
  1. The record and playback architecture must install within the BigBlueButton architecture
  1. The processing of captured events/media into recorded sessions must have minimal impact on the other functions of the BigBlueButton server
  1. The encoding of recorded sessions must use codecs that are unencumbered by patents
  1. The record and playback components must be installed/uninstalled by BigBlueButton’s Ubuntu 10.04 32-bit/64-bit packages.

### Support Requirements ###
The support requriements are
  1. The individual process tools (IngestAndRecording, etc.) must log their operations and any exceptions to facilitate troubleshooting.

#### Testing Requirements ####
The support requirements are
  1. The individual tools must have unit tests to ensure proper operation.

## Limitations and Assumptions ##
The limitations and assumptions are as follows:
Capture
  1. The moderator will not be able to start/stop record and playback (this greatly simplifies the architecture and changes to the BigBlueButton client).
Capture Archive
  1. Only the slides, slide transitions, and audio are captured.
Ingest and Processing
  1. The IngestAndProcessingService for the Playback Client will output English index.html pages.
  1. There will not be any security/passwords/or user accounts protecting the recordings, other than the third-party tool must know the meetingID to access the recordings.
Engage Tool
  1. The Playback Client will download the entire audio file for playback (this removes the need to use red5 as a streaming server).


## bbb-record ##

Command line tool to manage recordings.

### --watch ###

https://bigbluebutton.googlecode.com/files/bbb-record-watch-explanation.PNG

#### Troubleshooting ####


This section is intended to help you to find and in some cases to solve problems in the
Record and Playback component of BigBlueButton, watching the output of the command

```
bbb-record --watch
```

which output is explained [here](https://code.google.com/p/bigbluebutton/wiki/RecordPlaybackSpecification#--watch).

Before trying anything, verify that the "rap worker", (file in charge of the record and playback phases),
is working. Execute this command to verify:

```
ps ax | grep god | grep -v grep
```

Output should be similar to:

```
23317 pts/0    Sl     0:00 /usr/bin/ruby1.9.2 /usr/bin/god -c /etc/bigbluebutton/god/god.rb
```

If you don't get any output, start the rap worker manually

```
sudo god -c /etc/bigbluebutton/god/god.rb
```


##### RAS ( RECORDED - ARCHIVED - SANITY CHECK ) #####

Below **RAS** you won't see any **_X_** until the meeting has finished.

Once the meeting has finished, an **_X_** under **R** appears, if it does not appear:

  * Be sure all users left the meeting.

  * Check out that the parameter _defaultMeetingExpireDuration_ in _/var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties_ does not have a big value (default to 1).

  * Be sure the parameter _record=true_ was passed in the _create_ api call. If not, you didn't record the meeting.

Once the recording is archived, an **_X_** under **A** appears, if it does not appear:

  * Verify this this file exists

_/var/bigbluebutton/recording/status/recorded/INTERNAL-MEETING-ID.done_

that means that the meeting was recorded.

Once the recording passed the sanity check , an **_X_** appears under **S**, if it does not appear:

  * A media file was not properly archived, find the cause of the problem in the sanity log

```
grep INTERNAL-MEETING-ID /var/log/bigbluebutton/sanity.log
```


##### APVD #####

This section is related to recorded media. By default Audio and Presentation are recorded, if you don't see any **_X_** under **V** or **D**, then you haven't
shared your webcam or desktop, or you haven't enabled webcam or deskshare to be recorded, [ensure BigBlueButton is configured to record video and desktop session](MatterhornIntegration#Ensure_BigBlueButton_records_video_and_desktop_session.md).

##### APVDE #####

This section is related to archived media. If you don't see an **_X_** under a media you are sure that was recorded, check out
the sanity log. Execute this command to find the problem:

```
grep INTERNAL-MEETING-ID /var/log/bigbluebutton/sanity.log
```


##### Processed #####

If a script was applied to process your recording, its name should be listed under the column 'Processed', by default you should see "slides" and
"presentation", if you don't see one of them, find the problem in the log file of the processed recording:

```
grep -B 3 "status: 1" /var/log/bigbluebutton/presentation/process-INTERNAL-MEETING-ID.log | grep ERROR
```

```
grep -B 3 "status: 1" /var/log/bigbluebutton/slides/process-INTERNAL-MEETING-ID.log | grep ERROR
```

If there is some output it should show the problem. If there is not any output then tail the file to see which is the
latest executed task , sure that is the one that failed and an error message with the problem is described few lines after.

##### Published #####

If a script is applied to publish your recording, its name should be listed under the column 'Published', by default you should see "slides" and
"presentation", if you don't see one of them, find the problem in the log file of the published recording .

```
grep -B 3 "status: 1" /var/log/bigbluebutton/presentation/publish-INTERNAL-MEETING-ID.log | grep ERROR
```

```
grep -B 3 "status: 1" /var/log/bigbluebutton/slides/publish-INTERNAL-MEETING-ID.log | grep ERROR
```

If there is some output then you found the problem, if there is not any output then tail the file to see which is the
latest executed task , sure that is the one that failed and an error message with the problem is described few lines after.