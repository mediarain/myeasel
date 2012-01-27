package us.ut.lib.slcpl.controller.events
{
	import flash.events.Event;
	
	public class StatusMessageEvent extends Event
	{
		public static const SHOW_MESSAGE:String = 'showMessage';
		
		public var text:String;
		public var isError:Boolean;
		
		public function StatusMessageEvent(type:String, text:String, isError:Boolean=false,
				bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.text = text;
			this.isError = isError;
		}
		
		override public function clone():Event
		{
			return new StatusMessageEvent(type, text, isError, bubbles, cancelable);
		}
	}
}