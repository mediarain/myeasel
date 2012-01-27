package us.ut.lib.slcpl.view
{
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.events.AppModelEvent;
	import us.ut.lib.slcpl.view.editor.StickerElement;
	
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.PropertyVO;
	import watercolor.elements.Element;
	import watercolor.events.GenericExecuteEvent;
	import watercolor.events.SelectionManagerEvent;
	import watercolor.models.WaterColorModel;
	
	public class SwatchListMediator extends Mediator
	{
		[Inject]
		public var view:SwatchList;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var wcModel:WaterColorModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, AppModelEvent.SWATCHES_CHANGED, updateSwatches);
			updateSwatches();
			
			eventMap.mapListener(view, IndexChangeEvent.CHANGING, view_changingHandler);
			eventMap.mapListener(view, IndexChangeEvent.CHANGE, view_changeHandler);
			
			eventMap.mapListener(wcModel.selectionManager, SelectionManagerEvent.ELEMENT_ADDED, 
					selectionManager_selectHandler);
			eventMap.mapListener(wcModel.selectionManager, SelectionManagerEvent.ELEMENTS_ADDED, 
					selectionManager_selectHandler);
			eventMap.mapListener(wcModel.selectionManager, SelectionManagerEvent.ELEMENT_REMOVED, 
					selectionManager_selectHandler);
			eventMap.mapListener(wcModel.selectionManager, SelectionManagerEvent.ELEMENTS_REMOVED, 
					selectionManager_selectHandler);
		}
		
		protected function updateSwatches(event:Event=null):void
		{
			view.dataProvider = appModel.swatches;
		}

		protected function view_changingHandler(event:IndexChangeEvent):void
		{
			// Prevent swatch selection if no elements are selected.
			if (wcModel.selectionManager.elements.length < 1)
			{
				event.preventDefault();
			}
		}
		
		protected function view_changeHandler(event:IndexChangeEvent):void
		{
			if (event.newIndex > -1)
			{
				changeStickerColor(uint(view.dataProvider.getItemAt(event.newIndex)));
			}
		}
		
		protected function changeStickerColor(color:uint):void
		{
			if (wcModel.selectionManager.elements.length > 0)
			{
				var vo:GroupCommandVO = new GroupCommandVO();
				
				if (wcModel.selectionManager.elements.length > 1)
				{
					for each (var element:StickerElement in wcModel.selectionManager.elements)
					{
						if (element is StickerElement)
						{
							addPropertyChangeVOs(vo, element, color);
						}
						else
						{
							throw new Error('Only stickers are colorable');
						}
					}
				}
				else
				{
					addPropertyChangeVOs(vo, StickerElement(wcModel.selectionManager.elements[0]), color);
				}
				
				var event:GenericExecuteEvent = new GenericExecuteEvent(
						GenericExecuteEvent.GENERIC_EXECUTE, vo);
				dispatch(event);
			}
		}
		
		protected function addPropertyChangeVOs(group:GroupCommandVO,
				element:StickerElement, color:uint):void
		{
			var colorTransformVO:PropertyVO = new PropertyVO();
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			colorTransformVO.element = element;
			colorTransformVO.newProperties = {'transform.colorTransform': colorTransform};
			colorTransformVO.originalProperties = {'transform.colorTransform': colorTransformVO.element.transform.colorTransform};
			group.addCommand(colorTransformVO);
			
			var manuallyColoredVO:PropertyVO = new PropertyVO();
			manuallyColoredVO.element = element;
			manuallyColoredVO.newProperties = {'manuallyColored': manuallyColoredVO};
			manuallyColoredVO.originalProperties = {'manuallyColored': element.manuallyColored};
			group.addCommand(manuallyColoredVO);
		}
		
		protected function selectionManager_selectHandler(event:SelectionManagerEvent):void
		{
			if (wcModel.selectionManager.elements.length == 1)
			{
				var element:Element = wcModel.selectionManager.elements[0];
				if (element is StickerElement && StickerElement(element).manuallyColored)
				{
					view.selectedItem = element.transform.colorTransform.color;
				}
				else
				{
					view.selectedIndex = -1;
				}
			}
			else
			{
				view.selectedIndex = -1;
			}
		}
	}
}