package us.ut.lib.slcpl.view
{
	import spark.components.Button;
	
	[SkinState("saving")]
	public class SaveButton extends Button
	{
		private var _savingArtwork:Boolean;
		
		public function get savingArtwork():Boolean
		{
			return _savingArtwork;
		}
		
		public function set savingArtwork(value:Boolean):void
		{
			if (_savingArtwork != value)
			{
				_savingArtwork = value;
				invalidateSkinState();
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (savingArtwork)
			{
				return 'saving';
			}
			else
			{
				return super.getCurrentSkinState();
			}
		}
	}
}