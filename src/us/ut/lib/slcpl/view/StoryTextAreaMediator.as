package us.ut.lib.slcpl.view
{
	import org.robotlegs.mvcs.Mediator;
	
	import us.ut.lib.slcpl.controller.events.ArtworkEvent;
	
	public class StoryTextAreaMediator extends Mediator
	{
		[Inject]
		public var view:StoryTextArea;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, ArtworkEvent.TAKING_SNAPSHOT,
					dispatcher_takingSnapshot);
			eventMap.mapListener(eventDispatcher, ArtworkEvent.TOOK_SNAPSHOT,
					dispatcher_tookSnapshot);
		}
		
		protected function dispatcher_takingSnapshot(event:ArtworkEvent):void
		{
			view.preSnapshot();
		}
		
		protected function dispatcher_tookSnapshot(event:ArtworkEvent):void
		{
			view.postSnapshot();
		}
	}
}