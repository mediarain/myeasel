package us.ut.lib.slcpl.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.IVisualElement;
	
	import spark.primitives.Rect;
	
	import us.ut.lib.slcpl.model.events.StickerEvent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.factories.fxg.GroupFactory;
	import watercolor.factories.fxg.util.URIManager;

	[Event(name="fxgChanged",type="us.ut.lib.slcpl.model.events.StickerEvent")]
	public class Sticker extends EventDispatcher
	{
		/**
		 * The URL of the FXG containing path data (and possibly other data) for the sticker.
		 */
		public var url:String;
		
		[Bindable]
		/**
		 * The URL of the preview image for the sticker.
		 */
		public var previewUrl:String;
		
		/**
		 * Whether this sticker is to be used as a background.  The placement logic for the sticker
		 * differs depending on this value.
		 */
		public var isBackground:Boolean;
		
		private var _fxg:XML;

		/**
		 * The FXG XML describing the graphical elements of the sticker.  Loaded using the
		 * <code>url</code> property.
		 */
		public function get fxg():XML
		{
			return _fxg;
		}

		/**
		 * @private
		 */
		public function set fxg(value:XML):void
		{
			if (_fxg != value)
			{
				_fxg = value;
				dispatchEvent(new StickerEvent(StickerEvent.FXG_CHANGED)); 
			}
		}
	}
}