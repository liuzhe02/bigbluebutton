package org.bigbluebutton.modules.login.model.services
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.digitalprimates.fluint.tests.TestCase;


	public class LoginServiceTestCase extends TestCase
	{
		//private var timer:Timer;

		private var request:URLRequest = new URLRequest();
		private var vars:URLVariables = new URLVariables();
		private var urlLoader:URLLoader;
		private var _resultListener:Function;

		private var fullname:String;
		private var conference:String;
		private var password:String;
		private var url:String;


		public function LoginServiceTestCase(fullname:String, conference:String, password:String, url:String)
		{
			super();
			
			this.fullname = fullname;
			this.conference = conference;
			this.password = password;
			this.url = url;
		}
		
		override protected function setUp():void 
		{
			//timer = new Timer( 18000, 1 );  			
        }
        
		override protected function tearDown():void 
		{
			//timer.stop();
            //timer = null;
        }        
        
		[Test]
		public function testLoginService():void 
		{
            vars.fullname = this.fullname;
            vars.conference = this.conference;
            vars.password = this.password;
            request = new URLRequest(url);
            request.data = vars;
            request.method = URLRequestMethod.POST;		
            urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, asyncHandler(handleComplete, 5000));	
            urlLoader.load(request);	
        
			//var asyncHandler:Function = asyncHandler( handleTimerComplete, 17000, null, handleTimeout );
            //timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
            //timer.start();
        
        }

		private function handleComplete(e:Event, passThroughData:Object):void{
			
			var xml:XML = new XML(e.target.data)
			
			var returncode:String = xml.returncode;
			
			if (returncode == 'FAILED') 
			{
        		fail( "login FAILED: fullname=" + fullname + "  conference=" + conference + "  password=" + password);   
        		
        		 
			} else if (returncode == 'SUCCESS') 
			{
        		assertEquals( "login SUCCESS: fullname=" + fullname + "  conference=" + conference + "  password=" + password, 5, 5);   
			}
		
				
		}
        	
		/*        	
		public function addLoginResultListener(listener:Function):void {
			_resultListener = listener;
		}

		protected function handleTimerComplete( event:TimerEvent, passThroughData:Object ):void {
 			//assertEquals(5, 5);
        	fail( "TimerComplete");    
        }

        protected function handleTimeout( passThroughData:Object ):void {
        	fail( "Timeout");    
        } 
        */
               		
	}
}