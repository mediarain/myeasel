package us.ut.lib.slcpl.controller
{
	import mx.core.IVisualElement;
	
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.view.editor.MyEaselWorkarea;
	
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.events.ElementEvent;
	import watercolor.models.WaterColorModel;

	public class ClearArtworkCommand extends Command
	{
		[Inject]
		public var wcModel:WaterColorModel;
		
		override public function execute():void
		{
			super.execute();
			var elements:Vector.<Element> = new Vector.<Element>();
			getChildElements(MyEaselWorkarea(wcModel.workArea).backgroundLayer, elements);
			getChildElements(MyEaselWorkarea(wcModel.workArea).contentLayer, elements);
			dispatch(new ElementEvent(ElementEvent.REMOVE, elements));
		}
		
		protected function getChildElements(group:Layer, addTo:Vector.<Element>):void
		{
			for (var i:uint; i < group.numElements; i++)
			{
				var element:IVisualElement = group.getElementAt(i);
				if (element is Element) // This is probably unnecessary but safe.
				{
					addTo.push(element);
				}
			}
		}
	}
}