package us.ut.lib.slcpl.controller
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.vo.Sticker;
	import us.ut.lib.slcpl.model.vo.StickerCategory;
	import us.ut.lib.slcpl.service.interfaces.IStickerFXGService;
	import us.ut.lib.slcpl.service.interfaces.IStickerMetadataService;
	
	public class LoadStickerMetadataCommand extends Command
	{
		[Inject]
		public var service:IStickerMetadataService;
		
		override public function execute():void
		{
			super.execute();
			service.loadStickerMetadata();
		}
	}
}