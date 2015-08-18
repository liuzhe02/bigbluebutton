

# Introduction to Stress Testing BigBlueButton #

This document is intended for developers who want to help stress test BigBlueButton.

This document (currently in its early stages) gathers together the various approaches to testing BigBlueButton.

## Quick Checks ##

BigBlueButton has a lot of ConfigurationFiles.  A quick check to see if your BigBlueButton server is properly configured, use the command

```
   sudo bbb-conf --check
```

This script runs through numerous checks for missing process, incorrect parameter in configuration files, missing packages, Unix ports that don't have any listeners, and known error messages in log files that indicate a configuration problem.  An warnings or potential errors are printed after the message `* Possible Problems *`.

The BigBlueButton process generate a lot of log files.  To quickly scan all the log files for errors or exceptions, use the command

```
   sudo bbb-conf --debug
```

After BigBlueButton has been running for a while, the log files get large.  When figuring out exactly what caused the error, a common technique is to do the following:

```
   sudo bbb-conf --clean
   sudo bbb-conf --watch
```

This will clean out all the log files (so there are no errors in the loogs), and display in the terminal the network activity and output of `bbb-conf --debug` every two seconds.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/watch.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/watch.png)

Using `--watch` you can connect to the BigBlueButton server and try a series of steps that you suspect causes an exception.  You'll see the exception appear almost immediately when it occurs.


## Stress Testing the BigBlueButton Server with Many Clients ##

A good stress test for BigBlueButton is to generate load with many test users.  Once you have 20, 40, 80 users connected, especially for long periods of time, you can watch the memory usage on the server with a tools such as [JConsole](SettingUpBigBlueButtonWithJconsole.md).

To generate users, use the shell script `bbb-test` located [here](https://github.com/bigbluebutton/bigbluebutton/blob/master/labs/stress-testing/bbb-test).  This script will let you startup N BigBlueButton clients on a remote BigBlueButton server.

Run this script on a Ubuntu Desktop (either 10.04 or 10.10).  Firefox comes already installed with Flash.

For purposes of this example, let's say we're testing the BigBlueButton server at 192.168.0.104.  We also have a separate computer running Ubuntu Desktop that we want to open a number of test clients to the BigBlueButton server.

On 192.168.0.104, edit the `config.xml` and change autoJoin for the PhoneModule to true.

```
<module name="PhoneModule" url="PhoneModule.swf?v=VERSION" 
        uri="rtmp://192.168.0.225/sip" 
        autoJoin="false"
        dependsOn="ViewersModule"
/>
```

This will automatically join new users into the voice.

Next, copy the utility bbb-test to your Ubuntu desktop.  On the Ubuntu Desktop, start FireFox, connect to your BigBlueButton server, and join the voice conference.  Flash will prompt you to join.

To remove the Flash prompt, open the global Flash Privacy Settings Manager using this [link](http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager02.html).  Find the IP address 192.168.0.104 and choose "always allow".

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/privacy.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/privacy.png)

Click the mute all button.

At this point, any subsequent BigBlueButton clients launched from the Ubuntu desktop computer will automatically join the voice conference muted.

To launch ten more clients, enter:

```
   bbb-test -h 192.168.0.104 -n 10
```

and the utility will ten BigBlueButton clients, each in their own tab, on the BigBlueButton server at 192.168.0.104.

Here's a snapshot of the FireFox client.


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/tenusers.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/testing/tenusers.png)

At this point, with a few computers running Ubuntu desktop, you can generate large numbers of BigBlueButton clients connected to the server.

To the BigBlueButton server, these are all real clients (with two streams for the VoIP channels).  If you generate 50 clients, for example, then login as the 51st client and upload a presentation, it will appear on all test clients.

These scenarios are good for  SettingUpBigBlueButtonWithJconsole and profiling the memory usage.

# Testing BigBlueButton in Imperfect Network Conditions #

The above test assumes that all users have perfect/excellent connection to the BigBlueButton server. Unfortunately, in production, that's not always the case.

You need to see how BigBlueButton behaves when a user or two doesn't have good connectivity to BigBlueButton server and see if the quality is acceptable for your users.

## Wan Emulator ##

You can use Wan Emulator (http://wanem.sourceforge.net/).

Wan Emulator allows you to simulate the "internet" in your Local Area Network. You can configure Wan Emulator to create a network with an unreliable (lossy, corrupted, delayed, jittered) connection. Then have a client connect to BigBlueButton through that simulated network and see what the quality is.

The Wan Emulator has pretty good documentation, so how to setup the environment won't be laid out in this wiki.

## pfsense Firewall ##

You can also use [pfsense](http://www.pfsense.org/) Firewall.  Here are the general steps:

  1. Install pfsense on a [computer ](http://doc.pfsense.org/index.php/Installing_pfSense_in_vmware_under_windows) or a [virtual machine](http://doc.pfsense.org/index.php/Installing_pfSense_in_vmware_under_windows).
  1. Setup a [limiter](http://doc.pfsense.org/index.php/Traffic_Shaping_Guide#Limiter) inside the firewall to limit bandwidth and introduce packet delay and loss.
  1. Change the router IP on your desktop computer to the one from the new firewall.
  1. Check with an traceroute that all the traffic goes over the new firewall. Use [mrt](http://en.wikipedia.org/wiki/MTR_(software)) to check the packet loss and delay.

Now all traffic from your desktop must go through the limiter.  Connect to a BigBlueButton server from your desktop to simulate a remote user with poor network connectivity.
