package org.mconf.mobile.command
{
	import org.mconf.mobile.core.IBigBlueButtonConnection;
	import org.mconf.mobile.core.IJoinService;
	import org.mconf.mobile.model.ConferenceParameters;
	import org.mconf.mobile.model.IConferenceParameters;
	import org.mconf.mobile.model.IUserSettings;
	import org.mconf.mobile.model.IUserUISession;
	import org.mconf.mobile.view.ui.ILoginButton;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class JoinMeetingCommand extends Command
	{		
		[Inject]
		public var joinService: IJoinService;
				
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var url: String;
		
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var connectSignal: ConnectSignal;
		
		override public function execute():void
		{			
			joinService.successfullyJoinedMeetingSignal.add(successfullyJoined);
			joinService.unsuccessfullyJoinedMeetingSignal.add(unsuccessfullyJoined);
			
			joinService.load(url);
			
			userUISession.loading = true;
		}

		private function successfullyJoined(user:Object):void {
			Log.getLogger("org.mconf.mobile").info(String(this) + ":successfullyJoined()");
			
			conferenceParameters.load(user);
			
			connectSignal.dispatch("rtmp://test-install.blindsidenetworks.com/bigbluebutton");
		}
		
		private function unsuccessfullyJoined(reason:String):void {
			Log.getLogger("org.mconf.mobile").info(String(this) + ":unsuccessfullyJoined()");
		}
		
	}
}