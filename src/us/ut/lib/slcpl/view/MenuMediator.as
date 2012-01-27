package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import us.ut.lib.slcpl.controller.events.ArtworkEvent;
	import us.ut.lib.slcpl.controller.events.StatusMessageEvent;
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.events.AppModelEvent;
	import us.ut.lib.slcpl.view.editor.MyEaselWorkarea;
	
	import watercolor.events.LayerElementEvent;
	import watercolor.models.WaterColorModel;

	public class MenuMediator extends Mediator
	{
		[Inject]
		public var view:Menu;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var wcModel:WaterColorModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(view.clearButton, MouseEvent.CLICK, clear_clickHandler,
					MouseEvent);
			eventMap.mapListener(view.saveButton, MouseEvent.CLICK, save_clickHandler,
					MouseEvent);
			eventMap.mapListener(eventDispatcher, StatusMessageEvent.SHOW_MESSAGE, 
					dispatcher_showMessageHandler, StatusMessageEvent);
			eventMap.mapListener(eventDispatcher, AppModelEvent.SAVING_ARTWORK_CHANGED,
					dispatcher_savingArtworkChangedHandler, AppModelEvent);
			eventMap.mapListener(eventDispatcher, LayerElementEvent.ADDED_ELEMENT, 
					dispatcher_addedElementHandler, LayerElementEvent);
			eventMap.mapListener(eventDispatcher, LayerElementEvent.REMOVED_ELEMENT, 
					dispatcher_removedElementHandler, LayerElementEvent);
			updateSaveable();
		}
		
		protected function clear_clickHandler(event:MouseEvent):void
		{
			dispatch(new ArtworkEvent(ArtworkEvent.CLEAR));
		}
		
		protected function save_clickHandler(event:MouseEvent):void
		{
			dispatch(new ArtworkEvent(ArtworkEvent.SAVE));
		}
		
		protected function dispatcher_showMessageHandler(event:StatusMessageEvent):void
		{
			view.setStatusText(event.text, event.isError);
		}
		
		protected function dispatcher_savingArtworkChangedHandler(event:AppModelEvent):void
		{
			view.savingArtwork = appModel.savingArtwork;
		}
		
		protected function dispatcher_addedElementHandler(event:Event):void
		{
			updateSaveable();	
		}
		
		protected function dispatcher_removedElementHandler(event:Event):void
		{
			updateSaveable();
		}
		
		/**
		 * Determines if the artwork is in a saveable state and modified the view accordingly.
		 */
		protected function updateSaveable():void
		{
			view.saveable = MyEaselWorkarea(wcModel.workArea).backgroundLayer.numElements > 0 ||
					MyEaselWorkarea(wcModel.workArea).contentLayer.numElements > 0;
		}
	}
}