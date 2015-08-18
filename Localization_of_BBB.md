# DRAFT #
**NOTE: This is still a draft**

# Overview #

BigBlueButton localization follows the i18n standard. BigBlueButton Client will recognize the language of the browser running it and attempt to load that language. Language files are compiled into swf files and loaded dynamically based on the browser language. This reduces the size of the client. Language codes follow the convention of a two letter lowercase language name, followed by an underscore, followed by two upper-case latters signifying the country code. So for example the default english for the United States would be: **en\_US**

![http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/I18N.png](http://bigbluebutton.googlecode.com/svn/trunk/bbb-images/I18N.png)

# Supported Language #
  * English, en\_US
  * French, fr\_FR
  * Simplified Chinese, zh\_CN

# Translating BigBlueButton into your language #
If you would like to translate BigBlueButton to another language, the first thing you need to do is download the template [file](http://bigbluebutton.googlecode.com/files/bbbResources.properties). Open this file with a text editor, and translate the english text into your language.

## Contributing the new language back to BigBlueButton ##
After you're done translating, you can contribute your language back to BigBlueButton, and we will include it into the project. Send the translated language file to the BigBlueButton [developers mailing list](http://groups.google.com/group/bigbluebutton-dev).

## Compiling your own language files into your client ##
If you created a custom language file but do not wish to contribute back to the project, here are the instructions on how to compile the language files yourself:
Put the template file into a new folder. The folder name should follow the language code convention stated above for the language/country the language file is written for. Put the folder under bigbluebutton-client/locale.
The file will be loaded whenever the user's broswer is set to that language/country code. Optionally, you could overwrite the english language files if you think that most of your users are running english language broswers, but would still like them to load a specific language.
Next, on the client you need to edit the class org.bigbluebutton.util.i18n.ResourceUtil . There you will find an array containing the language codes for supported languages. Add your language here.
Finally you will need to edit the build.xml file in the bigbluebutton-client root directory. Edit the _localization_ task to include your language files. Just follow the examples already there. For example, the to compile french the tag 

&lt;compileLocale locale="fr\_FR" /&gt;

 is included in the task. Once you are done editing the file, you need to run that ant localization task in order for the language file to be turned into an .swf file. You can run the task directly from Flex if you have ant setup, or from command line by going to the client folder and running
```
   ant localization
```
Refer to the [FAQ](http://code.google.com/p/bigbluebutton/wiki/FAQ#My_client_fails_at_startup_with_RSL_error;_Error_2035:URL_Not_Fo) if you have problems with Ant and Flex