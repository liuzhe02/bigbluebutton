**Depreciated**

_This page along, with the Architecture Council, are deprecated.  The discussions for the future architecture of BigBlueButton have moved into the [bigbluebutton-dev](http://groups.google.com/group/bigbluebutton-dev/topics?gvc=2) mailing list._

_For a high-level draft roadmap for BigBlueButton's architecture, please see [Roadmap to 1.0](http://code.google.com/p/bigbluebutton/wiki/RoadMap1dot0). For information on contributing to BigBlueButton, please see [Contributing to BigBlueButton](http://code.google.com/p/bigbluebutton/wiki/FAQ#Contributing_to_BigBlueButton)._


_-- depreciated content --_

The discussion on what should be at the core of the architecture evolves around two sets of considerations. On the one hand,

  * Core should focus on collaborative technologies (not just about voice)
    * Towards this end, need [stable voice](VoiceStability.md) first (migration to SIP at endpoints), then stable video
  * Core should be extensible through plugins
    * Plugin architecture about more than APIs (eg administration, deployment, versioning, sandboxing)
    * Initial guidance on plugins should come from opportunities
  * Core should support different UI delivery mechanisms (such as Flash and HTML5)
    * Emergent market for BigBlueButton on pads

On the other hand,

  * Core should focus on unique features that differentiate BigBlueButton
    * Should aim to incorporate non-core features from best-of-breed implementations
    * A poll of the architecture council members revealed that they valued the simplicity of use most

What goals are we missing?


---

[ArchitectureCouncil](ArchitectureCouncil.md) [UniqueDifferentiators](UniqueDifferentiators.md)