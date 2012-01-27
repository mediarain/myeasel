package us.ut.lib.slcpl.model
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	import us.ut.lib.slcpl.model.events.AppModelEvent;
	
	[Event(name="stickerCategoriesChanged",type="us.ut.lib.slcpl.model.events.AppModelEvent")]
	[Event(name="swatchesChanged",type="us.ut.lib.slcpl.model.events.AppModelEvent")]
	public class AppModel extends Actor
	{
		private var _stickerCategories:ArrayCollection;

		/**
		 * All sticker categories.  Collection of StickerCategory objects.
		 */
		public function get stickerCategories():ArrayCollection
		{
			return _stickerCategories;
		}

		/**
		 * @private
		 */
		public function set stickerCategories(value:ArrayCollection):void
		{
			if (_stickerCategories != value)
			{
				_stickerCategories = value;
				dispatch(new AppModelEvent(AppModelEvent.STICKER_CATEGORIES_CHANGED));
			}
		}

		//-------------------------------------------------------
		
		private var _swatches:ArrayCollection;

		/**
		 * All swatches.  A collection of uints representing the swatch colors.
		 */
		public function get swatches():ArrayCollection
		{
			return _swatches;
		}

		/**
		 * @private
		 */
		public function set swatches(value:ArrayCollection):void
		{
			if (_swatches != value)
			{
				_swatches = value;
				dispatch(new AppModelEvent(AppModelEvent.SWATCHES_CHANGED));
			}
		}
		
		//-------------------------------------------------------
		
		private var _savingArtwork:Boolean;
		
		/**
		 * Whether the app is in the process of saving the user's artwork.
		 */
		public function get savingArtwork():Boolean
		{
			return _savingArtwork;
		}
		
		/**
		 * @private
		 */
		public function set savingArtwork(value:Boolean):void
		{
			if (_savingArtwork != value)
			{
				_savingArtwork = value;
				dispatch(new AppModelEvent(AppModelEvent.SAVING_ARTWORK_CHANGED));
			}
		}
		
		//-------------------------------------------------------
		
		public var workAreaAndStory:DisplayObject;
	}
}