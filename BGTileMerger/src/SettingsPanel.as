// Project BGTileMapEditorFile
package  {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JSeparator;
	import org.aswing.JSpacer;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import org.aswing.SolidBackground;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 16.02.2012 14:58
	 */
	public class SettingsPanel extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function SettingsPanel (w:uint, h:uint) {
			prepare(w,h);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		private function prepare(w:uint, h:uint):void {
			savePanel = new JPanel();
			addChild(savePanel);
			savePanel.setLayout(new FlowLayout(FlowLayout.LEFT, 5, 3));
			savePanel.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			savePanel.setPreferredWidth(w);
			savePanel.setPreferredHeight(h);
			
			var ww_:uint;
			//s
			var bClose:JButton = new JButton("Save all settings");
			bClose.name='save';
			bClose.addActionListener(panelButtons);
			bClose.setPreferredHeight(20);
			bClose.pack();bClose.validate();
			savePanel.append(bClose);
			ww_+=bClose.getWidth();
			
			//l
			bClose = new JButton("Load all settings");
			bClose.name='load';
			bClose.addActionListener(panelButtons);
			bClose.setPreferredHeight(20);
			bClose.pack();bClose.validate();
			savePanel.append(bClose);
			ww_+=bClose.getWidth();
			
			//var s:JSpacer = new JSpacer();
			//savePanel.append(s);
			
			//c
			bClose = new JButton("Close");
			bClose.name='close';
			bClose.addActionListener(panelButtons);
			
			bClose.setPreferredHeight(40);
			bClose.pack();bClose.validate();
			var bc:JButton = addChild(bClose);
			bClose.x=w-bClose.getWidth();
			
			//apply
			bClose = new JButton("Apply");
			bClose.name='apply';
			bClose.addActionListener(panelButtons);
			
			bClose.setPreferredHeight(40);
			bClose.pack();bClose.validate();
			bClose.x=w-bClose.getWidth();
			bClose.y=40;
			//addChild(bClose);
			
			
			//samples
			bClose = new JButton("Get sample files zip (example settings, images, masks, map data, ... packed to .zip file) - internet connection not needed, zip embedded to the application");
			bClose.name='samples';
			bClose.addActionListener(panelButtons);
			bClose.setPreferredHeight(20);
			bClose.setPreferredWidth(w-9-bc.width);
			bClose.pack();bClose.validate();
			//savePanel.append(bClose);
			
			
			savePanel.append(new JSeparator(JSeparator.HORIZONTAL));
			
			//w and h
			var tl0:JLabel=new JLabel('Block(Tile) size:');
			tl0.setHorizontalAlignment(JLabel.LEFT);
			tl0.setBackground(new ASColor(0x004030));tl0.setForeground(new ASColor(0x00ffbf));
			savePanel.append(tl0);
			
			bw=new JTextField('100',11);bw.setRestrict('0123456789');
			bw.setBackground(new ASColor(0x004030));bw.setForeground(new ASColor(0x00ffbf));
			savePanel.append(bw);
			//'x'
			tl0=new JLabel('x');
			tl0.setHorizontalAlignment(JLabel.LEFT);
			tl0.setBackground(new ASColor(0x004030));tl0.setForeground(new ASColor(0x00ffbf));
			savePanel.append(tl0);
			bh=new JTextField('50',11);bh.setRestrict('0123456789');
			bh.setBackground(new ASColor(0x004030));bh.setForeground(new ASColor(0x00ffbf));
			savePanel.append(bh);
			
			
			
			//images
			tl0=new JLabel('images:(one per line, press ENTER to add new line)');
			tl0.setHorizontalAlignment(JLabel.LEFT);
			tl0.setPreferredWidth(w-9);
			tl0.setBackground(new ASColor(0x004030));tl0.setForeground(new ASColor(0x00ffbf));
			savePanel.append(tl0);
			
			//title input
			pImagesListText=new JTextArea();
			pImagesListText.setBackground(new ASColor(0x004030));
			pImagesListText.setForeground(new ASColor(0x00ffbf));
			pImagesListText.setText('server/images/01.png\nserver/images/02.png');
			pImagesListText.setPreferredWidth(w-9);
			pImagesListText.setPreferredHeight((h-130)/2);
			savePanel.append(pImagesListText);
			
			
			//w
			var wl:JLabel=new JLabel('masks:(one per line). black and white png file with 256 transparency levels');
			wl.setHorizontalAlignment(JLabel.LEFT);
			wl.setPreferredWidth(w-9);
			wl.setBackground(new ASColor(0x004030));wl.setForeground(new ASColor(0x00ffbf));
			savePanel.append(wl);
			
			savePanel.append(new JSeparator(JSeparator.HORIZONTAL));
			
			pMasksListText=new JTextArea();
			pMasksListText.setBackground(new ASColor(0x004030));
			pMasksListText.setForeground(new ASColor(0x00ffbf));
			pMasksListText.setText('server/masks/01.png\nserver/masks/02.png');
			pMasksListText.setPreferredWidth(w-9);
			pMasksListText.setPreferredHeight((h-130)/2);
			savePanel.append(pMasksListText);
			
			savePanel.pack();savePanel.validate();
		}
		
		
		private function panelButtons(e:Event):void {
			var i:uint;
			switch (e.target.name) {
			
			case 'close':
				i = ID_BUTTON_CLOSE;
				break;
			case 'apply':
				i = ID_BUTTON_APPLY;
				break;
			
			case 'load':
				i = ID_BUTTON_LOAD;
				break;
			
			case 'save':
				i = ID_BUTTON_SAVE;
				break;
			
			case 'samples':
				i = ID_BUTTON_GET_SAMPLE_FILES;
				break;
			
			}
			
			if (buttonPressed0!=null) {buttonPressed0(i);}
		}
		
		
		/**
		 * @param	a (button id:uint):void;
		 */
		public function setButtonListener(a:Function):void {buttonPressed0=a;}
		private var buttonPressed0:Function;
		
		
		//{ =*^_^*= id
		public static const ID_BUTTON_SAVE:uint=0;
		public static const ID_BUTTON_LOAD:uint=1;
		public static const ID_BUTTON_CLOSE:uint=2;
		public static const ID_BUTTON_GET_SAMPLE_FILES:uint=3;
		public static const ID_BUTTON_APPLY:uint=4;
		//} =*^_^*= END OF id
		
		public function setText(bw:String, bh:String, imagesList:String, masksList:String):void {
			this.bw.setText(bw);this.bh.setText(bh);pImagesListText.setText(imagesList);pMasksListText.setText(masksList);
		}
		
		public function get_ImagesList():Array {
			if (pImagesListText.getText().length<1) {return null;}
			return pImagesListText.getText().split('\r');
		}
		public function get_MasksList():Array {
			if (pMasksListText.getText().length<1) {return null;}
			return pMasksListText.getText().split('\r');
		}
		public function get_bw():uint {return parseInt(bw.getText());}
		public function get_bh():uint {return parseInt(bh.getText());}
		
		private var pImagesListText:JTextArea;
		private var pMasksListText:JTextArea;
		private var bw:JTextField;
		private var bh:JTextField;
		private var savePanel:JPanel;
	
		
		
		public static function addButton(name:String, label:String, callBack:Function,enabled:Boolean):JButton {
			var button:JButton = new JButton(label);
			button.addActionListener(callBack);
			button.name = name;
			button.setEnabled(enabled);
			button.setForeground(new ASColor(0x00ffbf));
			button.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			return button;
		}
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]