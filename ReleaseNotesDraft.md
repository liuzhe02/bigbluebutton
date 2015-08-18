# Release 0.71: Europa #

_Code named after Eurpoa, Jupiter's moon, whose surface is among the brightest in the solar system._


Released: November XX, 2010

  * **VoIP Improvements** - This was the bulk of our effort for 0.71. We improved the algorithms to handle audio packets coming to and from the BigBlueButton server. You should experience less audio lag using VoIP when compared to 0.70. (We'll let you judge the extent to which the lag has been reduced.)

> BigBlueButton 0.71 now supports FreeSWITCH as a voice conference server. This enables the BigBlueButton client to transmit either wide-band (16 kHz) Speex or the Nellymoser voice codec. In our testing so far, we found that nellymoser scales better and will remain the default voice codec in BigBlueButton.

  * **Webcam Auto-Display** - When a user shares their webcam, it automatically opens on all other users connected to the virtual classroom.

  * **Selectable area for Desktop Sharing** - The Desktop Sharing application now supports selecting the desktop are to share, in additional to supporting sharing of fullscreen.  This allows the user to select a specific window, for example, and reduces the bandwidth requirements for desktop sharing.

  * **Auto Chat Translation** - BigBlueButton's chat now uses the Google Translate API for real-time of chat messages.  This allows the user to view the chat in their native language.

  * **Client Localization** -  The user can change their locale now through a drop-down menu on-the-fly.  This also triggers a change in the locale language for automatic chat translation.

  * **Branding** - Administrators can now [skin](Branding.md) the BigBlueButton using cascading style sheets.

  * **Client Configuration** - Administrators can configure, on a server basis, specific capabilities of the BigBlueButton client.  For example, you can change the video quality, define who can share video, and allow moderators to kick users.   See [Client Configuration](ClientConfiguration.md) for the full list of configuration parameters.