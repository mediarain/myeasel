package us.ut.lib.slcpl.service.stubs
{
	import mx.collections.ArrayCollection;
	
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.vo.Sticker;
	import us.ut.lib.slcpl.model.vo.StickerCategory;
	import us.ut.lib.slcpl.service.interfaces.IStickerMetadataService;
	
	public class StubbedStickerMetadataService implements IStickerMetadataService
	{
		[Inject]
		public var model:AppModel;
		
		public function loadStickerMetadata():void
		{
			var categories:ArrayCollection = new ArrayCollection();
			
			var cat:StickerCategory;
			
			for (var i:uint = 0; i < 8; i++)
			{
				cat = new StickerCategory();
				cat.name = 'Category' + i;
				cat.stickers = getStickers(false); 
				categories.addItem(cat);
			}
			
			cat = new StickerCategory();
			cat.name = 'Backgrounds';
			cat.stickers = getStickers(true);
			categories.addItem(cat);
			
			model.stickerCategories = categories;
		}
		
		protected function getStickers(isBackground:Boolean):ArrayCollection
		{
			var stickers:ArrayCollection = new ArrayCollection();
			
			for (var j:uint = 1; j < 10; j++)
			{
				var sticker:Sticker = new Sticker();
				sticker.url = 'http://aaronh.dev.rain.local/slclibrary/0' + j + '.fxg';
				sticker.isBackground = isBackground;
				stickers.addItem(sticker);
			}
			
			return stickers;
		}	
	}
}