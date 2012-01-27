package us.ut.lib.slcpl.model.events
{
	import flash.events.Event;
	
	public class StickerEvent extends Event
	{
		public static const FXG_CHANGED:String = 'fxgChanged';
		
		public function StickerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new StickerEvent(type, bubbles, cancelable);
		}
	}
}