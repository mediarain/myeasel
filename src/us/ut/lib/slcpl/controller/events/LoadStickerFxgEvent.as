package us.ut.lib.slcpl.controller.events
{
	import flash.events.Event;
	
	import us.ut.lib.slcpl.model.vo.Sticker;
	
	public class LoadStickerFxgEvent extends Event
	{
		public static const LOAD_STICKER_FXG:String = 'loadStickerFxg';
		public var sticker:Sticker;
		
		public function LoadStickerFxgEvent(type:String, sticker:Sticker, 
				bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.sticker = sticker;
		}
		
		override public function clone():Event
		{
			return new LoadStickerFxgEvent(type, sticker, bubbles, cancelable);
		}
	}
}