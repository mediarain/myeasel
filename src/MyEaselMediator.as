package
{
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	
	import us.ut.lib.slcpl.model.AppModel;
	
	public class MyEaselMediator extends Mediator
	{
		[Inject]
		public var view:MyEasel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(view, KeyboardEvent.KEY_DOWN, view_keyDownHandler);
			appModel.workAreaAndStory = view.workAreaAndStory;
		}
		
		protected function view_keyDownHandler(event:KeyboardEvent):void
		{
			if (!(event.target is TextInput) && !(event.target is RichEditableText))
			{
				// Used for deleting elements in watercolor, etc.
				dispatch(event);
			}
		}
	}
}