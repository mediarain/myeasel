package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	import us.ut.lib.slcpl.controller.events.LoadStickerFxgEvent;
	
	public class StickerDataGroupMediator extends Mediator
	{
		[Inject]
		public var view:StickerDataGroup;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			// This event will be bubbling up from the renderer.
			eventMap.mapListener(view, LoadStickerFxgEvent.LOAD_STICKER_FXG, redispatch);
		}

		protected function redispatch(event:Event):void
		{
			dispatch(event);
		}
	}
}