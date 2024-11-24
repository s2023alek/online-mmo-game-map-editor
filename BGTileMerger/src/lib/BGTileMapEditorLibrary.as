// Project BGTileMapEditor
package lib {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	//} =*^_^*= END OF import
	
	
	/**
	 * Library contains image BitmapData available through public static properties. Call "initializeLibrary" static method before using Library.
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class BGTileMapEditorLibrary {
		
		//{ =*^_^*= EMBED AND PREPARE
		
		//{ =*^_^*= =*^_^*= templates
		
		//embedding font notice: use additional parameters when encountering errors 
		// fontWeight="bold", fontStyle="italic",
		
		//[Embed(source="../../res/images/swf.swf",mimeType="application/octet-stream")]
		//public static const swf:Class;
		
		//[Embed(source="swfLibs/library.swf", symbol="symbol0")]
		//public static const symbol0:Class;
		
		[Embed(source="../../res/swfLibs/LStatusLine.swf", symbol="LStatusLine")]
		public static const LStatusLine:Class;
		
		//[Embed(source="../../res/sounds/sound0.mp3")]
		//public static const sound0:Class;
		
		//[Embed(source='../../res/fonts/FONT.ttf', fontName="Font", mimeType="application/x-font-truetype")]
		//public static const font0:String;
		
		//[Embed(systemFont='Verdana', fontName="Verdana", mimeType="application/x-font-truetype")] 
		//public static const font_verdana:String; 
		
		//} =*^_^*= =*^_^*= END OF templates
		
		[Embed(source="../../build.txt",mimeType="application/octet-stream")]
		private static const build_txt:Class;
		public static var build:String;
		
		

		
		//} =*^_^*= END OF EMBED AND PREPARE
	
		
		//{ =*^_^*= CONSTRUCTOR
		function BGTileMapEditorLibrary () {throw(new ArgumentError('Library contains images that available through public static properties. Invoke "initialize" static method before using Library.'));}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		
		/**
		 * prepare library for using
		 */
		public static function initialize(completeRef:Function=null):void{
			completeRef_ = completeRef;
			parseBuildNum();
			createBitmaps();
			//processBitmaps();
			initialized();
		}
		private static function initialized():void {
			if (completeRef_ != null) {completeRef_();}
		}
		
		private static function parseBuildNum():void {
			var ba:ByteArray = ByteArray(new build_txt());
			build = ba.readUTFBytes(ba.length);
		}
		
		private static function createBitmaps():void {
		}
		
		private static var completeRef_:Function;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]]