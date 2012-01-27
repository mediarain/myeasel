package us.ut.lib.slcpl.service
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	import us.ut.lib.slcpl.controller.events.StatusMessageEvent;
	import us.ut.lib.slcpl.model.vo.Sticker;
	import us.ut.lib.slcpl.service.interfaces.IStickerFXGService;
	import us.ut.lib.slcpl.util.CleanFXG;
	
	/**
	 * Loads the FXG for a sticker.
	 */
	public class StickerFXGService extends Actor implements IStickerFXGService
	{
		protected const ERROR_MESSAGE:String = 'Error loading sticker elements.';
		
		protected var stickerByLoader:Dictionary = new Dictionary(false);
		protected var stickersLoading:Vector.<Sticker> = new Vector.<Sticker>();
		
		public function loadStickerFxg(sticker:Sticker):void
		{
			if (stickersLoading.indexOf(sticker) == -1)
			{
				var loader:URLLoader = new URLLoader();
				indexAndAddListeners(loader, sticker);
				loader.load(new URLRequest(sticker.url));
			}
		}
		
		protected function loader_completeHandler(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var sticker:Sticker = stickerByLoader[loader];
			
			try
			{
				var fxg:String = loader.data;
				sticker.fxg = CleanFXG.cleanFXGData(new XML(fxg));
			}
			catch (error:Error)
			{
				dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
			}
			finally
			{
				deindexAndRemoveListeners(loader);
			}
		}
		
		protected function loader_errorHandler(event:Event):void
		{
			dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
			deindexAndRemoveListeners(URLLoader(event.target));
		}
		
		protected function indexAndAddListeners(loader:URLLoader, sticker:Sticker):void
		{
			loader.addEventListener(Event.COMPLETE, loader_completeHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler, false, 0, true);
			stickerByLoader[loader] = sticker;
			stickersLoading.push(sticker);
		}
		
		protected function deindexAndRemoveListeners(loader:URLLoader):void
		{
			loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			var sticker:Sticker = stickerByLoader[loader];
			delete stickerByLoader[loader];
			stickersLoading.splice(stickersLoading.indexOf(sticker), 1);
		}
	}
}