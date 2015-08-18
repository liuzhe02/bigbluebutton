**Depreciated**

_This page along, with the Architecture Council, are deprecated.  The discussions for the future architecture of BigBlueButton have moved into the [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list._

_For a high-level draft roadmap for BigBlueButton's architecture, please see [Roadmap to 1.0](http://code.google.com/p/bigbluebutton/wiki/RoadMap1dot0). For information on contributing to BigBlueButton, please see [Contributing to BigBlueButton](http://code.google.com/p/bigbluebutton/wiki/FAQ#Contributing_to_BigBlueButton)._


_-- depreciated content --_


The goal of this section is to discuss candidate architectures. The structure of the section follows the [discussion of what should be at the core of the architecture](ArchitectureCore.md).

## Collaborative technologies ##

Core should focus on collaborative technologies (not just about voice).

## Plugin architecture ##

Core should be extensible through plugins.

Benefits of a plugin architecture (list started by Paul):

  * Division of core and application
  * Application delivery releases independent of the core
  * Potential items for the BBB store

Michael: The design of the plugin architecture needs account for more than deployment and administration of plugins. In my view, the core issue is to define the extension model: how do plugins extend what exists (core or other plugins), how do the core (or other plugins) define points where the behavior can be extended. If we do not make this our first priority, we end up with a mechanism to define and load modules that does not contribute to a design that is decoupled, easy to understand, and extensible by third-parties without detailed knowledge of the core nor rights to modify the core to accommodate a plugin.

Richard: I agree. I would suggest somebody extract and document interaction between server and client. I have started it here [ClientServerCommunication](ClientServerCommunication.md). And, also, someone should extract and document all events in the client. Having these list will provide us a good picture of the APIs (client to server, client/UI) and help us design an architecture that is modular, extensible, and flexible.

Michael: Thanks. That is an very helpful document. It provides a map with the major landmarks in the server code. I agree that we should also document the events in the client. We should be able to get a student interested in that. It is well-defined in scope, but adds value.

Insert description of Extension Object pattern here.

Michael: OSGI appears to address the deployment problem, but does not define an extension model per se. Yes, it helps manage dependencies, but an extension model goes beyond managing dependencies. It provides guidance on how the system can be extended. We also need to identify concrete use scenarios that define what capabilities the extension model should have. As a Java technology, OSGI can be used on the server, but how does it address the need for client-side extensibility?

Insert discussion of OSGI here. How can it be used to deploy and administer plugins? How does it manage plugin dependencies? How can OSGI be applied to the client?

Describe usage scenarios on a page of its own. We want to get input from people working on opportunities.

Michael: There are several existing extension models. For example:
  * Eclipse combines the OSGI deployment model with an extension model that allows plugin authors to expose extension points. An extension point is essentially an interface that the extension needs to implement. The model is capable but complex to implement.
  * WordPress implements a more straightforward extension model: the WordPress core defines hooks in the code where it can be extended. Extensions can be defined in terms of actions performed at hooks or filters that should be applied to intermediate outputs.
  * Other systems use an event-based extension model. The core exposes events and defines interfaces that event handlers need to implement. For example, an action such as advancing to the next slide would raise an event that triggers registered extensions.

Insert description of Eclipse extension model here.

Insert description of WordPress-style extension model here.

Insert description of event-based extension model here.

Michael: The third point raised by Paul is an important one. The plugin architecture should allow developers to publish plugins (in some form of marketplace or app store, which is something that Eclipse or WordPress have, in different forms), and users to discover them. The plugin repository (marketplace) would also be a great resource for developers: either to learn or build on top. The second point is also essential. You don't want to tie up the release of the core by plugin release schedules.

## UI separation ##

Core should support different UI delivery mechanisms (such as Flash and HTML5).

## Simplicity ##

Core should focus on unique features that differentiate BigBlueButton. Its simplicity of use is highly valued. Proposed changes to the architecture should be weighed against simplicity of use for end-users as well as developers.

## Migration ##

As the architecture evolves, current BigBlueButton deployments **must** upgrade seamlessly.

# Architecture work in the sharedNotes branch - Denis Zgonjanin #
There has been some preliminary work in the [sharedNotes](https://github.com/bigbluebutton/bigbluebutton/tree/sharedNotes) branch to work towards an extensible modular architecture. As you know, on the client it is already possible to develop and deploy modules. However it remains hard to do so on the server, as extensions need to be tightly integrated with red5. To this end, I've been working on an RTMPAdapter application for red5. In a nutshell, the RTMPAdapter is a bridge between Flash Player and other server side apps. BigBlueButton Client performs remote procedure calls to the RTMPAdapter, and they are published to Redis channels using [Redis PubSub](http://redis.io/topics/pubsub). Other server side applications can listen to specific channels to receive client data. The process works in both directions - server side apps can publish data to outbound channels. the RTMPAdapter listens to these messages and sends them to the appropriate BigBlueButton client connections.
Right now this is a working prototype, though it needs some polish. After it is done, people will be able to build fully stand-alone extensions to BigBlueButton on the server side. Following this, I would like to take the following steps:
  1. Migrate all applications within bbb-apps to stand-alone applications utilizing the RTMPAdapter.
  1. Create a BigBlueButton package manager (bbbpm), which will define a standard way for people to easily publish, install, and manage 3rd party extensions to BigBlueButton. The package manager should handle installing both the client and server sides of an extension.
  1. Create other protocol Adapters, such as a WebsocketsAdapter, an iOSAdapter, AndroidAdapter, etc... This will allow us to work on bringing the BigBlueButton experience to other platforms and technologies.
  1. Move away from red5 for VoIP. See my proposal [here](http://code.google.com/p/bigbluebutton/wiki/VoiceStability).
  1. Move away from red5 for Video. Use a server with better performance and focused on video delivery, such as [erlyvideo](https://github.com/erlyvideo/erlyvideo).
  1. After this is all done, re-write the RTMPAdapter as a stand-alone C library using [libevent](http://monkey.org/~provos/libevent/) to allow for very high performance and scalability of a single server.
  1. Remove red5 completely from BigBlueButton, as it will no longer be needed.


---

[ArchitectureCouncil](ArchitectureCouncil.md) [ArchitectureCore](ArchitectureCore.md)