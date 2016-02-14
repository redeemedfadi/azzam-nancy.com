package {
	//Flash imports
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.system.Security;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;

	public class Player extends MovieClip{
		private var video:Video;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var meta:Object;
		
		private var formatW:uint = 16;
		private var formatH:uint = 9;
		
		private var playing:Boolean = false;
		private var autoplay:Boolean = true;
		private var muted:Boolean = false;
		private var loop:Boolean = true;
		
		function Player(){
			var domain:String = LoaderInfo(stage.root.loaderInfo).parameters.domain;
			Security.allowDomain(domain);
			Security.allowInsecureDomain(domain);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			try {
				var urlVideo:String; // This will contain the value of the parameter
				var flashvars:Object = LoaderInfo(this.root.loaderInfo).parameters;
				urlVideo = String(flashvars["url"]);
				formatW = int(flashvars["formW"]);
				formatH = int(flashvars["formH"]);
				
				var str:String = String(flashvars["muted"]);
				var str1:String = String(flashvars["autoplay"]);
				var str2:String = String(flashvars["loop"]);
				
				if(str=="true")
					muted=true;
				if(str1=="false")
					autoplay=false;
				if(str2=="false")
					loop=false;
				
				//var retval:Boolean = ExternalInterface.call("alertFlash", urlVideo);
				
				nc = new NetConnection();
				nc.connect(null);
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				
				ns = new NetStream(nc);
				meta=new Object();
				
				video = new Video(stage.stageWidth, stage.stageHeight);
				
				ns.client = meta;
				ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				video.attachNetStream(ns);
				video.smoothing = true;
				
				ns.play("../"+urlVideo);
				if(autoplay)
					playing = true;
				else
					ns.pause();
					
				if(muted)
					mute();
					
				addChild(video);
				
				if (ExternalInterface.available){
					ExternalInterface.addCallback("isPlaying",isPlaying);
					ExternalInterface.addCallback("pause",pause);
					ExternalInterface.addCallback("resume",resume);
					ExternalInterface.addCallback("isMute",isMute);
					ExternalInterface.addCallback("mute",mute);
					ExternalInterface.addCallback("unmute",unmute);
					ExternalInterface.addCallback("rewind",rewind);
				}
				
				stage.addEventListener(Event.RESIZE, resize);
				resize();
					
			} catch (error:Error) {
				// what to do if an error occurs
			}
			
			
		}
		
		private function rewind():void{
			ns.pause();
			ns.seek(0);
			ns.resume();
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found");
				break;
				case "NetStream.Play.Stop":
					if(loop)
						rewind();
				break;
			}
		}
		
		private function isPlaying():Boolean{
			return playing;
		}
		private function pause(){
			playing = false;
			ns.pause();
		}
		private function resume(){
			playing = true;
			ns.resume();
		}
		private function isMute():Boolean{
			return muted;
		}
		private function setVolume(to:Number):void{
			var transform:SoundTransform = ns.soundTransform;
            transform.volume = to;
            ns.soundTransform = transform;
		}
		private function mute(){
			muted = true;
			setVolume(0);
		}
		private function unmute(){
			muted = false;
			setVolume(1);
		}
		
		private function resize(evt:Event = null):void{
			var w = stage.stageWidth;
			var h = w * formatH / formatW;
			
			if(h<stage.stageHeight){
				h = stage.stageHeight;
				w = h * formatW / formatH;
			}
			video.width=w;
			video.height=h;
			video.x = stage.stageWidth/2-w/2;
			video.y = stage.stageHeight/2-h/2;
		}
		
	}
}