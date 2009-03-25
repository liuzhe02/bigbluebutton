package org.bigbluebutton.modules.login.view.components
{
	import flash.events.*;
	import mx.events.FlexEvent;
	import flash.net.*;
	
	import net.digitalprimates.fluint.sequence.SequenceEventDispatcher;
	import net.digitalprimates.fluint.sequence.SequenceRunner;
	import net.digitalprimates.fluint.sequence.SequenceSetter;
	import net.digitalprimates.fluint.sequence.SequenceWaiter;
	import net.digitalprimates.fluint.tests.TestCase;
	
	import org.bigbluebutton.common.*;
	import org.bigbluebutton.modules.login.model.services.LoginService;
	import org.bigbluebutton.modules.login.view.LoginWindowMediator;
	
	public class LoginWindowTestCase extends TestCase
	{
		private var url:String;
		private var fullname:String;
		private var conference:String;
		private var password:String;
		
		private var formlogin:LoginWindow;
		
		private var uri:String;
		private var netConnection:NetConnection;

		public function LoginWindowTestCase(url:String, fullname:String, conference:String, password:String)
		{
			super();
			
			this.url = url;
			this.fullname = fullname;
			this.conference = conference;
			this.password = password;
		}
		
		override protected function setUp():void {
            formlogin = new LoginWindow();
            formlogin.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
            addChild( formlogin );
        }
        
		override protected function tearDown():void {
            removeChild( formlogin );                    
            formlogin = null;
        }        
        
		[Test]
		public function testLogin():void 
		{
            var passThroughData:Object = new Object();
            passThroughData.fullname = fullname;
            passThroughData.conference = conference;
            passThroughData.password = password;

            var sequence:SequenceRunner = new SequenceRunner( this );

            sequence.addStep( new SequenceSetter( formlogin.nameField, {text:passThroughData.fullname} ) );
            sequence.addStep( new SequenceWaiter( formlogin.nameField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceSetter( formlogin.confField, {text:passThroughData.conference} ) );
            sequence.addStep( new SequenceWaiter( formlogin.confField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceSetter( formlogin.passwdField, {text:passThroughData.password} ) );
            sequence.addStep( new SequenceWaiter( formlogin.passwdField, FlexEvent.VALUE_COMMIT, 100 ) );

            sequence.addStep( new SequenceEventDispatcher( formlogin.loginBtn, new MouseEvent( 'click', true, false ) ) );
            sequence.addStep( new SequenceWaiter( formlogin, LoginWindowMediator.LOGIN, 100 ) );
                      
            sequence.addAssertHandler( handleLoginEvent, passThroughData );
                      
            sequence.run();
       }

     
		protected function handleLoginEvent( event:Event, passThroughData:Object ):void {
        	var ls:LoginService = new LoginService();
			ls.load(url, formlogin.nameField.text, formlogin.confField.text, formlogin.passwdField.text, asyncHandler(handleComplete, 5000));
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
				//fail("login SUCCESS: " + xml.returncode + " " + xml.fullname + " " + xml.conference + " " + xml.role + " " + xml.room);
			}
    	}     
	}
}