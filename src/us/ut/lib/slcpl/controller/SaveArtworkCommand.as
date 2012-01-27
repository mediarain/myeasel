package us.ut.lib.slcpl.controller
{
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.controller.events.ArtworkEvent;
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.service.interfaces.IArtworkService;
	
	import watercolor.models.WaterColorModel;

	public class SaveArtworkCommand extends Command
	{
		[Inject]
		public var service:IArtworkService;
		
		[Inject]
		public var wcModel:WaterColorModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void
		{
			super.execute();
			dispatch(new ArtworkEvent(ArtworkEvent.TAKING_SNAPSHOT));
			service.save(wcModel.workArea, appModel.workAreaAndStory);
			dispatch(new ArtworkEvent(ArtworkEvent.TOOK_SNAPSHOT));
		}
	}
}