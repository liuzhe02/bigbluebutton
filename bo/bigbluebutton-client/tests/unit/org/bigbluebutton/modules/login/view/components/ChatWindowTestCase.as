package org.bigbluebutton.modules.chat.view.components
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	
	import net.digitalprimates.fluint.sequence.SequenceEventDispatcher;
	import net.digitalprimates.fluint.sequence.SequenceRunner;
	import net.digitalprimates.fluint.sequence.SequenceSetter;
	import net.digitalprimates.fluint.sequence.SequenceWaiter;
	import net.digitalprimates.fluint.tests.TestCase;
	
	import org.bigbluebutton.common.*;
	import org.bigbluebutton.modules.login.model.services.LoginService;
	import org.bigbluebutton.modules.login.view.LoginWindowMediator;
	import org.bigbluebutton.modules.login.view.components.LoginWindow;

	public class ChatWindowTestCase extends TestCase
	{
		public var url:String;
		public var fullname:String;
		public var conference:String;
		public var password:String;
		public var message:String;

		private var timertest:Timer;
		
		public var formlogin:LoginWindow;
		public var formchat:ChatWindow;

		public var netConnection:NetConnection;
		public var chatSO:SharedObject;
		

		public function ChatWindowTestCase(url:String, fullname:String, conference:String, password:String, message:String)
		{
			super();
			
			this.url = url;
			this.fullname = fullname;
			this.conference = conference;
			this.password = password;
			this.message = message;
		}
		
		override protected function setUp():void 
		{
			super.setUp();

			timertest = new Timer(1000, 1);
			
            //formlogin = new LoginWindow();
            //formlogin.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
            //addChild( formlogin );
			
            //formchat = new ChatWindow();
            //formchat.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
            //addChild( formchat );

        }
        
		override protected function tearDown():void 
		{
			super.tearDown();

			if (timertest) {timertest.stop();} 
			timertest = null;
			
            //removeChild( formlogin );                    
            //formlogin = null;
            
            //removeChild( formchat );                    
            //formchat = null;
        }        


		[Test]
		public function login():void 
		{
            formlogin = new LoginWindow();
            //formlogin.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
            addChild( formlogin );

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
		public function handleLoginEvent( event:Event, passThroughData:Object ):void 
		{
			//fail("handleLoginEvent     " + formlogin.nameField + "  " + formlogin.confField + "  " + formlogin.passwdField);
        }

		[Test]
		public function chat():void 
		{
            formchat = new ChatWindow();
            //formchat.addEventListener( FlexEvent.CREATION_COMPLETE, asyncHandler( pendUntilComplete, 100 ), false, 0, true );
            addChild( formchat );

            var passThroughDatachat:Object = new Object();
            passThroughDatachat.fullname = fullname;
            passThroughDatachat.conference = conference;
            passThroughDatachat.password = password;
            passThroughDatachat.message = message;

            var sequencechat:SequenceRunner = new SequenceRunner( this );

            sequencechat.addStep( new SequenceSetter( formchat.txtMsg, {text:passThroughDatachat.message} ) );
            sequencechat.addStep( new SequenceWaiter( formchat.txtMsg, FlexEvent.VALUE_COMMIT, 100 ) );

            sequencechat.addStep( new SequenceEventDispatcher( formchat.sendBtn, new MouseEvent( 'click', true, false ) ) );
            sequencechat.addStep( new SequenceWaiter( formchat, ChatWindow.SEND_MESSAGE, 100 ) );
                      
            sequencechat.addAssertHandler( handleChatEvent, passThroughDatachat );
            sequencechat.run();
        }
		public function handleChatEvent( event:Event, passThroughData:Object ):void 
		{
			//fail("handleChatEvent     " + formchat.txtMsg.text);
        }

		[Test]
		public function test():void 
		{
			var asyncHandler:Function = asyncHandler( handleTimerCompleteTest, 10000, null, handleTimeoutTest );
            timertest.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
            timertest.start();
		}
		public function handleTimerCompleteTest( event:TimerEvent, passThroughData:Object ):void 
		{
        	var ls:LoginService = new LoginService();
			ls.load(url, fullname, conference, password, asyncHandler(handleComplete, 5000));
        }
        public function handleTimeoutTest( passThroughData:Object ):void {
        } 

		public function handleComplete(e:Event, passThroughDatachat:Object):void
		{
			var xml:XML = new XML(e.target.data)
			
			var returncode:String = xml.returncode;
			
			if (returncode == 'FAILED') 
			{
        		fail( "login FAILED: fullname=" + fullname + "  conference=" + conference + "  password=" + password);   
			} 
			else if (returncode == 'SUCCESS') 
			{
				//fail("login SUCCESS :" + xml.returncode + " " + xml.fullname + " " + xml.conference + " " + xml.role + " " + xml.room);
        		//assertEquals( "login SUCCESS: fullname=" + fullname + "  conference=" + conference + "  password=" + password, 5, 5);   
			    
			    //uri = "rtmp://localhost/bigbluebutton/" + xml.room + " [" + xml.fullname + "," + xml.role + "," + xml.conference + ",LIVE," + xml.room + "]";
				netConnection = new NetConnection();
			    netConnection.client = this;
				netConnection.addEventListener( NetStatusEvent.NET_STATUS, asyncHandler(handleStatus, 5000) );
			    netConnection.connect("rtmp://localhost/bigbluebutton/" + xml.room, xml.fullname, xml.role, xml.conference, "LIVE", xml.room);		
			}
    	}     

		public function handleStatus( event:NetStatusEvent, passThroughData:Object):void 
		{
			var info:Object = event.info;
			var statusCode:String = info.code;
			
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					
					chatSO = SharedObject.getRemote("chatSO", netConnection.uri, false);
					chatSO.client = this;
					chatSO.connect(netConnection);

					netConnection.call(
						"chat.sendMessage",// Remote function name
						new Responder(
	        				// On successful result
							function(result:Object):void { 
							},	
							// status - On error occurred
							function(status:Object):void { 
								for (var x:Object in status) { 
								} 
							}
						),//new Responder
						"[" + fullname + " - " + (new Date()).toTimeString() + "] " + message + '<br/>'
					); //_netConnection.call
					
					if (chatSO != null) chatSO.close();					
					
					break;
					
				default :

				   fail("NetConnection.Connect not SUCCESS");

				   break;
			}
		}
        
	}
}