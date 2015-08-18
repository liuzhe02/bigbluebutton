


---

## Overview ##

If you don't see an answer here, please post your question to [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev) mailing list.


## Virtual Machine ##

### Something is not working in the VM ... where can I go for help. ###

The best source is to post to the bigbluebutton-dev mailing list. We all hang out there and help each other.

### Which log files should I check for errors? ###

Check in the following files

  1. /var/lib/tomcat6/logs/localhost
> 2. /usr/share/red5/logs

If you would like to view the log dynamically, you can tail it in Linux by goind to the red5/log directory and executing the following command:

tail -f red.log

### How to access the red5 directory on the VM ###

You might want access to the red5 directory on the Virtual Machine. The following commands will share a shortcut to the red5 folder into your dev directory.

In /usr/share/red5
> sudo chmod go+w log
> sudo chown -R firstuser 

In /home/firstuser/dev
> ln -s /usr/share/red5 red5