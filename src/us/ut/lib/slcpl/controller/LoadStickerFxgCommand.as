package us.ut.lib.slcpl.controller
{
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.controller.events.LoadStickerFxgEvent;
	import us.ut.lib.slcpl.service.interfaces.IStickerFXGService;

	public class LoadStickerFxgCommand extends Command
	{
		[Inject]
		public var event:LoadStickerFxgEvent;
		
		[Inject]
		public var service:IStickerFXGService;
		
		override public function execute():void
		{
			super.execute();
			
			// Only load if it hasn't been loaded previously.
			if (!event.sticker.fxg)
			{
				service.loadStickerFxg(event.sticker);
			}
		}
	}
}