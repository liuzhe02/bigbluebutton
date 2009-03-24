package org.bigbluebutton.modules.login.view.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import net.digitalprimates.fluint.sequence.SequenceEventDispatcher;
	import net.digitalprimates.fluint.sequence.SequenceRunner;
	import net.digitalprimates.fluint.sequence.SequenceSetter;
	import net.digitalprimates.fluint.sequence.SequenceWaiter;
	import net.digitalprimates.fluint.tests.TestCase;
	
	import org.bigbluebutton.common.*;
	import org.bigbluebutton.modules.login.view.LoginWindowMediator;
	import org.bigbluebutton.modules.login.model.services.LoginService;
	
	public class LoginWindowTestCase extends TestCase
	{
		private var url:String;
		private var fullname:String;
		private var conference:String;
		private var password:String;
		
		private var form:LoginWindow;

		public function LoginWindowTestCase(url:String, fullname:String, conference:String, password:String)
		{
			super();
			
			this.url = url;
			this.fullname = fullname;
			this.conference = conference;
			this.password = password;
		}
		
		override protected function setUp():void {
                form = new LoginWindow();
                form.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
                addChild( form );
        }
        
		override protected function tearDown():void {
            removeChild( form );                    
            form = null;
        }        
        
		[Test]
		public function testLogin():void 
		{
            var passThroughData:Object = new Object();
            passThroughData.fullname = fullname;
            passThroughData.conference = conference;
            passThroughData.password = password;

            var sequence:SequenceRunner = new SequenceRunner( this );

            sequence.addStep( new SequenceSetter( form.nameField, {text:passThroughData.fullname} ) );
            sequence.addStep( new SequenceWaiter( form.nameField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceSetter( form.confField, {text:passThroughData.conference} ) );
            sequence.addStep( new SequenceWaiter( form.confField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceSetter( form.passwdField, {text:passThroughData.password} ) );
            sequence.addStep( new SequenceWaiter( form.passwdField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceEventDispatcher( form.loginBtn, new MouseEvent( 'click', true, false ) ) );
            sequence.addStep( new SequenceWaiter( form, LoginWindowMediator.LOGIN, 100 ) );
                      
            sequence.addAssertHandler( handleLoginEvent, passThroughData );
                      
            sequence.run();
       }

     
		protected function handleLoginEvent( event:Event, passThroughData:Object ):void {
        	var ls:LoginService = new LoginService();
			ls.load(url, fullname, conference, password, asyncHandler(handleComplete, 5000));
        }

		private function handleComplete(e:Event, passThroughData:Object):void
		{
			var xml:XML = new XML(e.target.data)
			
			var returncode:String = xml.returncode;
			
			if (returncode == 'FAILED') 
			{
        		fail( "login FAILED: fullname=" + fullname + "  conference=" + conference + "  password=" + password);   
			} 
			else if (returncode == 'SUCCESS') 
			{
        		assertEquals( "login SUCCESS: fullname=" + fullname + "  conference=" + conference + "  password=" + password, 5, 5);   
			}
        	
    	}     
	}
}