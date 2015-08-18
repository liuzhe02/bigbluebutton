**Note: These instructions are over two years old and very out-of-date.  We may update them in the future, but for now we recommend using an Ubuntu 10.04 64-bit server for installation of BigBlueButton.  See [installation](Installation.md).**

# How to install BigBlueButton on Debian Squeeze #



Note: These instructions are contributed and maintained by members of the BigBlueButton community.  If you have questions or feedback, please post to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2).

This small tutorial is an update of the step by step procedure to install a BigBlueButton 0.71a server on Debian Squeeze 32bit. This procedure assumes you've installed the i386 version of Squeeze with only the SSH server option selected.

## 1. Pre-requesites ##

  * Add repositories with their keys
```
# bigbluebutton repository key
wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | apt-key add -
# Freeswitch PPA key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 451AE93C
echo -e "deb http://ubuntu.bigbluebutton.org/lucid/ bigbluebutton-lucid main\ndeb http://ppa.launchpad.net/freeswitch-drivers/freeswitch-nightly-drivers/ubuntu lucid main" > /etc/apt/sources.list.d/bigbluebutton.list
aptitude update
```
  * Install pre-requisites with necessary workaround for packaging bugs:
    * Install sudo
> > All script are Ubuntufied so you will have to install sudo or some scripts (bbb-conf) won't work correctly.
```
aptitude install sudo
```
    * Install libmpfr
> > libmpfr has been superseded by [libmpfr4](http://packages.qa.debian.org/m/mpfr/news/20110223T163917Z.html) and so is no longer available in Debian Squeeze. swftools depends on it but the version in Lenny is a little bit too old (2.3.1), so instead of compiling the source and making a new package, as indicated in the old official how to, we'll just resolve the dependencies by using the one from ubuntu :
```
aptitude install libgmp3c2
wget http://ubuntu.mirror.cambrium.nl/ubuntu//pool/main/m/mpfr/libmpfr1ldbl_2.4.2-3ubuntu1_i386.deb
dpkg -i libmpfr1ldbl_2.4.2-3ubuntu1_i386.deb
```
    * Another workaround to avoid packaging errors later on :
```
mkdir -p /var/www/nginx-default/
touch /var/www/nginx-default/50x.html
```


## 2. BigBlueButton Install ##

  * You are now ready to install BigBlueButton
```
aptitude install bbb-freeswitch-config bigbluebutton
```
  * Configure BigBlueButton and start it :
```
bbb-conf --clean
bbb-conf --check
bbb-conf --setip YOUR_IP
```

You can now go to http://YOUR_IP and try the demo.

## 3. Tips and tricks ##

BigBlueButton works very well out of the box, but it is still quite young, and is not yet very flexible in term of configuration. So here are some tips that I collected, hoping they will save you some hours of hair pulling.

### 3.1. Firewall setup ###

BigBlueButton require to open 3 ports : 80, 1935, 9123. You can also open only port 80 and so tunnel everything through it, but you will most likely get bitten by [this bug](http://code.google.com/p/bigbluebutton/issues/detail?id=785) which is a [known Linux/Mac Adobe Flash bug](https://bugs.adobe.com/jira/browse/FP-4797). Basically you will be connected, and you will be able to do things but the session will re-initalise every 20-30 seconds. This bug doesn't affect Windows users and is supposed to be solved in Flashplayer 11.0.1.3 beta for Linux and Mac.

### 3.2. Put BigBlueButton server behind a firewall or on a VPN ###

If you put your BigBlueButton server on a VPN or behind a firewall and you want to configure a public access, the configuration can be very tricky. Here is an example config providing that you have the following topology :

```
WEB          <=>          Web Server           <=>          BigBlueButton server
              ExtIP : bigbluebutton.mydomain.com             IP : 192.168.1.10
```

BigBlueButton requires to have an IP that resolves to the same name as configured so either you can put a record in an internal DNS or add the following to its /etc/hosts :
```
vi /etc/hosts
-> 192.168.1.10	bigbluebutton.mydomain.com
bbb-conf --setip bigbluebutton.mydomain.com
```
It will throw a message that the IP does not match but this is ok.
```
# IP does not match:
#                           IP from ifconfig: 192.168.1.10
#   /etc/nginx/sites-available/bigbluebutton: bigbluebutton.mydomain.com
```

On the Web server :
  * Forward port 9123 to BigBlueButton's server port 9123
  * Forward port 1935 to BigBlueButton's server port 1935
  * Configure a new vhost called bigbluebutton.mydomain.com that does a proxy pass to 192.168.1.10
  * DO NOT TRY to put it on a subfolder (ie. mydomain.com/bbb) if you don't want to have to modify lots of bigblubutton's source code.

You should now be able to access your BigBlueButton server through http://bigbluebutton.mydomain.com

Beware that BigBlueButton's configuration is extremely sensitive, a slight change in the above and it might not work.

### 3.3. End meeting after every participants logged out ###

You can do this easily by modifying the configuration :
```
vi /var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties
-> beans.dynamicConferenceService.minutesElapsedBeforeMeetingExpiration=0
```
I found during my testing that the delay before the meeting is actually closed can vary from a few seconds to a few minutes, but it does work.

## 4. Conclusion ##

This will install a FULLY functional BigBlueButton server on your Squeeze box. Please check the project's [FAQ](FAQ.md) or post a message to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2) if your encounter any issues.

## 5. References ##

  * [Original version](https://redmine.personalized-software.ie/projects/opensource/wiki/BigBlueButton_Debian_Squeeze) of this tutorial with some Redmine integration tips.
  * [FAQ](FAQ.md)