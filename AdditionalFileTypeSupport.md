# Introduction #

**Note:** This page is now obsolete as support for additional file types was merged into BigBlueButton 0.63.


# Known bugs/issue/fixme #
  * In bbb-web/grails-app/conf/bigbluebutton.properties, a fullpath for jodconverter lib is set. (to the VM dev dir for now...)
  * Try using Jodconverter beans instead of using a binary to convert file... :x

# Requirement #
## OpenOffice ##
On debian :
```
sudo apt-get install openoffice.org
```

## Soffice Debian startup script ##
```
#!/bin/sh
# openoffice.org  headless server script
#
# chkconfig: 2345 80 30
# description: headless openoffice server script
# processname: openoffice
#
# Author: Vic Vijayakumar
# Modified by Federico Ch. Tomasczik
#
OOo_HOME=/usr/bin
SOFFICE_PATH=$OOo_HOME/soffice
PIDFILE=/var/run/openoffice-server.pid
set -e
case "$1" in
    start)
    if [ -f $PIDFILE ]; then
      echo "OpenOffice headless server has already started."
      sleep 5
      exit
    fi
      echo "Starting OpenOffice headless server"
      $SOFFICE_PATH -headless -nologo -nofirststartwizard -accept="socket,host=127.0.0.1,port=8100;urp" & > /dev/null 2>&1
      touch $PIDFILE
    ;;
    stop)
    if [ -f $PIDFILE ]; then
      echo "Stopping OpenOffice headless server."
      killall -9 soffice && killall -9 soffice.bin
      rm -f $PIDFILE
      exit
    fi
      echo "Openoffice headless server is not running."
      exit
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
esac
exit 0
```

# Installation #
Debian:
```
sudo apt-get install openoffice.org
sudo cp /home/firstuser/dev/bbb-web/scripts/sofficed.sh /etc/init.d/
sudo chmod 755 /etc/init.d/sofficed.sh
sudo update-rc.d sofficed.sh defaults
sudo /etc/init.d/sofficed.sh start
```

That's all folks...