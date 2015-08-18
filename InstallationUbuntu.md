**For updated documentation and instructions to install the newest version of BigBlueButton, see [http://docs.bigbluebutton.org/](http://docs.bigbluebutton.org/).**



**For updated documentation and instructions to install the newest version of BigBlueButton, see [http://docs.bigbluebutton.org/](http://docs.bigbluebutton.org/).**


# Welcome #

Welcome to the installation guide for BigBlueButton 0.81, our eleventh release to date.  For a quick overview of the capabilities of this release, see [release notes](ReleaseNotes.md) and [overview](081Overview.md).

# Before You Install #

**For updated documentation and instructions to install the newest version of BigBlueButton, see [http://docs.bigbluebutton.org/](http://docs.bigbluebutton.org/).**



**Note:** The packaging is for **Ubuntu 10.04 64-bit only**.  We no longer support 32-bit packaging for 0.81.

The requirements are

  * Ubuntu 10.04 64-bit
  * 4 GB of memory (8 GB is better)
  * Quad-core 2.6 GHZ CPU (or faster)
  * Ports 80, 1935, 9123 accessible
  * Port 80 is **not** used by another application
  * 500G of free disk space (or more) for recordings
  * 100 Mbits/sec bandwidth (upstream and downstream)

In addition to the above, the locale of the server must be en\_US.UTF-8. Furthermore, the contents of `/etc/default/locale` must contain the single line `LANG="en_US.UTF-8"`.  You can verify this as below.

```
$ cat /etc/default/locale
LANG="en_US.UTF-8"
```

If you don't see `LANG="en_US.UTF-8"`, then do the following

```
sudo apt-get install language-pack-en
sudo update-locale LANG=en_US.UTF-8
```

and the logout and log back into your session.  After the above, do `cat /etc/default/locale` again and verify you see only the single line `LANG="en_US.UTF-8"`.  Note: if you see an additional line `LC_ALL=en_US.UTF-8`, then remove the setting for `LC_ALL` before continuing.


Also, check that you are running under 64-bit.

```
$ uname -m
x86_64
```

You should see `x86_64`.  You should also not have any version of ruby installed.

```
$ ruby -v
-bash: ruby: command not found
```

If you have a version of ruby installed (such as ruby 1.8) uninstall the packages first.  BigBlueButton has been tested with ruby 1.9.2, which will be installed in the steps below.


# Installing BigBlueButton 0.81 #

These instructions assume you do not have a previous version of BigBlueButton installed.

If you are upgrading from BigBlueButton 0.80 to 0.81, start [here](#Upgrading_BigBlueButton_0.81.md).



## 1. Update your server ##

The following steps will install 0.81.

You first need to give your server access to the BigBlueButton package repository.

In a terminal window, copy and paste the following commands.

```
# Add the BigBlueButton key
wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -

# Add the BigBlueButton repository URL and ensure the multiverse is enabled
echo "deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
```

Next, ensure that you have `lucid multiverse` in your `sources.list`.  Do the following.

```
$ grep "lucid multiverse" /etc/apt/sources.list
```

If you have the `lucid multiverse` in your `sources.list`, you should see
```
deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse
```

If you don't see the deb line for `lucid multiverse`, execute the following line to add this repository to `sources.list`.

```
echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | sudo tee -a /etc/apt/sources.list
```

Before proceeding further, do a dist-upgrade to ensure all the current packages on your server are up-to-date.

```
sudo apt-get update
sudo apt-get dist-upgrade
```

If you've not updated in a while, apt-get may recommend you reboot your server after `dist-upgrade` finishes.  Do the reboot before proceeding to the next step.

## 2. Install LibreOffice ##

BigBlueButton uses LibreOffice to convert uploaded MS office documents to PDF. LibreOffice does a far better job of converting documents than the default OpenOffice packages in Ubuntu 10.04.

First, we'll install a stub package for openoffice.  This will serve as a placeholder for BigBlueButton's dependency on OpenOffice..

```
wget http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
sudo dpkg -i openoffice.org_1.0.4_all.deb
```

If you get an error in the above, check if you have openoffice.org-core installed.  If so, remove all the existing openoffice.org pacakges and try to install the above stub package again.


Next, we'll install LibreOffice

```
sudo apt-get install python-software-properties

sudo apt-add-repository ppa:libreoffice/libreoffice-4-0
sudo apt-get update

sudo apt-get install libreoffice-common
sudo apt-get install libreoffice
```

## 3. Install Ruby ##
The record and playback infrastructure uses Ruby for the processing of recorded sessions.

Check if you have a previous version of ruby install.

```
   dpkg -l | grep ruby
```

If you already have ruby installed, check it's version

```
~$ ruby -v
ruby 1.9.2p290 (2011-07-09 revision 32553)
```

If the version of ruby does not match the above, uninstall it before continuing.

Download the following pre-build ruby package.
```
wget https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
```

This next install command will give you an error about dependencies not found.

```
  sudo dpkg -i ruby1.9.2_1.9.2-p290-1_amd64.deb
```

To resolve the dependencies, enter

```
  sudo apt-get install -f
```

After the package installs, run the following two commands to setup the paths to the ruby executable.

```
sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.2 500 \
                         --slave /usr/bin/ri ri /usr/bin/ri1.9.2 \
                         --slave /usr/bin/irb irb /usr/bin/irb1.9.2 \
                         --slave /usr/bin/erb erb /usr/bin/erb1.9.2 \
                         --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.2
sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.2 500

```

Run the following command to check that ruby is now installed.

```
$ ruby -v
ruby 1.9.2p290 (2011-07-09 revision 32553)
```

And that gem is now installed.
```
$ gem -v
1.3.7
```

Finally, to make sure you can install gems, run the commands below to install a test gem.  (BigBlueButton does not need the gem hello; rather, we're just testing to makes sure gem is working properly).

```
$ sudo gem install hello
Successfully installed hello-0.0.1
1 gem installed
Installing ri documentation for hello-0.0.1...
Installing RDoc documentation for hello-0.0.1...
```

Make sure you can execute the above three commands without errors before continuing with these instructions.  If you do encounter errors, please post to [bigbluebutton-setup](http://groups.google.com/group/bigbluebutton-setup/topics?gvc=2&pli=1) and we'll help you resolve the errors.

You might be wondering why not use the default Ruby packages for Ubuntu 10.04?  Unfortunately, they are out of date.  Thanks to [Brendan Ribera](http://threebrothers.org/brendan/blog/ruby-1-9-2-on-ubuntu-11-04/) for the above script for installing the latest ruby on Ubuntu 10.04 as a package.

## 4.  Install ffmpeg ##
BigBlueButton uses ffmpeg to process video files for playback.  To install ffmpeg, create a file called `install-ffmpeg.sh` and copy and paste in the following script.

```
sudo apt-get install build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libxfixes-dev zlib1g-dev pkg-config

LIBVPX_VERSION=1.2.0
FFMPEG_VERSION=2.0.1

if [ ! -d "/usr/local/src/libvpx-${LIBVPX_VERSION}" ]; then
  cd /usr/local/src
  sudo git clone http://git.chromium.org/webm/libvpx.git "libvpx-${LIBVPX_VERSION}"
  cd "libvpx-${LIBVPX_VERSION}"
  sudo git checkout "v${LIBVPX_VERSION}"
  sudo ./configure
  sudo make
  sudo checkinstall --pkgname=libvpx --pkgversion="${LIBVPX_VERSION}" --backup=no --deldoc=yes --default
fi

if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
  cd /usr/local/src
  sudo wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  sudo tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  cd "ffmpeg-${FFMPEG_VERSION}"
  sudo ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
  sudo make
  sudo checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default
fi
```

Next, run the commands

```
chmod +x install-ffmpeg.sh
./install-ffmpeg.sh
```

After the script finishes, check that ffmepg is installed by typing the command `ffmpeg -version`.  You should see the following

```
$ ffmpeg -version
ffmpeg version 2.0.1
built on Sep  1 2013 02:02:28 with gcc 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1)
configuration: --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
libavutil      52. 38.100 / 52. 38.100
libavcodec     55. 18.102 / 55. 18.102
libavformat    55. 12.100 / 55. 12.100
libavdevice    55.  3.100 / 55.  3.100
libavfilter     3. 79.101 /  3. 79.101
libswscale      2.  3.100 /  2.  3.100
libswresample   0. 17.102 /  0. 17.102
```


## 5.  Install BigBlueButton ##
We're now ready to install BigblueButton. Type

```
   sudo apt-get install bigbluebutton
```


This single command is where all the magic happens.  This command installs **all** of BigBlueButton components with their dependencies.  The packaging will do all the work for you to install and configure your BigBlueButton server.

If you are behind a HTTP Proxy, you will get an error from the package bbb-record-core.  You can resolve this by [manually installing the gems](#Unable_to_install_gems.md).

If you get an error message
```
...... Error: FreeSWITCH didn't start 
```
you can ignore it as we'll do a clean restart of all the components in step 7.

Next, we've updated the desktop sharing applet with a new certificate.  You can download the JAR file using the following command

```
   wget http://ubuntu.bigbluebutton.org/files/bbb-deskshare-applet-0.8.1.jar
```

and then update the existing applet with the following command


```
  sudo cp bbb-deskshare-applet-0.8.1.jar /var/www/bigbluebutton/client/bbb-deskshare-applet-0.8.1.jar

```



## 6. Install API Demos ##

To interactively test your BigBlueButton server, you can install a set of API demos.

```
   sudo apt-get install bbb-demo
```

You'll need the bbb-demo package installed if you want to join the Demo Meeting from your BigBlueButton server's welcome page.  This is the same welcome page you see at [dev081 demo server](http://dev081.bigbluebutton.org).

Later on, if you wish to remove the API demos, you can enter the command

```
   sudo apt-get purge bbb-demo
```


## 7. Do a Clean Restart ##

To ensure BigBlueButton has started cleanly, enter the following commands:

```
   sudo bbb-conf --clean
   sudo bbb-conf --check
```

The `--clean` option will clear out all the log files for BigBlueButton.  The `--check` option will grep through the log files looking for errors.

The output from `sudo bbb-conf --check` will display your current settings and, after the text, " Potential problems described below ", print any potential configuration or startup problems it has detected.



# Upgrading BigBlueButton 0.81 #
If you have already installed an earlier version of 0.81, to upgrade to the latest version

```
   sudo apt-get update
   sudo apt-get dist-upgrade

   sudo bbb-conf --clean
   sudo bbb-conf --check
```

If `sudo bbb-conf --check` warns that you are running an older version of ffmpeg (you need version 2.0.1 installed), [re-install ffmpeg](081InstallationUbuntu#4.__Install_ffmpeg.md) and enter the following commands:

```
   sudo bbb-conf --clean
   sudo bbb-conf --check
```


# Upgrading from BigBlueButton 0.80 #

The packaging is for Ubuntu 10.04 64-bit only.  We no longer support 32-bit packaging for 0.81.  This means you cannot upgrade the BigBlueButton 0.80 virtual machine (VM) to 0.81 as the VM is 32-bit.  Recommend you create a new Ubuntu 10.04 64-bit server.  See  [Ubuntu Virtual Machines](https://help.ubuntu.com/community/VirtualMachines).

If you are upgrading from BigBlueButton 0.80, please note if you've made any custom changes to BigBlueButton, such as

  * applied custom branding
  * modified /var/www/bigbluebutton/client/conf/config.xml
  * modified /var/www/bigbluebutton-default/index.html
  * modified API demos
  * modified settings to FreeSWITCH configurations
  * etc ...

then you'll need to backup your changes before doing the following upgrade, after which you can reapply the changes.

The following steps will update a BigBlueButton 0.80 server to 0.81.

## 1. Update your server ##

First, update the package URL to point to the new BigBlueButton release.

```
   echo "deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-lucid main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
```

Next, update the package database on your server.

```
   sudo apt-get update
```

## 2. Switch from OpenOffice to LibreOffice ##

LibreOffice does a far better job of converting documents than the default OpenOffice packages in Ubuntu 10.04.

First, to avoid issues, stop the openoffice headless init script.
```
sudo /etc/init.d/bbb-openoffice-headless stop
```

Now we'll install a stub package for openoffice. This will serve as a placeholder for BigBlueButton's dependency on OpenOffice.
```
wget http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
sudo dpkg -i openoffice.org_1.0.4_all.deb
```

And then we tell apt to clear out the old openoffice packages:
```
sudo apt-get autoremove
```

Next, we'll install libreoffice
```
sudo apt-get install python-software-properties

sudo apt-add-repository ppa:libreoffice/libreoffice-4-0
sudo apt-get update

sudo apt-get install libreoffice-common libreoffice
```

Note that you should not restart the openoffice headless init script, since the version from 0.80 may not correctly recognize libreoffice. The 0.81 installation process will start it later.


## 3. Update red5 ##

You must update red5 first before the other BigBlueButton packages. To update red5, do the following:

```
   sudo /etc/init.d/red5 stop
   sudo apt-get install red5
```

If you get prompted to update the the configuration file `/etc/init.d/red5'

```
Configuration file `/etc/init.d/red5'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : background this process to examine the situation
 The default action is to keep your current version.
*** red5 (Y/I/N/O/D/Z) [default=N] ?
```

Respond with **Y** and press Enter.

## 4.  Install ffmpeg ##
BigBlueButton uses ffmpeg to process video files for playback.  To install ffmpeg, create a file called `install-ffmpeg.sh` and copy and paste in the following script.

```
sudo apt-get install build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libxfixes-dev zlib1g-dev pkg-config

LIBVPX_VERSION=1.2.0
FFMPEG_VERSION=2.0.1

if [ ! -d "/usr/local/src/libvpx-${LIBVPX_VERSION}" ]; then
  cd /usr/local/src
  sudo git clone http://git.chromium.org/webm/libvpx.git "libvpx-${LIBVPX_VERSION}"
  cd "libvpx-${LIBVPX_VERSION}"
  sudo git checkout "v${LIBVPX_VERSION}"
  sudo ./configure
  sudo make
  sudo checkinstall --pkgname=libvpx --pkgversion="${LIBVPX_VERSION}" --backup=no --deldoc=yes --default
fi

if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
  cd /usr/local/src
  sudo wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  sudo tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  cd "ffmpeg-${FFMPEG_VERSION}"
  sudo ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
  sudo make
  sudo checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default
fi
```

Next, run the commands

```
chmod +x install-ffmpeg.sh
./install-ffmpeg.sh
```

## 5. Update BigBlueButton ##

Next, update BigBlueButton itself

```
   sudo apt-get dist-upgrade
```

You'll be asked to update the nginx definition for BigBlueButton.

```
Configuration file `/etc/nginx/sites-available/bigbluebutton'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : background this process to examine the situation
 The default action is to keep your current version.
*** bigbluebutton (Y/I/N/O/D/Z) [default=N] ?
```

Enter 'Y' to continue the upgrade.  Next, we'll need to trigger an update to the !FreeSWITCH configuration as the dependencies of the packages have changed.  To trigger the update, we'll remove the old package

```
sudo apt-get remove bbb-freeswitch
```

Enter 'Y' to remove the old package, and then re-apply the new packages.  this will trigger a download and install of the new bbb-freeswitch package.

Next, install the newer version of FreeSWITCH.

```
sudo apt-get install bbb-freeswitch=0.81ubuntu55
```

and then re-install the remaining BigBlueButton packages.

```
sudo apt-get install bigbluebutton
```


Next, to enable recording of webcams for record and playback (webcams were not recorded by default in 0.80) edit `/usr/share/red5/webapps/video/WEB-INF/red5-web.xml` and change line 49 to show

```
                <property name="recordVideoStream" value="true"/>
```


To ensure all configuration files have the correct hostname/IP, do

```
   sudo bbb-conf --setip <ip_or_hostname>
```

where 

<ip\_or\_hostname>

 is the IP or hostname for your BigBlueButton server.

Use the BigBlueButton configuration utility to do a clean restart (clean out log files) check for any installation errors.

```
   sudo bbb-conf --clean 
   sudo bbb-conf --check 
```


## 6. Updating the recording scripts ##
The installation of 0.81 will install a new record and playback script called `presentation`.  This replaces the older record and playback script `slides` in 0.80.

After upgrade, you'll still have the older record and playback scripts installed.

```
$ dpkg -l | grep slides
ii  bbb-playback-slides               0.80ubuntu94                                    BigBluebutton playback of slides and audio
```

If you didn't have any recordings in 0.80, you can simply remove the old script.

```
sudo apt-get autoremove
```

If you do have recordings, you'll want to keep this package to enable users to view the older recordings; however, prevent BigBlueButton from processing newer recordings using `slides` (again, you'll want to use the newer `presentation` scripts), you can disable the older scripts by doing the following.

```
mkdir -p /var/tmp/process /var/tmp/publish
sudo mv /usr/local/bigbluebutton/core/scripts/process/slides.rb /var/tmp/process
sudo mv /usr/local/bigbluebutton/core/scripts/publish/slides.rb /var/tmp/publish
```


# Troubleshooting #

If you encounter an error at one of the installation/upgrade steps,


## Run sudo bbb-conf --check ##
We've built in a BigBlueButton configuration utility, called `bbb-conf`, to help you configure your BigBlueButton server and trouble shoot your setup if something doesn't work right.

If you think something isn't working correctly, the first step is enter the following command.

```
   sudo bbb-conf --check
```

This will check your setup to ensure the correct processes are running, the BigBlueButton components have correctly started, and look for common configuration problems that might prevent BigBlueButton from working properly.  For example, here's the output on one of our internal servers:

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71check.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/vm/71check.png)


If you see text after the line `** Potential problems described below **`, then `bbb-conf` it may be warnings (which you can ignore if you've change settings) or errors with the setup.


## Dependencies are not met ##

For some VPS installations of Ubuntu 10.04, the hosting provider does not give a full `/etc/apt/source.list`.  If you are finding your are unable to install a package, try replacing your `/etc/apt/sources.list` with the following


```
#
#
# deb cdrom:[Ubuntu-Server 10.04 LTS _Lucid Lynx_ - Release amd64 (20100427)]/ lucid main restricted

# deb cdrom:[Ubuntu-Server 10.04 LTS _Lucid Lynx_ - Release amd64 (20100427)]/ lucid main restricted
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.

deb http://us.archive.ubuntu.com/ubuntu/ lucid main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://us.archive.ubuntu.com/ubuntu/ lucid-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://us.archive.ubuntu.com/ubuntu/ lucid universe
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid universe
deb http://us.archive.ubuntu.com/ubuntu/ lucid-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid multiverse
deb http://us.archive.ubuntu.com/ubuntu/ lucid-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ lucid-updates multiverse

## Uncomment the following two lines to add software from the 'backports'
## repository.
## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
# deb http://us.archive.ubuntu.com/ubuntu/ lucid-backports main restricted universe multiverse
# deb-src http://us.archive.ubuntu.com/ubuntu/ lucid-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu lucid partner
# deb-src http://archive.canonical.com/ubuntu lucid partner

deb http://security.ubuntu.com/ubuntu lucid-security main restricted
deb-src http://security.ubuntu.com/ubuntu lucid-security main restricted
deb http://security.ubuntu.com/ubuntu lucid-security universe
deb-src http://security.ubuntu.com/ubuntu lucid-security universe
deb http://security.ubuntu.com/ubuntu lucid-security multiverse
deb-src http://security.ubuntu.com/ubuntu lucid-security multiverse
```

then do

```
   sudo apt-get update
```

and try installing BigBlueButton again.


## Change the BigBlueButton Server's IP ##

A common problem is the default install scripts in for BigBlueButton configure it to list for an IP address, but if you are accessing your server via a DNS hostname, you'll see the 'Welcome to Nginx' message.

To change all of BigBlueButton's configuration files to use a different IP address or hostname, enter

```
   sudo bbb-conf --setip <ip_address_or_hostname>
```

For more information see [bbb-conf options](BBBConf.md).


## Unable to install gems ##
The install script for bbb-record-core needs to install a number of ruby gems.  However, if you are behind a HTTP\_PROXY, then the install script for bbb-record-core will likely exit with an error.  This occurs because the bash environment for bbb-record-core will not have a value for HTTP\_PROXY.

You can resolve this by manually installing the gems using the following script.
```
#!/bin/bash

export HTTP_PROXY="<your_http_proxy>"

gem install --http-proxy $HTTP_PROXY builder -v 2.1.2
gem install --http-proxy $HTTP_PROXY diff-lcs -v 1.1.2
gem install --http-proxy $HTTP_PROXY json -v 1.4.6
gem install --http-proxy $HTTP_PROXY term-ansicolor -v 1.0.5
gem install --http-proxy $HTTP_PROXY gherkin -v 2.2.9
gem install --http-proxy $HTTP_PROXY cucumber -v 0.9.2
gem install --http-proxy $HTTP_PROXY curb -v 0.7.15
gem install --http-proxy $HTTP_PROXY mime-types -v 1.16
gem install --http-proxy $HTTP_PROXY nokogiri -v 1.4.4
gem install --http-proxy $HTTP_PROXY open4 -v 1.3
gem install --http-proxy $HTTP_PROXY rack -v 1.2.2
gem install --http-proxy $HTTP_PROXY redis -v 2.1.1
gem install --http-proxy $HTTP_PROXY redis-namespace -v 0.10.0
gem install --http-proxy $HTTP_PROXY tilt -v 1.2.2
gem install --http-proxy $HTTP_PROXY sinatra -v 1.2.1
gem install --http-proxy $HTTP_PROXY vegas -v 0.1.8
gem install --http-proxy $HTTP_PROXY resque -v 1.15.0
gem install --http-proxy $HTTP_PROXY rspec-core -v 2.0.0
gem install --http-proxy $HTTP_PROXY rspec-expectations -v 2.0.0
gem install --http-proxy $HTTP_PROXY rspec-mocks -v 2.0.0
gem install --http-proxy $HTTP_PROXY rspec -v 2.0.0
gem install --http-proxy $HTTP_PROXY rubyzip -v 0.9.4
gem install --http-proxy $HTTP_PROXY streamio-ffmpeg -v 0.7.8
gem install --http-proxy $HTTP_PROXY trollop -v 1.16.2
```

Once all the gems are installed, you need to tell BigBlueButton install scripts `bbb-record-core` to not try to install the gems anymore.  Edit the file `/var/lib/dpkg/info/bbb-record-core.preinst` and comment out the line

```
#                        gem install $gem
```

Then run

```
sudo apt-get install -f
```