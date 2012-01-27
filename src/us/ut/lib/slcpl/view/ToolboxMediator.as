package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.events.AppModelEvent;
	
	public class ToolboxMediator extends Mediator
	{
		[Inject]
		public var view:Toolbox;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, AppModelEvent.STICKER_CATEGORIES_CHANGED, updateCategories);
			updateCategories();
		}
		
		protected function updateCategories(event:Event=null):void
		{
			view.stickerCategories = appModel.stickerCategories;
		}
	}
}