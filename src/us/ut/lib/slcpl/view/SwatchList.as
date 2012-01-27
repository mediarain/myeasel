package us.ut.lib.slcpl.view
{
	import mx.core.ClassFactory;
	
	import spark.components.List;
	import spark.layouts.TileLayout;
	import spark.layouts.TileOrientation;
	
	public class SwatchList extends List
	{
		public function SwatchList()
		{
			super();
			focusEnabled = false;
			var tileLayout:TileLayout = new TileLayout();
			tileLayout.requestedColumnCount = 2;
			tileLayout.orientation = TileOrientation.COLUMNS;
			tileLayout.verticalGap = tileLayout.horizontalGap = 3;
			layout = tileLayout;
			itemRenderer = new ClassFactory(SwatchRenderer);
			setStyle('borderVisible', false);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dataProvider)
			{
				var rows:uint = Math.ceil(dataProvider.length / 2);
				// Make the renderers fit within the height of the list.
				// The -.01 is to make the renderers are under the full height and not over due
				// to small rounding issues.
				TileLayout(layout).rowHeight = TileLayout(layout).columnWidth = 
					((height - (TileLayout(layout).verticalGap * (rows - 1))) / rows) - .01; 
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			// Shrink the width of the list to just show the swatches.
			measuredWidth = (TileLayout(layout).columnCount * TileLayout(layout).columnWidth) + 
				((TileLayout(layout).columnCount - 1) * TileLayout(layout).horizontalGap); 
		}
	}
}