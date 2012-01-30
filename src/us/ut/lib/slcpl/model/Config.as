package us.ut.lib.slcpl.model
{
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.utils.URLUtil;
	
	import spark.components.Application;

	public class Config
	{
		/**
		 * If running locally, prepends a gateway url to point to the correct server.
		 */
		public static function prependGateway(url:String):String
		{
			if (url.indexOf('http://') == -1 && 
					Application(FlexGlobals.topLevelApplication).url.indexOf('file://') > -1)
			{
				//return 'http://slcpl.hyrumt.dev.rain.local' + url;
				return 'http://www.slcpl.lib.ut.us' + url;
			}
			return url;
		}
	}
}