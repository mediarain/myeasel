package us.ut.lib.slcpl.model.events
{
	import flash.events.Event;
	
	public class AppModelEvent extends Event
	{
		public static const STICKER_CATEGORIES_CHANGED:String = 'stickerCategoriesChanged';
		public static const SWATCHES_CHANGED:String = 'swatchesChanged';
		public static const SAVING_ARTWORK_CHANGED:String = 'savingArtworkChanged';
		
		public function AppModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AppModelEvent(type, bubbles, cancelable);
		}
	}
}