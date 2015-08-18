**Note:** This was a temporary page for information on the 0.71 release.  This page is now marked as depreciated.  Please see [BigBlueButton Google Code Home Page](http://code.google.com/p/bigbluebutton/) for the latest content.



# Introduction #

This page is a holding place for the latest information on testing of 0.71-Beta.  We're now in our testing phase.  Here's an update or our progress:

  1. ~~Install 0.71-beta on devtest.bigbluebutton.org for limited testing~~
  1. ~~Install 0.71-beta on demo.bigbluebutton.org for broader testing~~
  1. ~~Release the 0.71-beta Ubuntu packages for local installation and testing~~
  1. ~~Release a 0.71-beta VM for download and testing~~

If you want to try the latest version from packages, you can
  * visit [http://demo.bigbluebutton.org/](http://demo.bigbluebutton.org/), or
  * [install](http://code.google.com/p/bigbluebutton/wiki/071DraftInstall) BigBlueButton 0.71-beta on your own server.

If you want to try the latest version from VM, you can
  * [Download BigBlueButton 0.71-Beta VM](http://sourceforge.net/projects/bigbluebutton/), and follow the setup instructions at [Setting up a BigBlueButton VM](http://code.google.com/p/bigbluebutton/wiki/BigBlueButtonVM).

If you find a bug, first check the [issue tracker](http://code.google.com/p/bigbluebutton/issues/list) to see if it's already been reported.  If not, please create a new issue and provide
  * a short description
  * the steps to reproduce it

You should also do a quick check of the [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list before opening a new issue.

## 0.71 Documentation ##

Below are the links to the DRAFT 0.71 documentation.  Once we ship 0.71, these documents will overwrite the existing documents and the drafts below will be marked as depreciated.

  * [Overview](http://code.google.com/p/bigbluebutton/wiki/071Overview)
    * Temporary page giving overview of what's new in 0.71; will be merged into the release notes
  * [Branding](http://code.google.com/p/bigbluebutton/wiki/Branding)
    * Undergoing internal review
  * [Ubuntu Install](http://code.google.com/p/bigbluebutton/wiki/071DraftInstall)
    * **Draft, ready for external review**
  * [Step-by-step Manual Install of BigBlueButton from source components](http://code.google.com/p/bigbluebutton/wiki/InstallingBigBlueButtonCurrent)
    * **Draft, ready for external review**
  * [Client Configuration parameters for config.xml](http://code.google.com/p/bigbluebutton/wiki/ClientConfiguration)
    * **Draft, ready for external review**
  * [Setting up development environment](http://code.google.com/p/bigbluebutton/wiki/DevelopBigBlueButtonCurrent)
    * Undergoing internal updates


## 0.71 Features ##

While this list is not complete, here are some of the new capabilities coming in BigBlueButton 0.71.

### Reduced audio lag with VoIP ###

This was the bulk of our effort for 0.71.  We improved the algorithms to handle audio packets coming to and from the BigBlueButton server.  You should experience less audio lag using VoIP when compared to 0.70.  (We'll let you judge the extent to which the lag has been reduced.)

BigBlueButton 0.71 now supports FreeSWITCH as a voice conference server.  This enables the BigBlueButton client to transmit either wide-band (16 kHz) Speex or the Nellymoser voice codec.   In our testing so far, we found that nellymoser scales better and will remain the default voice codec in BigBlueButton.

**Test:** Open two BigBlueButton sessions.  Join the audio in both session, but mute one of the microphones.  Using a headset, start counting 1, 2, 3, etc.  You'll hear yourself as the VoIP packages are sent to the BigBlueButton server from one client and are received on the other.

### Auto display of user's video ###

When a user shares their webcam, it automatically opens on all other users connected to the virtual classroom.

**Test:** Open two BigBlueButton sessions.  Share your webcam in one; a view webcam window should automatically appear in the other.


### Share a region of your desktop ###

To reduce the bandwidth usage of desktop sharing, BigBlueButton now gives the presenter the option of selecting a rectangular region of their desktop.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-5.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-5.png)

When you click 'Region', the desktop sharing applet will start and display dragable and resizable selection area appears on your screen.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-6.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-6.png)

**Test:** Try sharing a region of your desktop with other participants.  You can also open two BigBlueButton sessions and share your desktop from one; a view desktop window should automatically open in the others.


### Change your locale from within the client ###

The BigBlueButton client will detect your locale and choose the associated localization strings (if available).  There is now a drop-down menu to manually choose a locale (which helps test support for other languages).  When chosen, the interface will automatically switch to that language.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-1.png)

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-2.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-2.png)

**Test:** Try changing the localization setting.  If you understand the language in a different localization setting, see if the user interface strings make sense.


### Automatic translation of chat messages using Google Translate ###

When someone types you a message from a different locale, the Chat window will automatically use Google Translate to translate messages to your language.


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-3.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/0-17-3.png)

**Test:** Try opening two BigBlueButton sessions and change the locale  session in one.  Try typing test -- the text will be translated by Google Translate.

The chat window now shows local times for messages.

### Branding of your BigBlueButton instance ###
You can now change the look and feel of bbb using css. Check the [Branding](Branding.md) page for more info.

### Configuration of BigBlueButton client ###
You now have more control over certain functionality of BigBlueButton. You can change the video quality, define who can share video, allow moderators to kick users, etc... Check the [Client Configuration](ClientConfiguration.md) page for more info.


### Breakout Meetings (experimental) ###
Sometimes you want to split up your conference into several smaller meetings right from inside BigBlueButton. You can now do that using the new optional Breakout Module. See this [blog post](http://bigbluebutton-blog.blogspot.com/2010/09/breakout-rooms-in-071.html) for more info.

This feature will not be enabled by default in the final release.