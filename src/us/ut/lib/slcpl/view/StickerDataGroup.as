package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	import spark.components.List;
	import spark.layouts.VerticalLayout;
	
	import us.ut.lib.slcpl.controller.events.LoadStickerFxgEvent;
	
	public class StickerDataGroup extends DataGroup
	{
		public function StickerDataGroup()
		{
			super();
			focusEnabled = false;
			layout = new VerticalLayout();
			VerticalLayout(layout).useVirtualLayout = true;
			itemRenderer = new ClassFactory(StickerRenderer);
		}
	}
}