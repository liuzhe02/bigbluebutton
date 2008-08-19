package org.bigbluebutton.modules.playback
{
	import org.bigbluebutton.common.InputPipe;
	import org.bigbluebutton.common.OutputPipe;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.modules.playback.view.PlaybackWindow;
	import org.bigbluebutton.modules.playback.view.PlaybackWindowMediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
	public class PlaybackModuleMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PlaybackModuleMeditor";
		
		private var outpipe : OutputPipe;
		private var inpipe : InputPipe;
		private var router : Router;
		private var inpipeListener : PipeListener;
		
		private var playbackWindow:PlaybackWindow
		
		public function PlaybackModuleMediator(module:PlaybackModule)
		{
			super(NAME, module);
			router = module.router;
			inpipe = new InputPipe(PlaybackModuleConstants.TO_PLAYBACK_MODULE);
			outpipe = new OutputPipe(PlaybackModuleConstants.FROM_PLAYBACK_MODULE);
			inpipeListener = new PipeListener(this, messageReceiver);
			router.registerOutputPipe(outpipe.name, outpipe);
			router.registerInputPipe(inpipe.name, inpipe);
			addWindow();
		}
		
		private function messageReceiver(message:IPipeMessage):void{
			var msg:String = message.getHeader().MSG;
		}
		
		private function get module():PlaybackModule{
			return viewComponent as PlaybackModule;
		}
		
		private function addWindow():void{
			var msg:IPipeMessage = new Message(Message.NORMAL);
			msg.setHeader({MSG:MainApplicationConstants.ADD_WINDOW_MSG, SRC: PlaybackModuleConstants.FROM_PLAYBACK_MODULE,
   						TO: MainApplicationConstants.TO_MAIN });
   			msg.setPriority(Message.PRIORITY_HIGH);
   			
   			playbackWindow = new PlaybackWindow();
   			module.activeWindow = playbackWindow;
   			msg.setBody(module);
   			outpipe.write(msg);
		}
		
		override public function initializeNotifier(key:String):void{
			super.initializeNotifier(key);
			facade.registerMediator(new PlaybackWindowMediator(playbackWindow));
		}

	}
}