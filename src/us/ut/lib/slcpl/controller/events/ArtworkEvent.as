package us.ut.lib.slcpl.controller.events
{
	import flash.events.Event;
	
	public class ArtworkEvent extends Event
	{
		public static const CLEAR:String = 'clear';
		public static const SAVE:String = 'save';
		
		/**
		 * Dispatched right before a snapshot of the artwork is taken to be saved.
		 */
		public static const TAKING_SNAPSHOT:String = 'takingSnapshot';
		
		/**
		 * Dispatched right after a snapshot of the artwork has been taken to be saved.
		 */
		public static const TOOK_SNAPSHOT:String = 'tookSnapshot';
		
		public function ArtworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ArtworkEvent(type, bubbles, cancelable);
		}
	}
}