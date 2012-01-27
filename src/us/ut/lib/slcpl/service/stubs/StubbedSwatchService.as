package us.ut.lib.slcpl.service.stubs
{
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.service.interfaces.ISwatchService;
	
	public class StubbedSwatchService extends Actor implements ISwatchService
	{
		[Inject]
		public var model:AppModel;
		
		public function loadSwatches():void
		{
			var swatches:ArrayCollection = new ArrayCollection([
					0xffffff,
					0x000000,
					0xe4002c,
					0xfcff23,
					0x40ff18,
					0x4ffffe,
					0x3000fd,
					0xf900fe,
					0xba1b31,
					0xE34A36,
					0xe8562d,
					0xf0922b,
					0xf4b042,
					0xf7f130,
					0xd6e32d,
					0x9fcc3e,
					0x77982e,
					0x229546,
					0x166a37,
					0x39b873,
					0x30ab9c,
					0x47aae0,
					0x2a6dba,
					0x342691,
					0x200662,
					0x661e90,
					
					// Second column
					0x8f128f,
					0x99005e,
					0xcc005c,
					0xe4007a,
					0xfb9cfe,
					0xb97413,
					0xb269fd,
					0x89ffa1,
					0xfbd6a1,
					0x7a2a07,
					0xc4b19a,
					0x978576,
					0x716256,
					0x514641,
					0xc19d6e,
					0xa27b54,
					0x88613b,
					0x724b25,
					0x5c3816,
					0x40200c,
					0x333333,
					0x666666,
					0x999999,
					0xcccccc,
					0xe6e6e6,
					0xf1f1f1
				])
			
			model.swatches = swatches;
		}
	}
}