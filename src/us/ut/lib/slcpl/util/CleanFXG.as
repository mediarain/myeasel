package us.ut.lib.slcpl.util
{
	public class CleanFXG
	{
		/**
		 * function to clean the fxg xml data from unwanted tags and character codes representing line breaks
		 */ 
		public static function cleanFXGData(fxg:XML):XML
		{                
			var text:String = fxg.toXMLString();
			
			// Remove the xml file tag                
			text = text.replace('<?xml version="1.0" encoding="utf-8" ?>', "");
			
			// Remove the default FXG namespace
			text = text.replace('xmlns="http://ns.adobe.com/fxg/2008"', "");
			
			// Remove Private tags
			text = text.replace( /<Private\/>/g, "");
			text = text.replace( /<Private.*<\/Private>/gs, "");            
			
			// Remove Library tags
			text = text.replace( /<Library\/>/g, "");
			text = text.replace( /<Library.*<\/Library>/gs, "");  
			
			// Remove Library tags
			text = text.replace( /<Definition\/>/g, "");
			text = text.replace( /<Definition.*<\/Definition>/gs, "");  
			
			// Remove tool specific attributes
			// (this list may be incomplete)
			text = text.replace( / ai:\w+=\"[^\"]*\"/g, "");
			text = text.replace( / flm:\w+=\"[^\"]*\"/g, "");
			text = text.replace( / ATE:\w+=\"[^\"]*\"/g, "");
			text = text.replace( / pd:\w+=\"[^\"]*\"/g, "");
			text = text.replace( / d:\w+=\"[^\"]*\"/g, "");
			//text = text.replace( / xmlns:\w+=\"[^\"]*\"/g, "");
			
			text = text.replace( /@Embed\('/g, "");
			text = text.replace( /'\)/g, "");
			
			// remove these line breaks that may appear
			text = text.replace(/&#xD;/g, " ");
			text = text.replace(/&#xA;/g, " ");
			text = text.replace(/&#x9;/g, " ");
			
			return new XML(text);
		}
	}
}