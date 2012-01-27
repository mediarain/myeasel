package us.ut.lib.slcpl.controller.parsers
{
	import mx.collections.ArrayCollection;
	
	import us.ut.lib.slcpl.model.Config;
	import us.ut.lib.slcpl.model.vo.Sticker;
	import us.ut.lib.slcpl.model.vo.StickerCategory;

	/**
	 * Parses sticker XML into ActionScript objects.
	 */
	public class StickerMetadataParser
	{
		public function parse(xml:XML):ArrayCollection
		{
			var categories:ArrayCollection = new ArrayCollection();
			
			for each (var categoryXML:XML in xml.easel_list)
			{
				var category:StickerCategory = new StickerCategory();
				category.name = categoryXML.@name;
				category.stickers = new ArrayCollection();
				
				for each (var stickerXML:XML in categoryXML.easel_item)
				{
					var sticker:Sticker = new Sticker();
					sticker.url = Config.prependGateway(stickerXML.@image);
					sticker.previewUrl = Config.prependGateway(stickerXML.@previewUrl);
					// For testing when a preview url doesn't exist.
					//sticker.previewUrl = 'http://www.snr.arizona.edu/files/shared/images/placeholder.jpg';
					sticker.isBackground = categoryXML.@backgrounds.toString() == "true";
					category.stickers.addItem(sticker);
				}
				
				categories.addItem(category);
			}
			
			return categories;
		}
	}
}