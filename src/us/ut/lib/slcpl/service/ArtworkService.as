package us.ut.lib.slcpl.service
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import org.robotlegs.mvcs.Actor;
	
	import us.ut.lib.slcpl.controller.events.StatusMessageEvent;
	import us.ut.lib.slcpl.model.AppModel;
	import us.ut.lib.slcpl.model.Config;
	import us.ut.lib.slcpl.service.interfaces.IArtworkService;
	
	public class ArtworkService extends Actor implements IArtworkService
	{
		[Inject]
		public var appModel:AppModel;
		
		protected const SUCCESS_MESSAGE:String = 'Image saved!';
		protected const ERROR_MESSAGE:String = 'Error saving. Sorry! Please try again.';
		
		//protected const UPLOAD_ENDPOINT:String = "http://aaronhardy.com/uploadtest/savedesign.php";
		protected const UPLOAD_ENDPOINT:String = Config.prependGateway("/easelLists/saveThumb?format=png");
		
		// Somewhat arbitrarily chosen by thumbnail needs for the website.
		protected const UPLOAD_WIDTH:Number = 152;
		protected const UPLOAD_HEIGHT:Number = 110;
		
		// 11" x 8.5" @ 150 dpi
		protected const DOWNLOAD_WIDTH:Number = 1650;
		protected const DOWNLOAD_HEIGHT:Number = 1275;
		
		protected var file:FileReference;
		protected var uploader:URLLoader;
		protected var artwork:DisplayObject;
		protected var artworkAndStory:DisplayObject;
		
		public function save(artwork:DisplayObject, artworkAndStory:DisplayObject):void
		{
			// If we're still in the process of saving or uploading, bail.
			if (!this.artwork)
			{
				this.artwork = artwork;
				this.artworkAndStory = artworkAndStory;
				appModel.savingArtwork = true;
				file = new FileReference();
				addFileListeners();
				var bytes:ByteArray = getPngBytes(artworkAndStory, DOWNLOAD_WIDTH, DOWNLOAD_HEIGHT);
				file.save(bytes, 'artwork.png');
			}
		}
		
		protected function file_cancelHandler(event:Event):void
		{
			removeFileListeners();
			file = null;
			artwork = artworkAndStory = null;
			appModel.savingArtwork = false;
		}
		
		protected function file_completeHandler(event:Event):void
		{
			removeFileListeners();
			file = null;
			upload();
		}
		
		protected function file_errorHandler(event:ErrorEvent):void
		{
			removeFileListeners();
			file = null; 
			artwork = artworkAndStory = null;
			appModel.savingArtwork = false;
			dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
		}
		
		protected function addFileListeners():void
		{
			file.addEventListener(Event.CANCEL, file_cancelHandler, false, 0, true);
			file.addEventListener(Event.COMPLETE, file_completeHandler, false, 0, true);
			file.addEventListener(IOErrorEvent.IO_ERROR, file_errorHandler, false, 0, true);
		}
		
		protected function removeFileListeners():void
		{
			file.removeEventListener(Event.CANCEL, file_cancelHandler);
			file.removeEventListener(Event.COMPLETE, file_completeHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, file_errorHandler);
		}
		
		//-----------------------------------------------------
		
		protected function upload():void
		{
			var request:URLRequest = new URLRequest(UPLOAD_ENDPOINT);
			request.contentType = "application/octet-stream";
			request.method = URLRequestMethod.POST;
			
			// Encode bitmap to PNG and set it as our request data.
			request.data = getPngBytes(artwork, UPLOAD_WIDTH, UPLOAD_HEIGHT);
			
			// Attach listeners and send the request.
			uploader = new URLLoader();
			addUploaderListeners();
			uploader.load(request);
		}
		
		protected function uploader_completeHandler(event:Event):void
		{
			removeUploaderListeners();
			uploader = null; 
			artwork = artworkAndStory = null;
			appModel.savingArtwork = false;
			dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, SUCCESS_MESSAGE, false));
		}
		
		protected function uploader_errorHandler(event:ErrorEvent):void
		{
			removeUploaderListeners();
			uploader = null;
			artwork = artworkAndStory = null;
			appModel.savingArtwork = false;
			dispatch(new StatusMessageEvent(StatusMessageEvent.SHOW_MESSAGE, ERROR_MESSAGE, true));
		}
		
		protected function addUploaderListeners():void
		{
			uploader.addEventListener(Event.COMPLETE, uploader_completeHandler, false, 0, true);
			uploader.addEventListener(IOErrorEvent.IO_ERROR, uploader_errorHandler, false, 0, true);
		}
		
		protected function removeUploaderListeners():void
		{
			uploader.removeEventListener(Event.COMPLETE, uploader_completeHandler);
			uploader.removeEventListener(IOErrorEvent.IO_ERROR, uploader_errorHandler);
		}

// A start for PDF support if we ever need it.  This uses AlivePDF.  Although it does in fact
// create a PDF, the contents don't remain vector-based.
//		protected function getPdfBytes():ByteArray
//		{
//			var printPDF:PDF = new PDF(Orientation.LANDSCAPE, Unit.MM, Size.A4);
//			printPDF.setDisplayMode(Display.FULL_PAGE, Layout.SINGLE_PAGE);
//			printPDF.addPage();
//			printPDF.addImage(artwork, new Resize(Mode.FIT_TO_PAGE, Position.CENTERED));
//			var byteArray:ByteArray = printPDF.save(Method.LOCAL);
//			return byteArray;
//		}
		
		protected function getPngBytes(displayObject:DisplayObject, width:Number, height:Number):ByteArray
		{
			var bitmapData:BitmapData = new BitmapData(width, height);
			var matrix:Matrix = new Matrix();
			// Scale the artwork up to the requested dimensions without skewing.
			var scale:Number = Math.min(width / displayObject.width, height / displayObject.height);
			matrix.scale(scale, scale);
			// Center the artwork within the area.
			matrix.tx = width / 2 - (displayObject.width * scale) / 2;
			matrix.ty = height / 2 - (displayObject.height * scale) / 2;
			bitmapData.draw(displayObject, matrix);
			var byteArray:ByteArray = new PNGEncoder().encode(bitmapData);
			return byteArray;
		}
	}
}