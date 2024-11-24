package n {
	import flash.net.URLLoaderDataFormat;

	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 17.05.2012 0:31
	 */
	public class TEXTDataRequest extends GenericDataRequest {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(operationResultData:Object, operationResultCode:uint):void
		 * @param	url
		 * @param	method 0-POST, 1-GET
		 * @param	data (for POST only)
		 * @param	timeLimit 0-unlimited
		 */
		function TEXTDataRequest (listenerRef:Function, url:String, method:uint=0, data:Object=null, timeLimit:Number = 0) {
			super(listenerRef, url, method, data, timeLimit);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function getDataFormat():String {return URLLoaderDataFormat.TEXT;}
		
		
		//{ =*^_^*= id
		/**
		 * operationResultData:String
		 */
		public static const ID_ER_NO_ERROR:uint=0;
		//} =*^_^*= END OF id
		
		
		/**
		 * @param	l instance for garbage collection
		 * @param	e error id
		 */
		protected override function cb(l:JURLLoader, e:uint=0):void {
			if (e==GenericDataRequest.ID_ER_NO_ERROR) {
				pd(l);
				return;
			}
			c(l, e);
		}
		
		/**
		 * process data
		 * @param	d
		 */
		private function pd(l:JURLLoader):void {
			if (sm) {
				trace(5,'LOADED DATA FROM:'+l.get_r().url+'>\n'
					+"=============== >>>RESPONSE DATA<<< ======\n"
					+String(l.data).split('><').join('>\n<')
					+"\n=============== >>>END OF RESPONSE DATA<<< ======\n\n\n"
				);
			}
			
			c(l.data, ID_ER_NO_ERROR);
		}
		
		
		
		public static function set_showTEXTDataRequestMessages(a:Boolean):void {sm=a;}
		private static var sm:Boolean;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]