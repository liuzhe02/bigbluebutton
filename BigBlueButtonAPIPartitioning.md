_This document is depreciated._

# Introduction #

The goal for the API partitioning initiative is to provide API interfaces to enable a Third Party application make calls for different Bigbluebutton modules.

An example would be, starting or stopping the chat module or the presentation module from the 3rd party applications and being bale to access functionalities related to the loaded module(s).

To review the changes and try out the API partitioning you can check out the code from Coral CEA repository  [here](https://github.com/coralcea/bigbluebutton). Details of how to checkout the code and compile the pieces associated with API will come later on this page.

_Warning: we are at a very early stages of the API partitioning development, so the code is under ongoing changes and we can't guarantee a total functionality for the system at he moment._

## The API Architecture ##

This section contains a simple diagram of the existing API architecture. The diagram below describes the operation and information exchange for the existing Bigbluebutton API. The current development didn't involve any architectural changes for the API calls. (See digram below)



<img src='http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/API_PART/BBB_API.jpg' />

_Add more details and update the images for loading 2 modules etc_
_Also need to explain the JMS message systems and structure and more details about the "moduleCommand" API call_

**Use cases:**
> This section lists the use cases or the scenarios for Third Party application API calls.

  * Load a single BBB module (i.e. load chat module or voice, etc) when a 3rd party application starts.

  * Load more than one BBB module (i.e. chat & video, chat & presentation) when 3rd party application starts.

  * Load only one BBB module (i.e. load chat module or voice, etc)  in response to an event from a 3rd party application (mouse click, conf call button, etc)

  * Load more than one module at different times in response to events from the 3rd party application. Example, click to make a call (load voice module) and later click to start the video or click to start a presentation while calling.


**API Calls suggestions for format:**

For the API calls and response we just followed the orginal format that was used for the BBB API calls but to make things easy we didn't use the checksum (it will be added later for the final version).

The API standard calls and format can be found on the [API](API.md) page at the [API Calls](http://code.google.com/p/bigbluebutton/wiki/API#API_Calls) section.


**How to add a new API command**

_To Do_

**Changes on the API web-app side**

Files involved:

  1. bigbluebutton-web/grails-app/controllers/org/bigbluebutton/web/controllers/ApiController.groovy
  1. bigbluebutton-web/grails-app/conf/spring/resources.xml
  1. bigbluebutton-web/src/groovy/org/bigbluebutton/api/IApiConferenceEventListener.groovy


**Changes on the bbb-common-message side**

Files involved:

  1. bbb-common-message/src/main/groovy/org/bigbluebutton/conference/IRoomListener.groovy
  1. bbb-common-message/src/main/groovy/org/bigbluebutton/conference/Room.groovy



**Changes on the Client side**

  1. bigbluebutton-client/src/org/bigbluebutton/main/maps/ApplicationEventMap.mxml


**Changes on the Server side (i.e. red5)
Files involved:**

  1. bigbluebutton-apps/src/main/webapp/WEB-INF/bbb-apps.xml



**Potential Problems**

  * When building the client make sure that the /tools/ directory exists otherwise the client won't build. This tends to happen if you are developing Bigbluebutton client code outside the VM environment.

  * Another problem associated with deploying the bigbluebutton-web: you have to call ‘ant war’ command for you bigbluebutton-web and then deploy the resulted war file
  1. Rename created file: bigbluebutton-0.71dev.war to bigbluebutton.war
  1. Delete file bigbluebutton.war and directory bigbluebutton under /var/lib/tomcat6/webapps/
  1. Copy the new bigbluebutton.war to /var/lib/tomcat6/webapps/
  1. Re-start the Tomcat server.

  * The current API calls doesn't include the salt value for security, this feature would (must) be integrated back for the next release.

**steps to run and use the API are described [here](http://code.google.com/p/bigbluebutton/wiki/BigBlueButtonAPIPartitioningDemo)**

_Note: Any comments or input is more welcome to improve our work_

_To be added_