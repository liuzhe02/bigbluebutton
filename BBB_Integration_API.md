# NOTE: This page is a DRAFT. #

# Introduction #

This wiki gives a sample implementation of the API for integrating BigBlueButton with other application. The intent is to create a simple API that enables external applications to use GET requests to  implement common integration scenarios, such as joining a conference.

# API #

## Creating a Conference ##
Request BigBlueButton to create a conference with a given ID.

Params:
  * id: Numeric ID of a conference to create

Example:
```
http://192.168.0.182/bigbluebutton/api/conference/create?id=85115
```

This request returns back an XML file that contains security tokens that can be used to join the session.

  * moderatorToken - Use this token to join as moderator
  * viewerToken - Use this token to join as viewer

Example:
```
  <response>
    <returncode>SUCCESS</returncode>
    <voiceBridge>85115</voiceBridge>
    <moderatorToken>57c05fcb-1005-454c-b5f0-ccdf6b8fd501</moderatorToken>
    <viewerToken>ede35174-bf99-433d-af68-fc64fd325dd6</viewerToken>
  </response>
```

Note: You can try this on the command line using curl.  To return XML

```
curl --verbose --request GET http://192.168.0.182/bigbluebutton/api/conference/create?id=85115
```

To return JSON

```
curl --verbose --request GET http://192.168.0.182/bigbluebutton/api/conference/create.json?id=85115
```

## Join a conference ##
This GET request from within a browser will automatically join join the user into the conference ID associated with the given token.

Params:
  * fullname: Participant's display name
  * authToken: moderator or viewer token

Example:

Suppose you obtained a security token from 182.168.0.192 of `ede35174-bf99-433d-af68-fc64fd325dd6` for viewer using the above API.  Then pasting the following URL into your browser (or returning it as a redirect to a browser request) will log the user into the conference 85115 as viewer.

```
http://192.168.0.182/bigbluebutton/api/conference/join?fullname=Richard%20Alam&authToken=f5ef7abd-b4ef-4ac2-94e8-21ece247d30e
```


# Sample Code #
## Example of creating a conference and joining that conference ##

If you checkout the latest developer version of BigBlueButton from trunk (see [how to use the developer archive](http://groups.google.com/group/bigbluebutton-dev/browse_thread/thread/b8d4a240e24a89b3#), this version has a sample page that demonstrates the above API.

Open the URL:
```
http://<host>/bigbluebutton/demo.html
```

Here's what the page looks like

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb-api-example1.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/bbb-api-example1.png)

You can enter your name for moderator, for example, and click the button 'Join as Moderator'.

**How it works**

  1. When the page gets loaded, a request (json) is sent to create the conference.
  1. When the response comes in, the values of the authToken hidden fields are changed with values for moderator and viewer tokens.
  1. The user enter's there name in the field for moderator or viewer then click Join.
  1. The user is then logged in and redirected into the BBB client to start up.

```
 <html>                                                                  
 <head>                                                                  
 <script type="text/javascript" src="/bigbluebutton/js/jquery-1.3.1.js"></script>          
 <script type="text/javascript">                                         
    $(document).ready(function() {   	
    	// alert("Hello world! ");
   	 	$.get("/bigbluebutton/api/conference/create.json", { id: "85115"},
  			function(data){
    			// alert("Data Loaded: " + data.voiceBridge + " " + data.moderatorToken + " " + data.viewerToken);
    			
    			$("div:first").text(data.moderatorToken);
    			$("div:last").text(data.viewerToken);
    			$("input:first").val(data.moderatorToken);
    			$("input:last").val(data.viewerToken);
  			}, "json"
  		);  		
 	});   
 		
                               
 </script>                                                               
 </head>                                                                 
 <body>                                                                  
   <h1>BigBlueButton Demo API Page</h1> 
   <form action="/bigbluebutton/api/conference/join.html" method="get"> 
   <!-- IMPORTANT: Make this input the first one as script above relies on it's position to assign the moderatorToken value --> 
   <input type="hidden" name="authToken" value="" /> 
    <table> 
      <tbody> 
        <tr> 
          <td>Enter your name:</td> 
          <td><input type="text" name="fullname" value="" /></td> 
        </tr> 
        <tr> 
          <td /> 
          <td><input type="submit" value="Join as moderator" /></td> 
        </tr> 
      </tbody> 
    </table> 
  </form>    
     <form action="/bigbluebutton/api/conference/join.html" method="get"> 
     
    <table> 
      <tbody> 
        <tr> 
          <td>Enter your name:</td> 
          <td><input type="text" name="fullname" value="" /></td> 
        </tr> 
        <tr> 
          <td /> 
          <td><input type="submit" value="Join as viewer" /></td> 
        </tr> 
      </tbody> 
    </table> 
    <!-- IMPORTANT: Make this input the last one as script above relies on it's position to assign the viewerToken value --> 
    <input type="hidden" name="authToken" value="" /> 
  </form>       
moderatorToken:<div></div> 
viewerToken:<div></div>                           
<p /> 
(the above tokens were created using a request to /bigbluebutton/api/conference/create.json?id=85115)
 </body>                                                                 
 </html> 
```


### Feedback welcome ###
Note (2009-09-25): This API is under active development, so your feedback is welcome.