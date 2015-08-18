# Introduction #

This page describes how the Flash BigBlueButton Client can be driven by an external 3rd-party Javascript.

Some 3rd-party applications want to display parts of BigBlueButton client in HTML5 while the other parts are still in Flash. To make this happen, we are creating an API bridge so that the 3rd-party application can embed BigBlueButton Flash Client and be able to send commands as well as receive events from the Flash Client.


# Design #

## High-Level Overview ##
The diagram below shows a high-level design of the capability of a 3rd-party application interacting with the Flash Client.

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb.png)

In this diagram, the 3rd-party javascript will interact with the BigBlueButton API javascript. The 3rd-party js will register to receive events and call functions on the API bridge to send commands to the Flash Client. The Flash Client exposes some callbacks through the Flash [ExternalInterface](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/external/ExternalInterface.html) class.

## Message Exchange Sequence ##

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb-1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb-1.png)

In the above diagram, we see the steps needed for the 3rd-party application and the Flash Client to be able to communicate with each other. When the Flash Client loads, it needs to perform a handshake with the HTML container to make sure that communication between Flash and Javascript is possible.

## Call Flow ##
The diagram below shows a detailed interaction between the 3rd-party application and the Flash Client.


![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb-2.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/api-bridge/embedding-bbb-2.png)

As an example, let's look at what happens when the user joins the voice conference. The user clicks a HTML button to join the voice conference. Clicking the button executes a javascript function (1) which calls into the BigBlueButton API bridge. The bridge then executes a callback (2) method exposed by the Flash Client through the ExternalInterface. The callback handler dispatches an event so that other parts of the client will (4) handle it and perform the necessary action to join the voice conference. An event is dispatched when the user has joined the voice conference which is received by the EventApiMap (5). The EventApiMap will invoke methods on the ExternalApiCall (6) which forwards the call to the API bridge (7). The API bridge then broadcast (8) the event to all interested listeners.

## Trying It Out ##

Let's assume you have your 3rd-party app hosted in !ServerA while BigBlueButton is hosted in !ServerB. !ServerA will have your 3rd-party HTML where you want to embed the BigBlueButton client.

On !ServerA, copy the example [3rd-part.html](https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/resources/prod/3rd-party.html) and the [3rd-party.js](https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/resources/prod/lib/3rd-party.js) files. These 2 files are your 3rd-party application. The HTML will be the container while the 3rd-part.js will be the one interacting with BigBlueButton client.

Edit the 3rd-party HTML to load the javascript dependencies from !ServerB except for the 3rd-party.js.

For the purposes of this example, we'll have bbb-web redirect to the 3rd-party.html when the user successfully joins the meeting.

Edit `/var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties` and change [defaultClientUrl](https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-web/grails-app/conf/bigbluebutton.properties#L98) to the URL of your 3rd-party.html. Restart tomcat6.

Join the meeting as usual. You should be redirected to the 3rd-party.html and presented with a bunch of buttons. Click on "Show Client" to load the BigBlueButton client. Once the client is loaded, you can click on the other buttons which triggers calls into Flash to perform the requests.