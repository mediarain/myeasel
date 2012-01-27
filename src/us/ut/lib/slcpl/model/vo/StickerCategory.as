package us.ut.lib.slcpl.model.vo
{
	import mx.collections.ArrayCollection;

	public class StickerCategory
	{
		/**
		 * The name of the category.
		 */
		public var name:String;
		
		[Bindable]
		/**
		 * Collection of Sticker objects.
		 */
		public var stickers:ArrayCollection;
	}
}