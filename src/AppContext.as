package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	import us.ut.lib.slcpl.controller.AddStickerCommand;
	import us.ut.lib.slcpl.controller.ClearArtworkCommand;
	import us.ut.lib.slcpl.controller.LoadStickerFxgCommand;
	import us.ut.lib.slcpl.controller.LoadStickerMetadataCommand;
	import us.ut.lib.slcpl.controller.LoadSwatchesCommand;
	import us.ut.lib.slcpl.controller.SaveArtworkCommand;
	import us.ut.lib.slcpl.controller.events.AddStickerEvent;
	import us.ut.lib.slcpl.controller.events.ArtworkEvent;
	import us.ut.lib.slcpl.controller.events.LoadStickerFxgEvent;
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.service.ArtworkService;
	import us.ut.lib.slcpl.service.StickerFXGService;
	import us.ut.lib.slcpl.service.StickerMetadataService;
	import us.ut.lib.slcpl.service.interfaces.IArtworkService;
	import us.ut.lib.slcpl.service.interfaces.IStickerFXGService;
	import us.ut.lib.slcpl.service.interfaces.IStickerMetadataService;
	import us.ut.lib.slcpl.service.interfaces.ISwatchService;
	import us.ut.lib.slcpl.service.stubs.StubbedStickerMetadataService;
	import us.ut.lib.slcpl.service.stubs.StubbedSwatchService;
	import us.ut.lib.slcpl.view.DragShapesHint;
	import us.ut.lib.slcpl.view.DragShapesHintMediator;
	import us.ut.lib.slcpl.view.Menu;
	import us.ut.lib.slcpl.view.MenuMediator;
	import us.ut.lib.slcpl.view.StickerDataGroup;
	import us.ut.lib.slcpl.view.StickerDataGroupMediator;
	import us.ut.lib.slcpl.view.StoryTextArea;
	import us.ut.lib.slcpl.view.StoryTextAreaMediator;
	import us.ut.lib.slcpl.view.SwatchList;
	import us.ut.lib.slcpl.view.SwatchListMediator;
	import us.ut.lib.slcpl.view.Toolbox;
	import us.ut.lib.slcpl.view.ToolboxMediator;
	import us.ut.lib.slcpl.view.editor.MyEaselWorkarea;
	import us.ut.lib.slcpl.view.editor.MyEaselWorkareaMediator;
	import us.ut.lib.slcpl.view.editor.StickerElement;
	
	import watercolor.controller.*;
	import watercolor.controller.mediators.ElementMediator;
	import watercolor.controller.mediators.GroupMediator;
	import watercolor.controller.mediators.LayerMediator;
	import watercolor.controller.mediators.WorkareaMediator;
	import watercolor.elements.Element;
	import watercolor.elements.Ellipse;
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.elements.Rect;
	import watercolor.elements.components.Workarea;
	import watercolor.events.ElementEvent;
	import watercolor.events.GenericExecuteEvent;
	import watercolor.models.WaterColorModel;
	
	public class AppContext extends Context
	{
		public function AppContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			// WaterColor Commands
			commandMap.mapEvent(ElementEvent.TRANSFORM, TransformElementsCommand, ElementEvent);
			commandMap.mapEvent(GenericExecuteEvent.GENERIC_EXECUTE, GenericCommand, GenericExecuteEvent);
			commandMap.mapEvent(ElementEvent.POSITION_CHANGE, ChangeElementPositionCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.ADD, AddElementCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.REMOVE, RemoveElementCommand, ElementEvent);
			
			// WaterColor Mediators
			mediatorMap.mapView(Rect, ElementMediator, Element);
			mediatorMap.mapView(Ellipse, ElementMediator, Element);
			mediatorMap.mapView(Group, ElementMediator, Element);
			mediatorMap.mapView(StickerElement, ElementMediator, Element);
			mediatorMap.mapView(MyEaselWorkarea, MyEaselWorkareaMediator, Workarea);
			mediatorMap.mapView(Layer, LayerMediator, Layer);
			
			// Not sure if we'll need this yet.
			commandMap.mapEvent(KeyboardEvent.KEY_DOWN, KeyboardCommand);
			
			// Commands
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadStickerMetadataCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadSwatchesCommand, ContextEvent);
			commandMap.mapEvent(LoadStickerFxgEvent.LOAD_STICKER_FXG, LoadStickerFxgCommand, LoadStickerFxgEvent);
			commandMap.mapEvent(ArtworkEvent.CLEAR, ClearArtworkCommand, ArtworkEvent);
			commandMap.mapEvent(ArtworkEvent.SAVE, SaveArtworkCommand, ArtworkEvent);
			commandMap.mapEvent(AddStickerEvent.ADD_STICKER, AddStickerCommand, AddStickerEvent);
			
			mediatorMap.mapView(Toolbox, ToolboxMediator);
			mediatorMap.mapView(StickerDataGroup, StickerDataGroupMediator);
			mediatorMap.mapView(SwatchList, SwatchListMediator);
			mediatorMap.mapView(Menu, MenuMediator);
			mediatorMap.mapView(DragShapesHint, DragShapesHintMediator);
			mediatorMap.mapView(StoryTextArea, StoryTextAreaMediator);
			
			// Models
			injector.mapSingleton(WaterColorModel);
			injector.mapSingleton(AppModel);
			
			// Services
			injector.mapSingletonOf(IStickerFXGService, StickerFXGService);
			injector.mapSingletonOf(IStickerMetadataService, StickerMetadataService);
			//injector.mapSingletonOf(IStickerMetadataService, StubbedStickerMetadataService);
			injector.mapSingletonOf(ISwatchService, StubbedSwatchService);
			injector.mapSingletonOf(IArtworkService, ArtworkService);
			
			// Will create mediator for main app view. Needs to happen after all other mappings.
			mediatorMap.mapView(MyEasel, MyEaselMediator);
			
			super.startup();
		}
	}
}