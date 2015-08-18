# Objective #

This aspect of BBB is to be designed to make it seamless to convert wiki pages or for that matter any html page to pdf presentation style slides.

# Background #

There has always been a need to for a more interactive lecture experience. Part of this experience giving the students a chance to make additions and corrections to lecture slides. The introduction of wiki pages made al this possible. But just before a lecture comes the issue where the professor has to edit his current slide set to conform to the content and alterations of the wiki page. Wouldn't it be nice if all this could be done the mere click of a button.

In a fast technologically advancing world like ours, going online for information now becoming the choice over looking through books. In such professors and other lectures now hold information online about their research. Wouldn't it be great to extend this web content to include lecture notes without having to draft lecture slides before a lecture.

This aspect of BBB makes all this possible.

# Introduction #

This application converts any HTMLpage to pdf slides.

# Features and Requirements #


# Issues #
#cannot convert encripted pages

possible solution:-
In WTPClient class, after getting the url from the user, do a system run of LYNX or any other command line text web browser, giving it the URL as an argument. this will download the page as a html file and all pictures associated with the page onto the server in a constant folder.
After this the html file should be completely read in as a string or string from the file.
This way we would eliminate the need to build a tcp connection with the url's server and will also solve the next problem of downloading images.

NOTE:- the biggest fallback to this solution is scalability.

#having trouble getting images from web pages

possible solution:- same as above

#cannot extract tables because some web developers use table tags to divide pages instead of using <div>

possible solution:-<br>
In String preGeneratePres(String html) method in the HTMLtoPDF class, before doing anything count the number of tokens or characters within the body tag and record it. when a table tag is found, count how many tokens or characters within the table tag. if the two counts are very similar then the table tag was just use to divide the screen otherwise its a proper table and should be displayed in the slides.<br>
<br>
<h1>instructions</h1>

- download bbb.zip from the downloads tab.<br>
- unzip it<br>
<b>must</b> - open the WTPClient class and change the port from 1026 to 80 or 8080.<br>
- run WTPClient from command line giving a url as a single argument.<br>
<br>
<h1>editing</h1>

eclipse<br>
- add iText-2.1.5.jar found in the bbb folder as an external build path.<br>
<br>
<h1>Design Decisions</h1>

<b>Why PDF?</b>
<blockquote>- The BBB's Red5 server already had a scheme for taking PDF files and converting them to SWF for display.</blockquote>

<b>Converting from HTML</b>
- It was initially wanted for the conversion to be from wiki markups. The problems associated with this would be vast variety of wiki mark ups out there, and the ever increasing tags associated with them. being that wiki markups are displayed as Hypertext in web pages anyway it was better to just convert from hypertext.<br>
An upside to this decision is now we can convert any webpage not just wiki pages.<br>
<br>
<b>Breaking up the conversion process</b>


<b>Why iText?</b>


<b>Why convert to an intermediary format?</b>


<b>Why not use HTML Tags in intermediary format?</b>


<b>Why a log file?</b>

<h1>March 3, 2004</h1>
Here are some findings when taking a closer look at the wiki syntax.<br>
<br>
<h2>Experimentation with Wiki Syntax</h2>

The question is should we convert text from wiki markup to slides, or from HTML to slides?<br>
<br>
<h3>Google Code</h3>
To experiment, let's look at a very simple wiki markup (this is the sample Wiki text given in Google Code).<br>
<br>
<pre><code>#summary One-sentence summary of this page.<br>
<br>
= Introduction =<br>
<br>
Add your content here.<br>
<br>
<br>
= Details =<br>
<br>
Add your content here.  Format your content with:<br>
  * Text in *bold* or _italic_<br>
  * Headings, paragraphs, and lists<br>
  * Automatic links to other wiki pages<br>
</code></pre>

Here's the HTML output (after running through tidy -i) from Google Code:<br>
<br>
<pre><code>  &lt;h1&gt;&lt;a name="Introduction"&gt;Introduction&lt;/h1&gt;<br>
<br>
  &lt;p&gt;Add your content here.&lt;/p&gt;<br>
<br>
  &lt;h1&gt;&lt;a name="Details"&gt;Details&lt;/h1&gt;<br>
<br>
  &lt;p&gt;Add your content here. Format your content with:&lt;/p&gt;<br>
<br>
  &lt;ul&gt;<br>
    &lt;li&gt;Text in &lt;strong&gt;bold&lt;/strong&gt; or &lt;i&gt;italic&lt;/i&gt;&lt;/li&gt;<br>
<br>
    &lt;li&gt;Headings, paragraphs, and lists&lt;/li&gt;<br>
<br>
    &lt;li&gt;Automatic links to other wiki pages&lt;/li&gt;<br>
  &lt;/ul&gt;<br>
<br>
</code></pre>

<h3>TikiWiki</h3>

The output from Google Code looks OK; however, if we try pasting the same wiki markup into TikiWiki, the markup is not recognized:<br>
<br>
<pre><code>  &lt;div class="wikitext"&gt;<br>
    &lt;ol&gt;<br>
      &lt;li&gt;summary One-sentence summary of this page.&lt;/li&gt;<br>
    &lt;/ol&gt;&lt;br&gt;<br>
    = Introduction =&lt;br&gt;<br>
    &lt;br&gt;<br>
    Add your content here.&lt;br&gt;<br>
    &lt;br&gt;<br>
    &lt;br&gt;<br>
    = Details =&lt;br&gt;<br>
    &lt;br&gt;<br>
    Add your content here. Format your content with:&lt;br&gt;<br>
    * Text in *bold* or _italic_&lt;br&gt;<br>
    * Headings, paragraphs, and lists&lt;br&gt;<br>
    * Automatic links to other wiki pages&lt;br&gt;<br>
  &lt;/div&gt;<br>
<br>
</code></pre>

The problem is most of the Google Code's Wiki markup is not being recognized by TikiWiki.  So, if we first convert the markup into TikiWiki's syntax, here's how it looks:<br>
<br>
<pre><code>#summary One-sentence summary of this page.<br>
<br>
! Introduction <br>
<br>
Add your content here.<br>
<br>
<br>
! Details <br>
<br>
Add your content here.  Format your content with:<br>
* Text in __bold__ or ''italic''<br>
* Headings, paragraphs, and lists<br>
* Automatic links to other wiki pages<br>
</code></pre>

Now, pasting this converted markup into TikiWiki, we get the following similar HTML output (again cleaned up a bit with tidy -i).<br>
<br>
<pre><code>  &lt;div class="wikitext"&gt;<br>
    &lt;ol&gt;<br>
      &lt;li&gt;summary One-sentence summary of this page.&lt;/li&gt;<br>
    &lt;/ol&gt;&lt;br&gt;<br>
<br>
    &lt;h2 class="showhide_heading" id="_Introduction"&gt;<br>
    Introduction&lt;/h2&gt;&lt;br&gt;<br>
    Add your content here.&lt;br&gt;<br>
    &lt;br&gt;<br>
    &lt;br&gt;<br>
<br>
    &lt;h2 class="showhide_heading" id="_Details"&gt;Details&lt;/h2&gt;&lt;br&gt;<br>
    Add your content here. Format your content with:&lt;br&gt;<br>
<br>
    &lt;ul&gt;<br>
      &lt;li&gt;Text in &lt;b&gt;bold&lt;/b&gt; or &lt;i&gt;italic&lt;/i&gt;&lt;/li&gt;<br>
<br>
      &lt;li&gt;Headings, paragraphs, and lists&lt;/li&gt;<br>
<br>
      &lt;li&gt;Automatic links to other wiki pages&lt;/li&gt;<br>
    &lt;/ul&gt;<br>
  &lt;/div&gt;<br>
</code></pre>

This output from TikiWiki is similar to the output from Google Code's wiki.<br>
<br>
<h2>Comments</h2>
One problem is the diversity of wiki syntax: there is no common standard between the multitude of wiki engines.<br>
<br>
Another problem is the HTML output, which is a bit more standard but, as show above, has variations.<br>
<br>
<h3>Next steps</h3>
The HTML outputs may have more in common than the source wiki syntax.<br>
<br>
To explore this, do the following:<br>
<ol><li>Create an account on the TalentFirst Wiki and Wikipedia<br>
</li><li>Look at slides 1-7, 18, 30 (nine pages all together) from Tony's presentation <a href='http://www.talentfirstnetwork.org/wiki/images/7/73/Ecosystem_approach_to_commercialization_March_28v10.pdf'>http://www.talentfirstnetwork.org/wiki/images/7/73/Ecosystem_approach_to_commercialization_March_28v10.pdf</a></li></ol>

Using these nine pages as a baseline:<br>
<ol><li>encode them into TikiWiki Format (you can create a sample page on Talent First Network wiki)<br>
</li><li>encode them into Google Code Wiki<br>
</li><li>encode them into MediaWiki (use wikipedia)</li></ol>

Once you've encoded them:<br>
<ol><li>Compare the output HTML from each of the wiki engines<br>
</li><li>Comment on your approach to parsing the HTML output.<br>
</li><li>Take a look at subversion and check in your code to a branch<br>
</li><li>Check out lynx (or curl) to download all components of a web page</li></ol>

Put your finds at the bottom of this page.<br>
<br>
<h3>Links</h3>

<ul><li>TikiWiki syntax: <a href='http://tikiwiki.org/tiki-index.php?page=RFCWiki'>http://tikiwiki.org/tiki-index.php?page=RFCWiki</a>
</li><li>Wikipedia markup: <a href='http://en.wikipedia.org/wiki/Wikipedia:Cheatsheet'>http://en.wikipedia.org/wiki/Wikipedia:Cheatsheet</a>
</li><li>HTML2Wiki converter: <a href='http://search.cpan.org/~diberri/HTML-WikiConverter-0.68/lib/HTML/WikiConverter.pm'>http://search.cpan.org/~diberri/HTML-WikiConverter-0.68/lib/HTML/WikiConverter.pm</a>
</li><li>HTML tidy: <a href='http://tidy.sourceforge.net/'>http://tidy.sourceforge.net/</a>