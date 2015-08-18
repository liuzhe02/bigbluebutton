# Introduction #

The desktop sharing application in BigBlueButton allows someone to let others see his/her desktop. However, it doesn't allow a remote user to control the sharer's desktop.


# Deskshare Client #
The diagram below illustrates the different components of the desktop sharing client. The desktop sharing client is written in java and can be run as an Applet or as a Standalone application. The application will create the Client which then creates a screen sharer, FullScreen or Region depending on what the user chooses. The Client then starts capturing the screen using the CaptureTaker. The CaptureTaker then hands-off the captured screen to the BlockManager which divides the screen into several blocks. The blocks are then handed off to the NetworkSender. The NetworkSender determines if the data will be sent using a direct TCP socket connection or through HTTP tunnelling.

![https://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/deskshare-client.png](https://bigbluebutton.googlecode.com/svn/trunk/bbb-images/08/deskshare-client.png)