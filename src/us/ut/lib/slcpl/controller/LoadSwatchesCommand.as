package us.ut.lib.slcpl.controller
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.service.interfaces.ISwatchService;
	
	public class LoadSwatchesCommand extends Command
	{
		[Inject]
		public var service:ISwatchService;
		
		override public function execute():void
		{
			super.execute();
			service.loadSwatches();
		}
	}
}