package us.ut.lib.slcpl.controller
{
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import org.robotlegs.mvcs.Command;
	
	import us.ut.lib.slcpl.controller.events.AddStickerEvent;
	import us.ut.lib.slcpl.controller.events.LoadStickerFxgEvent;
	import us.ut.lib.slcpl.model.events.StickerEvent;
	import us.ut.lib.slcpl.view.editor.MyEaselWorkarea;
	import us.ut.lib.slcpl.view.editor.StickerElement;
	
	import watercolor.commands.vo.CreateVO;
	import watercolor.commands.vo.DeleteVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.Position;
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Element;
	import watercolor.events.GenericExecuteEvent;
	import watercolor.factories.fxg.GroupFactory;
	import watercolor.factories.fxg.util.URIManager;
	import watercolor.models.WaterColorModel;
	
	public class AddStickerCommand extends Command
	{
		[Inject]
		public var event:AddStickerEvent;
		
		[Inject]
		public var wcModel:WaterColorModel;
		
		override public function execute():void
		{
			super.execute();
			
			// If the FXG is already loaded, we can immediately add the sticker.
			if (event.sticker.fxg)
			{
				addsticker();
			}
			else
			{
				// TODO:
				// This could pose an issue where we trigger the FXG to load for a sticker but
				// it fails to load.  We never hear about the failure and it never completes so
				// this command stays in memory.  The chances are small, the repercussions are
				// fairly small, and the workaround may take a while.  As such, we're holding
				// off on a fix.
				commandMap.detain(this);
				event.sticker.addEventListener(StickerEvent.FXG_CHANGED, fxgChangedHandler, false, 0, true);
				dispatch(new LoadStickerFxgEvent(LoadStickerFxgEvent.LOAD_STICKER_FXG, event.sticker));
			}
		}
		
		/**
		 * Handles the completion of FXG being loaded.
		 */
		protected function fxgChangedHandler(fxgChangedEvent:Event):void
		{
			commandMap.release(this);
			event.sticker.removeEventListener(StickerEvent.FXG_CHANGED, fxgChangedHandler);
			addsticker();
		}
		
		/**
		 * Performs the work of adding the sticker after the FXG has been loaded.
		 */
		protected function addsticker():void
		{
			var element:Element = GroupFactory.createSparkFromFXG(event.sticker.fxg, 
				new URIManager(event.sticker.fxg), new StickerElement());
			
			if (event.sticker.isBackground)
			{
				switchBackground(element);
			}
			else
			{
				addElement(element); 
			}
		}
		
		/**
		 * Removes the old background and uses the sticker as the new background.
		 */
		protected function switchBackground(element:Element):void
		{
			var groupCommand:GroupCommandVO = new GroupCommandVO();
			for (var i:uint = 0; i < MyEaselWorkarea(wcModel.workArea).backgroundLayer.numElements; i++)
			{
				var existingElement:Element = 
					Element(MyEaselWorkarea(wcModel.workArea).backgroundLayer.getElementAt(i));
				var deleteVO:DeleteVO = new DeleteVO(existingElement, existingElement.getPosition());
				groupCommand.addCommand(deleteVO);
			}
			
			element.mouseEnabled = false; // So it's not transformable/selectable.
			var createVO:CreateVO = new CreateVO(element, 
				new Position(MyEaselWorkarea(wcModel.workArea).backgroundLayer, 0));
			groupCommand.addCommand(createVO);
			
			// Make it fit the workarea and centered.
			var scale:Number = Math.min(
				wcModel.workArea.width / element.width,
				wcModel.workArea.height / element.height);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.tx = wcModel.workArea.width / 2 - (element.width * scale) / 2;
			matrix.ty = wcModel.workArea.height / 2 - (element.height * scale) / 2;
			
			var transformVO:TransformVO = new TransformVO();
			transformVO.element = element;
			transformVO.newMatrix = matrix;
			groupCommand.addCommand(transformVO);
			
			dispatch(new GenericExecuteEvent(GenericExecuteEvent.GENERIC_EXECUTE, groupCommand));
		}
		
		/**
		 * Adds the sticker.
		 */
		protected function addElement(element:Element):void
		{
			var groupCommand:GroupCommandVO = new GroupCommandVO();
			var createVO:CreateVO = new CreateVO(element,
				new Position(MyEaselWorkarea(wcModel.workArea).contentLayer, 
					MyEaselWorkarea(wcModel.workArea).contentLayer.numElements));
			groupCommand.addCommand(createVO);
			
			var matrix:Matrix = new Matrix();
			matrix.tx = event.workAreaX - element.width / 2 ;
			matrix.ty = event.workAreaY - element.width / 2;
			
			var transformVO:TransformVO = new TransformVO();
			transformVO.element = element;
			transformVO.newMatrix = matrix;
			groupCommand.addCommand(transformVO);
			
			dispatch(new GenericExecuteEvent(GenericExecuteEvent.GENERIC_EXECUTE, groupCommand)); 
			wcModel.selectionManager.clear();
			wcModel.selectionManager.addElement(element);
		}
	}
}