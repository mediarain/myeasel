package us.ut.lib.slcpl.view.editor
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	
	public class HandleButton extends Button
	{
		/**
		 * @inheritDoc
		 */
		override protected function mouseEventHandler(event:Event):void
		{
			// Generally when you've moused-down on a button and then roll out of the button,
			// the button goes back to the up state even though your mouse is still down.  This
			// looks awkward on handle button because it should stay in the down state for as long
			// the user's mouse is down.  So, if we run into this situation, we bail out of this
			// function so super.mouseEventHandler() can't change it back to the up state.
			if (mouseCaptured && event.type == MouseEvent.ROLL_OUT)
			{
				return;
			}
			super.mouseEventHandler(event);
		}
	}
}