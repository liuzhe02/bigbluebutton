package org.bigbluebutton.main.services
{
	import net.digitalprimates.fluint.tests.TestCase;

	public class ModeInitializerTest extends TestCase
	{
		private var init:ModeInitializer;
		
		override protected function setUp():void {
			init = new ModeInitializer(); 
		}
		
		public function testLiveMode():void {
			var mode:String = init.queryMode("http://localhost:8080/client?mode=LIVE");
			assertEquals( mode, 'LIVE' );        
		} 
		
		public function testPlaybackMode():void {
			var mode:String = init.queryMode("http://localhost:8080/client?mode=PLAYBACK");
			assertEquals( mode, 'PLAYBACK' );        
		} 
		
		public function testLiveIsDefaultMode():void {
			var mode:String = init.queryMode("http://localhost:8080/client?mode=FOO");
			assertEquals( mode, 'LIVE' );        
		} 
		
		public function testLiveIsDefaultModeWhenThereAreNoParams():void {
			var mode:String = init.queryMode("http://localhost:8080/client");
			assertEquals( mode, 'LIVE' );        
		} 
	}
}