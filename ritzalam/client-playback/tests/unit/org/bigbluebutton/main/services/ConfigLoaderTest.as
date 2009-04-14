package org.bigbluebutton.main.services
{
	import net.digitalprimates.fluint.tests.TestCase;

	public class ConfigLoaderTest extends TestCase
	{
		private var xmlString:String = 
			'<modules>' + 
			'<module name="ChatModule" url="ChatModule.swf" />' +
			'<module name="PresentationModule" url="PresentationModule.swf" />' +
			'<module name="VideoModule" url="VideoModule.swf" />' +
			'<module name="VoiceModule" url="VoiceModule.swf" />' +
			'</modules> '
		
		private var xml:XML = new XML(xmlString);
		
		private var confLoader:ConfigLoader;
		
		override protected function setUp():void {
			confLoader = new ConfigLoader(); 
		}
		
		public function testParseConfig():void {
			confLoader.parse(xml);
			assertEquals(4, confLoader.numberOfModules);
		}
	}
}