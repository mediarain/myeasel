package us.ut.lib.slcpl.view.editor
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Application;
	import spark.components.RichEditableText;
	import spark.components.TextInput;
	
	import us.ut.lib.slcpl.controller.events.AddStickerEvent;
	import us.ut.lib.slcpl.controller.events.ArtworkEvent;
	import us.ut.lib.slcpl.model.Config;
	import us.ut.lib.slcpl.model.vo.Sticker;
	
	import watercolor.commands.vo.CreateVO;
	import watercolor.commands.vo.DeleteVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.Position;
	import watercolor.commands.vo.TransformVO;
	import watercolor.controller.mediators.WorkareaMediator;
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.events.ElementEvent;
	import watercolor.events.GenericExecuteEvent;
	import watercolor.factories.fxg.GroupFactory;
	import watercolor.factories.fxg.util.URIManager;
	import watercolor.managers.HistoryManager;
	import watercolor.managers.SelectionManager;
	import watercolor.models.WaterColorModel;
	
	public class MyEaselWorkareaMediator extends WorkareaMediator
	{
		[Inject]
		public var wcModel:WaterColorModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			model.workArea = workArea;
			
			// The history object must exist even if we're not using it.
			model.history = new HistoryManager();
			model.history.enabled = false;
			
			model.selectionManager = new SelectionManager(workArea);
			
			eventMap.mapListener(workArea, DragEvent.DRAG_ENTER, view_dragEnterHandler);
			eventMap.mapListener(workArea, DragEvent.DRAG_DROP, view_dragDropHandler);
			eventMap.mapListener(eventDispatcher, ArtworkEvent.TAKING_SNAPSHOT,
					dispatcher_takingSnapshot);
		}
		
		protected function view_dragEnterHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat(getQualifiedClassName(Sticker)))
			{
				DragManager.acceptDragDrop(workArea);
			}
		}
		
		protected function view_dragDropHandler(event:DragEvent):void
		{
			var sticker:Sticker = Sticker(event.dragSource.dataForFormat(
					getQualifiedClassName(Sticker)));
			dispatch(new AddStickerEvent(AddStickerEvent.ADD_STICKER, sticker, 
					wcModel.workArea.mouseX, wcModel.workArea.mouseY));
		}
		
		/**
		 * Selected elements in the drag rectangle.  This is overridden because we must specify
		 * a search level of one.  That is, we will look in the first children layer of contentGroup
		 * for any elements instead of looking at children of contentGroup itself.  This we do
		 * because we have layers inside contentGroup and we don't want to select the layers
		 * themselves. 
		 */ 
		override protected function getElementsInSelectionRect(event:MouseEvent):void
		{
			selectedElements = new Vector.<Element>();
			var globalRelease:Point = new Point( event.stageX, event.stageY );
			findAllElements(workArea.contentGroup as UIComponent, globalRelease, 1);
			model.selectionManager.elements = selectedElements;
		}
		
		protected function dispatcher_takingSnapshot(event:ArtworkEvent):void
		{
			// Clear the selection so the transform handles and selection bounds don't show
			// up in the snapshot.
			wcModel.selectionManager.clear();
			// Must validate now since the snapshot will be taken in the current frame.
			workArea.selectionLayer.transformLayer.validateNow();
		}
	}
}