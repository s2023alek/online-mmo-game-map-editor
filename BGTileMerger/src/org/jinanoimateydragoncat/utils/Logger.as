package org.jinanoimateydragoncat.utils {
	
	//{ =^_^= import
	//import org.jinanoimateydragoncat.utils.LDate;
	//} =^_^= END OF import
	
	
	/**
	 * my simple logger =^_^=
	 * @author Jinanoimatey Dragoncat
	 * @version 1.3.1
	 * @created 04.11.2010 19:04
	 */
	public class Logger {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * Logger constructor
		 * @param	the name of the logger instance
		 * @param	displayLevel add "INFO" or "Warning: " or "ERROR #" stamp to messages
		 * @param	displayName add "name+'->'" stamp to messages
		 * @param	displayTime add timestamp to messages
		 */
		public function Logger (name:String, displayLevel:Boolean = true, displayName:Boolean = true, displayTime:Boolean=false) {
			this.name = name;
			addTimeStamp = displayTime;
			addLevelStamp = displayLevel;
			addLoggerNameStamp = displayName;
		}
		//} =^_^= END OF CONSTRUCTOR
		
		/**
		 * logs and displays message
		 * @param	message text
		 * @param	level level - default : LEVEL_INFO(display all)
		 * @forceAddTimeStamp override default addTimeStamp value for message
		 */
		public function log (message:String, level:uint=0, forceAddTimeStamp:Boolean=false):void {
			if (addLoggerNameStamp) {lastOut = name+'->';} else {lastOut = "";}
			//if (addTimeStamp || forceAddTimeStamp) {lastOut += LDate.d()+' ';}
			if (addTimeStamp || forceAddTimeStamp) {lastOut += ' ';}
			if (addLevelStamp) {lastOut += "["+ levelText[level]+ "]>";}
			lastOut += message;
			lastLevel = level;
			outText.push(lastOut);
			outLevel.push(level);
			if (level < displayLevel) {return;}
			if (out_ != null) {out_(lastOut);} else {trace(lastOut);}
			if (advOut != null) {advOut(lastOut, lastLevel);}
		}
		
		
		/**
		 * return all log messages
		 * @param	level filter by level(not filtered by default)
		 * @return
		 */
		public function getAllMessagesText (level:uint=11):String {
			if (level==11) {
				return outText.join("\n");
			} else {
				return getAllMessagesArray(level).join("\n");
			}
		}
		
		/**
		 * return all log messages
		 * @param	level filter by level(not filtered by default)
		 * @return
		 */
		public function getAllMessagesArray (level:uint=11):Array {
			if (level==11) {
				return outText.slice();
			} else {
				var customOut:Array = [];
				
				var l:uint = outText.length
				for (var i:uint = 0;i < l;i++ ) {
					if (outLevel[i] == level) {
						customOut.push(outText[i]);
					}
				}
				return customOut;
			}
		}
		
		/**
		 * message pipe
		 * attention: all messages in buffer will be fired instantly
		 */
		public function set out(value:Function):void {
			out_ = value;
			var l:uint = outText.length
			for (var i:uint = 0;i < l;i++ ) {
				out_(outText[i]);
			}
		}
		
		/**
		 * function (text:String, level:uint):void;
		 * attention: all messages in buffer will be fired instantly
		 */
		public function set advancedOut(value:Function):void {
			advOut = value;
			var l:uint = outText.length
			for (var i:uint = 0;i < l;i++ ) {
				advOut(outText[i], outLevel[i]);
			}
		}
		
		
		/**
		 * message pipe
		 */
		public function get out():Function{
			return out_;
		}
		
		/**
		 * message pipe
		 */
		public function get advancedOut():Function{
			return this.advOut;
		}
		
		
		public static const TEXT_LEVEL_INFO:String= "INFO";
		public static const TEXT_LEVEL_WARNING:String = "Warning: ";
		public static const TEXT_LEVEL_ERROR:String = "ERROR #";
		public static const LEVEL_INFO:uint = 0;
		public static const LEVEL_WARNING:uint = 1;
		public static const LEVEL_ERROR:uint = 2;
		public var addTimeStamp:Boolean = false;
		public var addLevelStamp:Boolean = true;
		public var addLoggerNameStamp:Boolean = true;
		
		/**
		 * messages above level will be passed to output. Default level is LEVEL_INFO(0)
		 */
		public var displayLevel:uint = 0;
		
		/**
		 * поясниние для русскоговорящих:
		 * названия могли быть по красивее, однако, не подсвечивались бы в FlashDevelop. Зато совместимы с стандартными сообщениями flashPlayer
		 */
		private static const levelText:Array = [TEXT_LEVEL_INFO, TEXT_LEVEL_WARNING, TEXT_LEVEL_ERROR];//willbe highlighted in FDTracer
		private var lastOut:String;
		private var lastLevel:uint;
		private var name:String;
		//private var outText:Vector.<String> = new Vector.<String>();
		private var outText:Array = [];
		//private var outLevel:Vector.<uint> = new Vector.<uint>();
		private var outLevel:Array = [];
		private var out_:Function = null;
		private var advOut:Function = null;
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 20.01.2012 22:31 + advancedOut
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]