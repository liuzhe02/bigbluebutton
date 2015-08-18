# Introduction #

This document will describe BigBlueButton client start-up sequence when the user joins the meeting.

We use the logs in the client to list the steps that happens when a user joins a meeting.


# Details #

Load the locales.xml file to determine what locales the sysadmin makes available to the users.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/util/i18n/ResourceUtil.as#L79


```
8/20/2012 13:20:59.010 [DEBUG] initialization
8/20/2012 13:20:59.074 [DEBUG] --- Supported locales --- 
<locales>
  <locale code="ar_SY" name="Arabic (Syria)"/>
  <locale code="az_AZ" name="Azerbaijani"/>
  <locale code="eu_EU" name="Basque"/>
  <locale code="bn_BN" name="Bengali"/>
  <locale code="bg_BG" name="Bulgarian"/>
  <locale code="zh_CN" name="Chinese (Simplified)"/>
  <locale code="zh_TW" name="Chinese (Traditional)"/>
  <locale code="hr_HR" name="Croatian"/>
  <locale code="cs_CZ" name="Czech"/>
  <locale code="da_DK" name="Danish"/>
  <locale code="nl_NL" name="Dutch"/>
  <locale code="en_US" name="English"/>
  <locale code="fa_IR" name="Farsi"/>
  <locale code="fi_FI" name="Finnish"/>
  <locale code="fr_FR" name="French"/>
  <locale code="fr_CA" name="French (Canadian)"/>
  <locale code="de_DE" name="German"/>
  <locale code="el_GR" name="Greek"/>
  <locale code="hu_HU" name="Hungarian"/>
  <locale code="id_ID" name="Indonesian"/>
  <locale code="it_IT" name="Italian"/>
  <locale code="ja_JP" name="Japanese"/>
  <locale code="ko_KR" name="Korean"/>
  <locale code="lv_LV" name="Latvian"/>
  <locale code="lt_LT" name="Lithuania"/>
  <locale code="mn_MN" name="Mongolian"/>
  <locale code="ne_NE" name="Nepali"/>
  <locale code="no_NO" name="Norwegian"/>
  <locale code="pl_PL" name="Polish"/>
  <locale code="pt_BR" name="Portuguese (Brazilian)"/>
  <locale code="pt_PT" name="Portuguese"/>
  <locale code="ro_RO" name="Romanian"/>
  <locale code="ru_RU" name="Russian"/>
  <locale code="sr_SR" name="Serbian (Cyrillic)"/>
  <locale code="sr_RS" name="Serbian (Latin)"/>
  <locale code="sl_SL" name="Slovenian"/>
  <locale code="es_ES" name="Spanish"/>
  <locale code="es_LA" name="Spanish (Latin American)"/>
  <locale code="sv_SE" name="Swedish"/>
  <locale code="th_TH" name="Thai"/>
  <locale code="tr_TR" name="Turkish"/>
  <locale code="uk_UA" name="Ukrainian"/>
  <locale code="vi_VN" name="Vietnamese"/>
</locales>
 --- 
```

Determine the preferred locale. The client tries to determine the preferred locale from the user's browser settings.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/resources/prod/lib/bbb_localization.js


If the preferred locale is not the same as the master locale, it load the master locale. The master locale is US-English (en\_US). If the preferred locale is not available, it will use the master locale.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/util/i18n/ResourceUtil.as#L85

Here it shows that the preferred local is en\_GB and is not available. Thus, it defaults to the master locale (en\_US).

```
8/20/2012 13:20:59.075 [DEBUG] Loading locale at [ locale/en_US_resources.swf?a=1345483259075 ]
8/20/2012 13:20:59.076 [DEBUG] Setting up preferred locale en_GB
8/20/2012 13:20:59.076 [DEBUG] The locale en_GB isn't available. Default will be: en_US
8/20/2012 13:20:59.078 [DEBUG] Setting up preferred locale index 11
8/20/2012 13:20:59.078 [DEBUG] Loading locale at [ locale/en_US_resources.swf?a=1345483259078 ]
```

Load the config.xml and calculate the module dependencies.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/ConfigParameters.as#L60

```
8/20/2012 13:20:59.084 [DEBUG] Dependency Order: 
8/20/2012 13:20:59.084 [DEBUG] VideoconfModule
8/20/2012 13:20:59.084 [DEBUG] ListenersModule
8/20/2012 13:20:59.084 [DEBUG] DeskShareModule
8/20/2012 13:20:59.084 [DEBUG] ViewersModule
8/20/2012 13:20:59.084 [DEBUG] LayoutModule
8/20/2012 13:20:59.084 [DEBUG] ChatModule
8/20/2012 13:20:59.084 [DEBUG] PhoneModule
8/20/2012 13:20:59.084 [DEBUG] PresentModule
8/20/2012 13:20:59.084 [DEBUG] VideodockModule
8/20/2012 13:20:59.084 [DEBUG] WhiteboardModule
```

Initialize the options passed from config.xml

```
8/20/2012 13:20:59.086 [DEBUG] ***** Config Loaded ****
8/20/2012 13:20:59.086 [DEBUG] **** Init layout options ***
8/20/2012 13:20:59.086 [DEBUG] *** show toolbar = true
```

Do some port testing. Test if we can connect using RTMP. If not, test if we can connect using RTMPT.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/modules/ModulesProxy.as#L67

```
8/20/2012 13:20:59.183 [DEBUG] Successfully connected to RTMP://192.168.0.249/video
```

Connecting using RTMP passed. Therefore, port 1935 is open.
```
8/20/2012 13:20:59.183 [DEBUG] **** Using RTMP to connect to RTMP://192.168.0.249/bigbluebutton******
```

Query bigbluebutton-web for the information about the user.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/users/JoinService.as#L48

```
8/20/2012 13:20:59.184 [DEBUG] JoinService:load(...) http://192.168.0.249/bigbluebutton/api/enter
```

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-web/grails-app/controllers/org/bigbluebutton/web/controllers/ApiController.groovy#L682

bigbluebutton-web will return the following:

```
8/20/2012 13:20:59.319 [DEBUG] Join SUCESS = <response>
  <returncode>SUCCESS</returncode>
  <fullname>fdfdf</fullname>
  <confname>Demo Meeting</confname>
  <meetingID>183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248</meetingID>
  <externUserID>yuq4tqb18qrh</externUserID>
  <internalUserID>pob1oev9ehxr</internalUserID>
  <role>MODERATOR</role>
  <conference>183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248</conference>
  <room>183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248</room>
  <voicebridge>77987</voicebridge>
  <webvoiceconf>77987</webvoiceconf>
  <mode>LIVE</mode>
  <record>false</record>
  <welcome>&lt;br&gt;Welcome to &lt;b&gt;Demo Meeting&lt;/b&gt;!&lt;br&gt;&lt;br&gt;For help on using BigBlueButton see these (short) &lt;a href="event:http://www.bigbluebutton.org/content/videos"&gt;&lt;u&gt;tutorial videos&lt;/u&gt;&lt;/a&gt;.&lt;br&gt;&lt;br&gt;To join the audio bridge click the headset icon (upper-left hand corner). &lt;b&gt;You can mute yourself in the Listeners window.&lt;/b&gt;&lt;br&gt;</welcome>
  <logoutUrl>http://192.168.0.249</logoutUrl>
</response>
```

Connect to Red5 passing the required parameters.
https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/users/NetConnectionDelegate.as#L152

```
8/20/2012 13:20:59.322 [DEBUG] NetConnectionDelegate::Connecting to RTMP://192.168.0.249/bigbluebutton/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248 [fdfdf,MODERATOR,183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248,false,183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248]
```

The request is handled in Red5 and returns success if all the parameters are valid.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-apps/src/main/java/org/bigbluebutton/conference/BigBlueButtonApplication.java#L91

```
8/20/2012 13:20:59.442 [DEBUG] NetConnectionDelegate:Connection to viewers application succeeded.
8/20/2012 13:20:59.461 [DEBUG] Successful result: 85
```

Now that we have successfully connected to Red5, load all the modules passed from config.xml

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/modules/ModuleManager.as#L172

```
8/20/2012 13:20:59.462 [DEBUG] BBBManager Loading VideoconfModule
8/20/2012 13:20:59.462 [DEBUG] Loading VideoconfModule.swf?v=VERSION
8/20/2012 13:20:59.464 [DEBUG] BBBManager Loading ListenersModule
8/20/2012 13:20:59.464 [DEBUG] Loading ListenersModule.swf?v=VERSION
8/20/2012 13:20:59.464 [DEBUG] BBBManager Loading DeskShareModule
8/20/2012 13:20:59.464 [DEBUG] Loading DeskShareModule.swf?v=VERSION
8/20/2012 13:20:59.464 [DEBUG] BBBManager Loading ViewersModule
8/20/2012 13:20:59.464 [DEBUG] Loading ViewersModule.swf?v=VERSION
8/20/2012 13:20:59.464 [DEBUG] BBBManager Loading LayoutModule
8/20/2012 13:20:59.465 [DEBUG] Loading LayoutModule.swf?v=VERSION
8/20/2012 13:20:59.465 [DEBUG] BBBManager Loading ChatModule
8/20/2012 13:20:59.465 [DEBUG] Loading ChatModule.swf?v=VERSION
8/20/2012 13:20:59.465 [DEBUG] BBBManager Loading PhoneModule
8/20/2012 13:20:59.465 [DEBUG] Loading PhoneModule.swf?v=VERSION
8/20/2012 13:20:59.465 [DEBUG] BBBManager Loading PresentModule
8/20/2012 13:20:59.465 [DEBUG] Loading PresentModule.swf?v=VERSION
8/20/2012 13:20:59.465 [DEBUG] BBBManager Loading VideodockModule
8/20/2012 13:20:59.465 [DEBUG] Loading VideodockModule.swf?v=VERSION
8/20/2012 13:20:59.466 [DEBUG] BBBManager Loading WhiteboardModule
8/20/2012 13:20:59.466 [DEBUG] Loading WhiteboardModule.swf?v=VERSION
8/20/2012 13:20:59.569 [DEBUG] Using [en_US] locale.
8/20/2012 13:20:59.569 [DEBUG] Received locale version fron locale file.
8/20/2012 13:20:59.579 [DEBUG] ListenersModulefinished loading
8/20/2012 13:20:59.579 [DEBUG] Module ListenersModule loaded.
8/20/2012 13:20:59.596 [DEBUG] ChatModulefinished loading
8/20/2012 13:20:59.596 [DEBUG] Module ChatModule loaded.
8/20/2012 13:20:59.601 [DEBUG] ViewersModulefinished loading
8/20/2012 13:20:59.601 [DEBUG] Module ViewersModule loaded.
8/20/2012 13:20:59.607 [DEBUG] VideoconfModulefinished loading
8/20/2012 13:20:59.607 [DEBUG] Module VideoconfModule loaded.
8/20/2012 13:20:59.615 [DEBUG] DeskShareModulefinished loading
8/20/2012 13:20:59.615 [DEBUG] Module DeskShareModule loaded.
```

White the modules are being loaded, query Red5 for the participants currently in the meeting.

https://github.com/bigbluebutton/bigbluebutton/blob/master/bigbluebutton-client/src/org/bigbluebutton/main/model/users/UsersSOService.as#L85

```
8/20/2012 13:20:59.685 [DEBUG] Successfully queried participants: 1
8/20/2012 13:20:59.685 [DEBUG] User status: false
8/20/2012 13:20:59.686 [INFO] Joined as [85,fdfdf,MODERATOR]
8/20/2012 13:20:59.687 [DEBUG] Received status change [85,hasStream,false]
8/20/2012 13:20:59.688 [DEBUG] Received status change [85,presenter,false]
8/20/2012 13:20:59.688 [DEBUG] Received status change [85,raiseHand,false]
```

```
8/20/2012 13:20:59.695 [DEBUG] PhoneModulefinished loading
8/20/2012 13:20:59.695 [DEBUG] Module PhoneModule loaded.
8/20/2012 13:20:59.709 [DEBUG] WhiteboardModulefinished loading
8/20/2012 13:20:59.709 [DEBUG] Module WhiteboardModule loaded.
8/20/2012 13:20:59.712 [DEBUG] VideodockModulefinished loading
8/20/2012 13:20:59.712 [DEBUG] Module VideodockModule loaded.
8/20/2012 13:20:59.721 [DEBUG] LayoutModulefinished loading
8/20/2012 13:20:59.721 [DEBUG] Module LayoutModule loaded.
8/20/2012 13:20:59.731 [DEBUG] PresentModulefinished loading
8/20/2012 13:20:59.731 [DEBUG] Module PresentModule loaded.
```

Compare if the locale versions from config.xml and the locale file are the same. This is a check if when during upgrades, the locales files are cached by the browser.

```
8/20/2012 13:20:59.731 [DEBUG] Received locale version fron config.xml
8/20/2012 13:20:59.731 [DEBUG] Comparing locale versions.
8/20/2012 13:20:59.732 [DEBUG] Locale from config=0.8, from locale file=0.8
```

Once all the modules are loaded, start the modules.

```
8/20/2012 13:20:59.732 [DEBUG] Sending start all modules event
```

Start the video/webcam module.
```
8/20/2012 13:20:59.732 [DEBUG] Starting module VideoconfModule
8/20/2012 13:20:59.732 [DEBUG] VideoconfModule uri = RTMP://192.168.0.249/video
8/20/2012 13:20:59.732 [DEBUG] Videoconf attr: fdfdf
8/20/2012 13:20:59.738 [DEBUG] Starting module ListenersModule
```

Connect to the video appliecation.
```
8/20/2012 13:20:59.738 [DEBUG] ListenersModule uri = RTMP://192.168.0.249/bigbluebutton
```

Start all the other modules.
```
8/20/2012 13:20:59.824 [DEBUG] [ListenersSOService]:Voice is connected to Shared object
8/20/2012 13:20:59.825 [DEBUG] [ListenersSOService]notifying connectionListener for Voice
8/20/2012 13:20:59.825 [DEBUG] LISTENER-ROLE:MODERATOR
8/20/2012 13:20:59.825 [DEBUG] Starting module DeskShareModule
8/20/2012 13:20:59.825 [DEBUG] DeskShareModule uri = RTMP://192.168.0.249/deskShare
8/20/2012 13:20:59.826 [DEBUG] desk share attr: fdfdf
8/20/2012 13:20:59.826 [DEBUG] PublishWindowManager init
8/20/2012 13:20:59.827 [DEBUG] Deskshare Module starting
8/20/2012 13:20:59.827 [DEBUG] Deskshare Module starting
8/20/2012 13:20:59.828 [DEBUG] Deskshare Service connecting to RTMP://192.168.0.249/deskShare/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248
8/20/2012 13:20:59.829 [DEBUG] Starting module ViewersModule
8/20/2012 13:20:59.829 [DEBUG] ViewersModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:20:59.829 [DEBUG] Passed ViewersModule mode: undefined
8/20/2012 13:20:59.908 [DEBUG] Starting module LayoutModule
8/20/2012 13:20:59.908 [DEBUG] LayoutModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:20:59.927 [DEBUG] LayoutManager: loading server layouts from conf/layout.xml
8/20/2012 13:20:59.928 [DEBUG] Starting module ChatModule
8/20/2012 13:20:59.928 [DEBUG] ChatModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:20:59.928 [DEBUG] chat attr: fdfdf
8/20/2012 13:20:59.928 [DEBUG] Dispatching StartChatModuleEvent
8/20/2012 13:20:59.932 [DEBUG] Starting module PhoneModule
8/20/2012 13:20:59.932 [DEBUG] PhoneModule uri = RTMP://192.168.0.249/sip
8/20/2012 13:20:59.932 [DEBUG] phone attr: fdfdf
8/20/2012 13:20:59.935 [DEBUG] Starting module PresentModule
8/20/2012 13:20:59.935 [DEBUG] PresentModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:20:59.935 [DEBUG] present attr: fdfdf
8/20/2012 13:21:00.042 [DEBUG] PresentSOService: PresentationModule is connected to Shared object
8/20/2012 13:21:00.042 [DEBUG] Starting module VideodockModule
8/20/2012 13:21:00.042 [DEBUG] VideodockModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:21:00.042 [DEBUG] Videodock attr: fdfdf
8/20/2012 13:21:00.085 [DEBUG] Starting module WhiteboardModule
8/20/2012 13:21:00.085 [DEBUG] WhiteboardModule uri = RTMP://192.168.0.249/bigbluebutton
8/20/2012 13:21:00.085 [DEBUG] highlighter attr: fdfdf
8/20/2012 13:21:00.094 [DEBUG] ******************* Received loggedin event
8/20/2012 13:21:00.094 [DEBUG] ******************* Received loggedin event true
8/20/2012 13:21:00.132 [DEBUG] LayoutsLoader: completed, parsing...
8/20/2012 13:21:00.134 [DEBUG] LayoutManager: layouts loaded successfully
8/20/2012 13:21:00.144 [DEBUG] Received status change [85,presenter,true]
```

Check if another user is sharing their desktop. We do this so that latecomers are able to view the presenter's desktop.

```
8/20/2012 13:21:00.185 [DEBUG] Successully connection to RTMP://192.168.0.249/deskShare/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248
8/20/2012 13:21:00.185 [DEBUG] checking if desk share stream is publishing
```

See how many users are in the meeting. And if the user if the first one make the user the presenter.

```
8/20/2012 13:21:00.186 [DEBUG] Successfully queried participants: 0
8/20/2012 13:21:00.187 [DEBUG] assignPresenterCallback 85,fdfdf,1
8/20/2012 13:21:00.187 [DEBUG] Got MadePresenterEvent 
8/20/2012 13:21:00.187 [DEBUG] DeskShare::addToolbarButton
```

Query for chat messages. This is for the latecomer to display previous chat messages.
```
8/20/2012 13:21:00.293 [DEBUG] Get transcript message: 
```

Query for the current presentation slide. Again, this is for the latecomer to sync with others on the presentation.
```
8/20/2012 13:21:00.293 [DEBUG] !!!!! Presentation sync handler - 1
8/20/2012 13:21:00.293 [DEBUG] Query for slide info
```

Determined that no desktop is being shared.
```
8/20/2012 13:21:00.345 [DEBUG] No deskshare stream being published
```

Got the chat history.

```
8/20/2012 13:21:00.346 [DEBUG] Successfully sent get transcript message: 
8/20/2012 13:21:00.346 [DEBUG] Sending transcript loaded Event
8/20/2012 13:21:00.346 [DEBUG] Handling TranscriptLoadedEvent
8/20/2012 13:21:00.350 [DEBUG] Successfully querried for presentation information.
8/20/2012 13:21:00.350 [DEBUG] Got MadeViewerEvent 
8/20/2012 13:21:00.351 [DEBUG] Presentation name default
8/20/2012 13:21:00.351 [DEBUG] Adding presentation default
8/20/2012 13:21:00.352 [DEBUG] Presentation name default
8/20/2012 13:21:00.352 [DEBUG] Adding presentation default
8/20/2012 13:21:00.352 [DEBUG] trigger Switch to Presenter mode 
8/20/2012 13:21:00.352 [DEBUG] Got MadePresenterEvent 
8/20/2012 13:21:00.352 [DEBUG] DeskShare::addToolbarButton
```

Now display the current slide.

```
8/20/2012 13:21:00.353 [DEBUG] The presenter has shared slides and showing slide 0
8/20/2012 13:21:00.353 [DEBUG] PresentProxy::loadPresentation: presentationName=default
8/20/2012 13:21:00.353 [DEBUG] PresentationApplication::loadPresentation()... http://192.168.0.249/bigbluebutton/presentation/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/default/slides
8/20/2012 13:21:00.353 [INFO] '97A22692-F240-180E-A6D5-450D41C186B3' producer set destination to 'DefaultHTTP'.
8/20/2012 13:21:00.354 [DEBUG] number of slides=0
8/20/2012 13:21:00.355 [DEBUG] Rx Query for slide info
8/20/2012 13:21:00.355 [DEBUG] User Query for slide info
8/20/2012 13:21:00.375 [DEBUG] Rx whatIsTheSlideInfoReply
8/20/2012 13:21:00.375 [DEBUG] Got reply for Query for slide info
8/20/2012 13:21:00.465 [DEBUG] Loading complete
8/20/2012 13:21:00.465 [DEBUG] Slides: <conference id="183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248" room="183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248">
  <presentation name="default">
    <slides count="1">
      <slide number="1" name="slide/1" thumb="thumbnail/1" textfile="textfile/1"/>
    </slides>
  </presentation>
</conference>
8/20/2012 13:21:00.466 [DEBUG] PresentationService::parse()...  presentationName=default
8/20/2012 13:21:00.466 [DEBUG] Available textfile: http://192.168.0.249/bigbluebutton/presentation/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/default/textfile/1
8/20/2012 13:21:00.466 [DEBUG] presentation has been loaded  presentationName=default
8/20/2012 13:21:00.468 [DEBUG] PresentationSOService::sharePresentation()... presentationName=default
8/20/2012 13:21:00.481 [DEBUG] Successfully sent [whiteboard.setActivePresentation].
8/20/2012 13:21:00.482 [DEBUG] sharePresentationCallback default,true
8/20/2012 13:21:00.482 [DEBUG] PresentProxy::loadPresentation: presentationName=default
8/20/2012 13:21:00.482 [DEBUG] PresentationApplication::loadPresentation()... http://192.168.0.249/bigbluebutton/presentation/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/default/slides
8/20/2012 13:21:00.482 [INFO] '798AD3CE-676B-D525-91FB-450D424240C7' producer set destination to 'DefaultHTTP'.
8/20/2012 13:21:00.482 [DEBUG] number of slides=1
8/20/2012 13:21:00.592 [DEBUG] Loading complete
8/20/2012 13:21:00.592 [DEBUG] Slides: <conference id="183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248" room="183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248">
  <presentation name="default">
    <slides count="1">
      <slide number="1" name="slide/1" thumb="thumbnail/1" textfile="textfile/1"/>
    </slides>
  </presentation>
</conference>
8/20/2012 13:21:00.592 [DEBUG] PresentationService::parse()...  presentationName=default
8/20/2012 13:21:00.592 [DEBUG] Available textfile: http://192.168.0.249/bigbluebutton/presentation/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/183f0bf3a0982a127bdb8161e0c44eb696b3e75c-1345483284248/default/textfile/1
8/20/2012 13:21:00.592 [DEBUG] presentation has been loaded  presentationName=default
```

Set-up the whiteboard and layout modules.

```
8/20/2012 13:21:00.607 [DEBUG] Successfully sent [whiteboard.setActivePresentation].
8/20/2012 13:21:00.703 [DEBUG] LayoutsCombo: view initialized
8/20/2012 13:21:00.706 [DEBUG] LayoutsCombo: populating list
8/20/2012 13:21:00.767 [DEBUG] LayoutService: layoutSO connection established
```

Overlay the whiteboard on top of the presentation display. Query for the whiteboard history so that the latecomer is able to sync the whiteboard annotations.

```
8/20/2012 13:21:01.113 [DEBUG] OVERLAYING WHITEBOARD CANVAS
8/20/2012 13:21:01.215 [DEBUG] Successfully sent [whiteboard.requestAnnotationHistory].
8/20/2012 13:21:01.216 [DEBUG] handleRequestAnnotationHistoryReply: No annotations.
8/20/2012 13:21:01.579 [DEBUG] LayoutService: handling the first layout
8/20/2012 13:21:03.579 [DEBUG] Successfully sent [whiteboard.setActivePage].
8/20/2012 13:21:03.629 [DEBUG] Successfully sent [whiteboard.requestAnnotationHistory].
8/20/2012 13:21:03.629 [DEBUG] handleRequestAnnotationHistoryReply: No annotations.
```