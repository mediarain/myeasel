package us.ut.lib.slcpl.controller.events
{
	import flash.events.Event;
	
	import us.ut.lib.slcpl.model.vo.Sticker;
	
	public class AddStickerEvent extends Event
	{
		public static const ADD_STICKER:String = 'addSticker';
		
		public var sticker:Sticker;
		public var workAreaX:Number;
		public var workAreaY:Number;
		
		public function AddStickerEvent(type:String, sticker:Sticker, workAreaX:Number,
				workAreaY:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.sticker = sticker;
			this.workAreaX = workAreaX;
			this.workAreaY = workAreaY;
		}
		
		override public function clone():Event
		{
			return new AddStickerEvent(type, sticker, workAreaX, workAreaY, bubbles, cancelable);
		}
	}
}