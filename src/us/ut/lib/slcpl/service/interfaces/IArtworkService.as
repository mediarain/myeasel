package us.ut.lib.slcpl.service.interfaces
{
	import flash.display.DisplayObject;

	public interface IArtworkService
	{
		function save(artwork:DisplayObject, artworkAndStory:DisplayObject):void;
	}
}