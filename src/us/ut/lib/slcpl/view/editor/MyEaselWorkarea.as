package us.ut.lib.slcpl.view.editor
{
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.elements.components.Workarea;
	
	public class MyEaselWorkarea extends Workarea
	{
		[SkinPart(type="watercolor.elements.Layer", required="true")]
		public var backgroundLayer:Layer;
		
		[SkinPart(type="watercolor.elements.Layer", required="true")]
		public var contentLayer:Layer;
	}
}