_This page along is depreciated.  The discussions for the future architecture of BigBlueButton have moved into the [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list._

In particular, you can see the efforts to improve the voice: [Improving audio in BigBlueButton 0.8](http://groups.google.com/group/bigbluebutton-dev/browse_thread/thread/a36d61df9b9fc45b#).

_For a high-level draft roadmap for BigBlueButton's architecture, please see [Roadmap to 1.0](http://code.google.com/p/bigbluebutton/wiki/RoadMap1dot0). For information on contributing to BigBlueButton, please see [Contributing to BigBlueButton](http://code.google.com/p/bigbluebutton/wiki/FAQ#Contributing_to_BigBlueButton)._

**Depreciated**


The goal of this section is to summarize how we approach voice stability.

## Goals ##
Initial goals for this activity as stated by Tiago:

  * Creating workaround for network hiccups
  * Improve audio quality
  * Improve video quality

## Possible solutions ##

Can work around network hiccups through client-side monitoring.

Can improve audio quality by switching to another codec, avoiding TCP overhead, or echo messages.

Can improve video quality by transcoding to H264 or FFMPEG.

Both of the latter can be addressed by a local agent that is installed on each client.

Alternatively, we can directly talk to Asterisk from the client through SIP, circumventing the current transcoding layer inside BigBlueButton. Nadia's experiments with the SIP user agent show that this leads to a noticeable improvement in voice quality.

What is the cost of using this approach?

**Denis Zgonjanin, Feb 23rd 2011**
The cost of this far outweighs the advantages. You are talking about a local user agent, which means a native app or an applet. In the case of a native app, this has the effect of moving BigBlueButton away from WEB conferencing and onto the desktop. One of the main goals for this project is that the client should not need to install anything. You will also need to deal with different Operating Systems. You will need different versions for at least Windows, Mac, and Linux.
In the case of an applet, this moves us back to the early days of the web when people thought Java was the future of the web. Java applets have failed miserably - they are not well suited to the web. The decision to write desktop sharing as an applet was made because there was literally no other way to it. This is not the case with VoIP. And in the end desktop sharing with an applet turned out to be slow, error prone, and hardly usable. Moving parts of our application to applets and the desktop is not a good way to ensure future quality of the product.

### An alternate solution - Denis Zgonjanin ###
The voice delay and poor quality are the cause of 2 things mainly:
  1. Voice is sent over RTMP, which is built on TCP.
  1. Voice goes through red5 (bbb-voice) on the way to freeswitch, increasing the delay.

The solution to these two problems is as follows:
Problem 1. can be addressed by moving to a UDP based protocol. For Flash, this means moving to RTMFP. RTMFP was designed to be used in a Peer to Peer manner, but it can be similarly used in a traditional central server configuration. My personal tests with RTMFP based voice have been extremely promising (Richard and Fred can attest to this). The problem with RTMFP right now is that the only way to use it is through Adobe's proprietary solution. Since we are an Open Source project, this is not option. However, there are Open Source efforts at reverse engineering these Adobe services. See the [Cumulus Project](https://github.com/OpenRTMFP/Cumulus). Helping reverse engineer this solution will enable us to integrate an RTMFP capable solution into our voip.
Problem 2. can be solved by creating a native C module to Freeswitch, which accepts RTMFP connections. The Flash client would talk directly to Freeswitch through this RTMFP module. This will completely bypass red5.
The advantage of this solution as opposed to yours is that the BigBlueButton client stays within the confines of the browser. In the long run we can focus on improving server side performance, instead of moving our problems to the client.


---

[ArchitectureCouncil](ArchitectureCouncil.md)