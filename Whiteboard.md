**Note:** This page is now marked as depreciated.  Please see [BigBlueButton Google Code Home Page](http://code.google.com/p/bigbluebutton/) for the latest content.

## Current state ##
There is a prototype whiteboard in the client code, under package org.bigbluebutton.modules.highlighter
To enable it for testing, add the module to the conf/config.xml file in the client using standard parameters. You need to add the module to the client's build.xml as well. If you're using Flex Builder you also need to right click > project > flex modules and add it there.

## Work to be done ##
The whiteboard will eventually be integrated into the presentation module as an overlay. To do this, the window the whiteboard is currently embedded in will be removed, and the drawing canvas itself added to the presentation module. Some work needs to be done on the presentation module to accommodate adding an overlay canvas, as well as to the whiteboard itself:

  * The presentation module should ideally expose a simple API so that overlays and extra controls can be added. This would allow the whiteboard to be added without having to couple the modules together.
  * A way to distinguish between slides, so that each slide will have it's own whiteboard page. The whiteboard could in this case listen to page change events from the presentation.
  * Whiteboard 'pages' should persist between page views, so that if the presenter goes back to a previous slide anything previously drawn on the overlay will still be there
  * Whiteboard shapes should be stored on the server instead of just being pushed to clients at creation time. This allows latecomers to the presentation to see what has been drawn already.
  * Whiteboard shapes need to be scaled to the size of the presentation slides when zooming in and out.
  * The whiteboard needs to work without disrupting the existing cursor pointer functionality.