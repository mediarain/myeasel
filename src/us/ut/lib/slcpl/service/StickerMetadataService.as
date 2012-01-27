package us.ut.lib.slcpl.service
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	import us.ut.lib.slcpl.controller.events.StatusMessageEvent;
	import us.ut.lib.slcpl.controller.parsers.StickerMetadataParser;
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.Config;
	import us.ut.lib.slcpl.service.interfaces.IStickerMetadataService;
	
	public class StickerMetadataService extends Actor implements IStickerMetadataService
	{
		[Inject]
		public var model:AppModel;
		
		protected const ENDPOINT:String = Config.prependGateway('/easelLists/getLists.xml');
		protected const ERROR_MESSAGE:String = 'Error loading sticker elements.';
		
		protected var loader:URLLoader;
		
		public function loadStickerMetadata():void
		{
			if (!loader)
			{
				loader = new URLLoader();
				addLoaderListeners();
				loader.load(new URLRequest(ENDPOINT));
			}
		}
		
		protected function loader_completeHandler(event:Event):void
		{
			var categories:ArrayCollection;
			
			try
			{
				categories = new StickerMetadataParser().parse(new XML(loader.data));
			}
			catch (error:Error)
			{
				dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
			}
			finally
			{
				model.stickerCategories = categories; 
				removeLoaderListeners();
				loader = null;
			}
		}
		
		protected function loader_errorHandler(event:Event):void
		{
			dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
			removeLoaderListeners();
			loader = null;
		}
		
		protected function addLoaderListeners():void
		{
			loader.addEventListener(Event.COMPLETE, loader_completeHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler, false, 0, true);
		}
		
		protected function removeLoaderListeners():void
		{
			loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		}
	}
}