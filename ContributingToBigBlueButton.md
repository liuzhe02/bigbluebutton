# Introduction #

This page is now depreciated and has been merged into the FAQ.  See:  [Contributing to BigBlueButton](http://code.google.com/p/bigbluebutton/wiki/FAQ#Contributing_to_BigBlueButton)

DRAFT: How to contribute to BigBlueButton

## Background ##
The success of the BigBlueButton project is a direct result of the efforts of many developers who have contributed their time and skills to improving BigBlueButton.

BigBlueButton is not a small open source project, nor is it a simple one to master.  There are many components, interfaces, and [fifteen](http://code.google.com/p/bigbluebutton/wiki/OpenSourceComponents) other open source components that all work together to create (what we hope is) a simple web conferencing system.  Like many open source projects, at the core is small group of developers that have commit rights and responsibilities for the overall quality of the project.

These committers are

  * Richard Alam, Lead Architect
  * Denis Zgonjanin, Client
  * Fred Dixon, Packaging
  * Jeremy Thomerson, API
  * Tiago Jacobs, red5

The committers welcomes the contribution of other developers, as visible by our efforts to cultivate and nurture contributions from others in our [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list and by Google accepting BigBlueButton into the 2010 Google Summer of Code.

The committer's group is not closed.  Any developer that wishes to become a
committer can achieve it through participation.  The decision of expanding the committers group rests with the committers.

Any code submitted for inclusion into BigBlueButton must be reviewed an approved by a committer.

The process for submission and review depends on the complexity of the contribution.

## Small changes (a few lines of code) ##
Sometimes you just see a few lines of code that need to be fixed.  If you do, you can highlight the lines with a post to bigbluebutton-dev, such as  [quick whiteboard fix](http://groups.google.com/group/bigbluebutton-dev/browse_thread/thread/0ea2eef3f7bdfd37#), or posting of the lines of code in the associated issue.

Another example is the submission of an updated language file.

All the committers watch the mailing list and issue tracker closely, and you submission will be reviewed.


## Submission of a patch ##
If you have made a change to the code base and want to contribute it, your chances of acceptance are **greatly** improved the following are true.

  1. You are an active participant in bigbluebutton-dev and have demonstrated an understanding of the product by helping others and participating in discussions on other patches
  1. Your patch fixes an [open issue](http://code.google.com/p/bigbluebutton/wiki/IssuesInstructions?tm=3) in our Issue tracker.
  1. Before submitting your patch, you announced your intent to bigbluebutton-dev and invited discussion from others
  1. You have received positive feedback from a committer on your intent


The ideal patch submission has all the above true, which essentially you have built a relationship of trust with other BigBlueButton developers and have been visible on your willingness to contribute your skills to the project.

There are a number of items that are **must haves**.

  1. You have forked BigBlueButton on GitHub and submitted the patch as a pull request (this makes it **much** easier for a committer to review and incorporate your patch)
  1. You have signed a [committers agreement](http://code.google.com/p/bigbluebutton/wiki/FAQ#How_do_I_contribute_my_updates_to_BigBlueButton_?) so there is no ambiguity that your contributions may be released under an open source license.

## Submission of a feature ##
Some of the items in our issue tracker are enhancements to the core product.  If you are interested in contributing an enhancement, your want to do the following.

  1. You have had patches accepted by a committer
  1. You have posted a Request for Comments (RFC) to the bigbluebuton-dev mailing list that provides a detailed overview of the design and implementation of your feature.  For examples see: [RFC for Preupload of Documents](http://groups.google.com/group/bigbluebutton-dev/browse_thread/thread/d36ba6ff53e4aa79/91de48842ae1ea75?lnk=gst&q=rfc#91de48842ae1ea75)
  1. A committer has signaled their intent to work closely with you on the feature

Like other open source projects, the participation of a committer is central to the above process as they will take the responsibility for reviewing and signing off on your contribution.


# Process Details #

## Use Git to submit a patch ##

  1. [Fork](http://help.github.com/fork-a-repo/) BigBlueButton on [GitHub](http://www.github.com/bigbluebutton)
  1. Create a topic branch - `git checkout -b my_branch`
  1. Push to your branch - `git push origin my_branch`
  1. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch

References:
  1. http://help.github.com/
  1. http://progit.org/

## Providing Tests ##
Depending on the complexity of your patch or feature, it should be accompanied by tests cases or, at minimum, a series of steps to test the code is functioning properly.

We are continuously trying to incorporate more automated testing into BigBlueButton development process, such as using [TestNG](http://testng.org/doc/index.html).

We know that the most important part of any submission is the ability for others to test that it works correctly.   Any documentation, sample code, or unit tests that you can provide will greatly reduce the effort of the committer to review your submission.


## Use a Coding Convention ##
Take a look at the existing code in BigBlueButton and follow it as an examples of how you should write your code.

For code written in Java, we will follow the [Java Coding Convention](http://www.oracle.com/technetwork/java/codeconvtoc-136057.html) with minor changes. We will be documenting those changes in this wiki.

## Document your Code ##

Methods, especially those classes that provides an API, should be documented  using the [JavaDoc](http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html) format. This way we as part of running !Hudson CI, we will generate the docs.

For !Flex/ActionScript code, follow the [AsDoc](http://livedocs.adobe.com/flex/3/html/help.html?content=asdoc_1.html) format.