package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.ElementExistenceEvent;
	
	import us.ut.lib.slcpl.view.editor.MyEaselWorkarea;
	
	import watercolor.events.ElementEvent;
	import watercolor.events.LayerElementEvent;
	import watercolor.models.WaterColorModel;
	
	public class DragShapesHintMediator extends Mediator
	{
		[Inject]
		public var wcModel:WaterColorModel;
		
		[Inject]
		public var view:DragShapesHint;
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(eventDispatcher, LayerElementEvent.ADDED_ELEMENT, 
					dispatcher_addedElementHandler, LayerElementEvent);
			eventMap.mapListener(eventDispatcher, LayerElementEvent.REMOVED_ELEMENT, 
					dispatcher_removedElementHandler, LayerElementEvent);
		}
		
		protected function dispatcher_addedElementHandler(event:Event):void
		{
			updateVisibility();	
		}
		
		protected function dispatcher_removedElementHandler(event:Event):void
		{
			updateVisibility();
		}
		
		/**
		 * Determines if the artwork has elements.  If the artwork has elements then the hint
		 * disappears.
		 */
		protected function updateVisibility():void
		{
			view.visible = MyEaselWorkarea(wcModel.workArea).backgroundLayer.numElements == 0 &&
					MyEaselWorkarea(wcModel.workArea).contentLayer.numElements == 0;
		}
	}
}