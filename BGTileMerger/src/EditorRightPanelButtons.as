package {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import org.aswing.colorchooser.VerticalLayout;
	import flash.display.Sprite;
	import org.aswing.FlowLayout;
	//} =^_^= END OF import
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 24.01.2012 0:34
	 */
	public class EditorRightPanelButtons {
		
		//{ =^_^= CONSTRUCTOR
		
		function EditorRightPanelButtons (w:uint, h:uint, listener:Function) {
			this.w=w;
			this.h=h;
			this.buttonPressed0=listener;
			
			prepareButtons(w,h);
		}
		//} =^_^= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= buttons &combo box
		
		//{ =*^_^*= id
		public static const ID_BUTTON_LOAD:uint=0;
		public static const ID_BUTTON_SAVE:uint=1;
		public static const ID_BUTTON_NEW:uint=2;
		public static const ID_BUTTON_SAVE0:uint=3;
		public static const ID_BUTTON_SETTINGS:uint=4;		
		public static const ID_BUTTON_NEW_MASK:uint=5;		
		public static const ID_BUTTON_LOG:uint=6;		
		public static const ID_BUTTON_CLOSE:uint=7;		
		public static const ID_BUTTON_NONE:uint=8;		
		//} =*^_^*= END OF id
		
		private var buttonPressed0:Function;
		//} =*^_^*= END OF buttons &combo box
		
		//{ =*^_^*= prepare
		private function prepareButtons(w:uint, h:uint):void {
			buttonsPanel = new ControlsPanel(buttonPressed0);
			buttonsPanel.setLayout(new VerticalLayout(VerticalLayout.CENTER, 3));
			
			buttonsPanel.createSimplePanel(
			[
				"Config"
				,"Log"
				,"Load\ndata"
				,"Save\ndata"
				,"New\nMap"
				,"Save\nImage"
				,"New\nTile"
				,""
				,""
				,""
				,""
				,""
				,"Exit"
			]
			,[
				ID_BUTTON_SETTINGS
				,ID_BUTTON_LOG
				,ID_BUTTON_LOAD
				,ID_BUTTON_SAVE
				,ID_BUTTON_NEW
				,ID_BUTTON_SAVE0
				,ID_BUTTON_NEW_MASK
				,ID_BUTTON_NONE
				,ID_BUTTON_NONE
				,ID_BUTTON_NONE
				,ID_BUTTON_NONE
				,ID_BUTTON_NONE
				,ID_BUTTON_CLOSE
			]
			);
		}
		
		//} =*^_^*= END OF prepare
		
		//{ =*^_^*= private
		public function get_container():DisplayObject {return buttonsPanel;}
		
		private var buttonsPanel:ControlsPanel;
		
		private var w:uint;
		private var h:uint;
		//} =*^_^*= END OF private
		
	}
}


//{ =^_^= import
import org.aswing.ASColor;
import org.aswing.JPanel;
import org.aswing.JButton;
import flash.display.Sprite;
import flash.events.Event;
import org.aswing.SolidBackground;
//} =^_^= END OF import
/**
 * 
 * @author Jinanoimatey Dragoncat
 * @version 0.0.0
 * @created 15.12.2010 18:05
 */
class ControlsPanel extends JPanel {
	
	function ControlsPanel (buttonPressedCallback:Function) {
		buttonPressedRef = buttonPressedCallback;
	}
	
	/**
	 * @param	title titles
	 * @param	id names
	 */
	public function createSimplePanel(title:Array, id:Array):void {
		this.id=id;
		var b:JButton;
		for (var i:uint in title) {
			b = addButton('b'+id[i],title[i],el_button,true);
			buttons.push(b);
			append(b);
		}
		pack();
		validate();
	}
	
	private function el_button(e:Event):void {
		buttonPressedRef(id[buttons.indexOf(e.target)]);
	}
	
	public static function addButton(name:String, label:String, callBack:Function,enabled:Boolean):JButton {
		var button:JButton = new JButton(label);
		button.addActionListener(callBack);
		button.name = name;
		button.setEnabled(enabled);
		button.setForeground(new ASColor(0x00ffbf));
		button.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
		return button;
	}
	private var buttonPressedRef:Function;
	private var buttons:Vector.<JButton> = new Vector.<JButton>();
	private var id:Array;
	
	
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:15.01.2011_[00#08#13]_[6]