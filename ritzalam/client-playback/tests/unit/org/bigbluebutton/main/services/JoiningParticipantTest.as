package org.bigbluebutton.main.services
{
	import net.digitalprimates.fluint.tests.TestCase;
	
	import org.bigbluebutton.main.model.Participant;

	public class JoiningParticipantTest extends TestCase
	{
		private var xmlString:String = 
			'<participant conference="test-conference" ' 
			+ '  room="test-room" name="Juan Tamas" role="MODERATOR" authToken="let-him-in-token"/>' 
			
		
		private var xml:XML = new XML(xmlString);
		
		public function testParseParticipant():void {
			var jp:JoiningParticipant = new JoiningParticipant();
			var p:Participant = jp.parse(xml);
			assertEquals("test-room", p.room);
		}
		
		
	}
}