package org.bigbluebutton.view.navigation.pages.login
{
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.IPagesNavigatorView;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import spark.components.Application;
	
	public class LoginPageViewMediator extends Mediator
	{
		[Inject]
		public var view: ILoginPageView;
		
		[Inject]
		public var joinMeetingSignal: JoinMeetingSignal;
		
		[Inject]
		public var userSession: IUserSession;

		
		override public function initialize():void
		{
			Log.getLogger("org.bigbluebutton").info(String(this));
												
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}
		
		public function onInvokeEvent(invocation:InvokeEvent):void 
		{
			var url:String = invocation.arguments.toString();
			
			if(Capabilities.isDebugger)
			{
				url = "bigbluebutton://test-install.blindsidenetworks.com/bigbluebutton/api/join?meetingID=Demo%20Meeting&fullName=Air%20client&password=ap&checksum=e9c5f7a397509e908ada2787aa0a284842ef4faf";
				//url = "bigbluebutton://lab1.mconf.org/bigbluebutton/api/join?fullName=Air+client&meetingID=Test+room+4&password=prof123&checksum=5805753edd08fbf9af50f9c28bb676c7e5241349"
			}
			
			if(url.lastIndexOf("://") != -1)
			{
				NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);	
				
				var finalURL:String = getEndURL(url);
				
				joinMeetingSignal.dispatch(finalURL);
			}
		}
		
		/**
		 * Replace the schema with "http"
		 */ 
		protected function getEndURL(origin:String):String
		{
			return origin.replace('bigbluebutton://', 'http://');
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			view.dispose();
			view = null;
		}
	}
}