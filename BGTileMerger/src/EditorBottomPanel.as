package {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.EmptyLayout;
	import org.aswing.FlowLayout;
	import org.aswing.FlowWrapLayout;
	import org.aswing.GridLayout;
	import org.aswing.JButton;
	import org.aswing.JComboBox;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JScrollBar;
	import org.aswing.JScrollPane;
	import org.aswing.JSeparator;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import org.aswing.SolidBackground;
	import org.aswing.VectorListModel;
	import org.aswing.WindowLayout;
	//} =^_^= END OF import
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 24.01.2012 0:34
	 */
	public class EditorBottomPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		private var testMode:Boolean=Boolean(0);
		
		function EditorBottomPanel (w:uint, h:uint) {
			this.w=w;
			this.h=h;
			
			container=new Sprite();
			
			scrollBar.pack();scrollBar.validate();
			//super(new VerticalLayout(VerticalLayout.CENTER,1));
			mainPanel = container.addChild(new JPanel());
			mainPanel.setLayout(new BorderLayout());
			mainPanel.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			
			mainPanel.setPreferredWidth(w);
			mainPanel.setPreferredHeight(h);
			
			
			mainPanel.pack();mainPanel.validate();
			if (!testMode) {return;}
			//{ ^_^ test
			var vs:Vector.<String> = new Vector.<String>();
			var vim:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var vid:Vector.<uint> = new Vector.<uint>();
			var sp:Sprite;
			for (var i:int = 0; i < 55; i++) {
				sp = new Sprite();
				sp.graphics.beginFill(0x00ff00);
				sp.graphics.drawRect(0,0, 180, 100);
				vs.push('title '+i);
				vim.push(sp);
				vid.push(i);
			}
			
			setImageListener(function(a:uint):void{trace('im:'+a);});
			setContent(vs, vim, vid, 3);
			
			//} ^_^ END OF test
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function showMsgPanel(message:String, title:String='message', hideYesButton:Boolean=true, inputMode:
			Boolean=false):void {
			if (inputMode) {hideYesButton=false;}
			
			if (message==null) {message='';}
			if (title==null) {title='';}
			
			msgPanel.setVisible(true);
			pMsgTitle.setText(title);
			pMsgText.setEditable(inputMode);
			pMsgText.setText(message);
			msgBYes.setVisible(!hideYesButton);
		}
		
		public function get_msgInputText():String {
			return pMsgText.getText();
		}
		
		public function hideMsgPanel():void {msgPanel.setVisible(false);}
		
		public function hideSavePanel():void {savePanel.setVisible(false);}
		
		public function showSavePanel(mode:uint, titleText:String='', wText:String='', hText:String='', nameText:String=''):void {
			//spName.setEditable(mode==ID_MODE_SAVE_PANEL_NEW);
			//spTitle.setEditable(mode==ID_MODE_SAVE_PANEL_NEW);
			spW.setEditable(mode==ID_MODE_SAVE_PANEL_NEW);
			spH.setEditable(mode==ID_MODE_SAVE_PANEL_NEW);
			
			//spName.setText(nameText);
			//spTitle.setText(titleText);
			spW.setText(wText);
			spH.setText(hText);
			
			savePanel.setVisible(true);
		}
		
		/**
		 * @param	a (image id:uint):void;
		 */
		public function setImageListener(a:Function):void {buttonPressed=a;}
		
		/**
		 * @param	a (button id:uint):void;
		 */
		public function setButtonListener(a:Function):void {buttonPressed0=a;}
		
		public function setContent(title:Vector.<String>, image:Vector.<DisplayObject>, id:Vector.<uint>, cols:int):void {
			if (scrollPane) {
				mainPanel.remove(scrollPane);
				mainPanel.pack();mainPanel.validate();
			}
			
			//scrollContentPane = new JPanel(new GridLayout(cols, title.length/cols+uint(title.length%cols>0), 2, 2))
			scrollContentPane = new JPanel(new FlowWrapLayout(mainPanel.getPreferredWidth()-scrollBar.getWidth(), FlowWrapLayout.LEFT, 2, 2))
			scrollContentPane.setPreferredWidth(mainPanel.getPreferredWidth()-scrollBar.getWidth());
			//var ww:uint = h - scrollBar.getHeight();
			//var ww1:Number=ww/cols-2*cols-50;//54 -  2buttons
			var item:ImageListElement;
			for (var i:uint in title) {
				//image[i].scaleY=image[i].scaleX=Math.min(1, (ww1)/image[i].height);
				item = new ImageListElement(title[i], image[i], id[i], buttonPressed, image[i].width, image[i].height);
				scrollContentPane.append(item);
			}
			
			scrollPane = new JScrollPane(scrollContentPane, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_NEVER);
			scrollPane.setVerticalScrollBar(scrollBar);scrollBar.setValue(0, false);
			scrollPane.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			//scrollContentPane.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			
			scrollPane.setPreferredWidth(mainPanel.getPreferredWidth());
			//scrollPane.setPreferredHeight(mainPanel.getPreferredHeight());
			//scrollPane.setPreferredWidth(mainPanel.getPreferredWidth());
			
			mainPanel.append(scrollPane, BorderLayout.CENTER);
			mainPanel.pack();mainPanel.validate();
		}
		
		//{ =*^_^*= buttons &combo box
		
		private function panelButtons(e:Event):void {
			var i:uint;
			switch (e.target.name) {
			//{panel
			case 's0':
				i = ID_BUTTON_PANEL_SAVE;
				break;
			case 'c0':
				i = ID_BUTTON_PANEL_CLOSE;
				//test:
				if (!testMode) {break;}
				hideSavePanel();
				break;
			//}
			//{msg panel
			case 'msgBClose':
				i = ID_BUTTON_MSG_CLOSE;
				hideMsgPanel();
				break;
				
			case 'msgBYes':
				i = ID_BUTTON_MSG_YES;
				break;
			//}
			}
			
			if (buttonPressed0!=null) {buttonPressed0(i);}
		}
		
		
		//{ =*^_^*= id
		public static const ID_BUTTON_PANEL_SAVE:uint=100;
		public static const ID_BUTTON_PANEL_CLOSE:uint=101;
		/**
		 * message box yes
		 */
		public static const ID_BUTTON_MSG_YES:uint=102;
		/**
		 * message box close
		 */
		public static const ID_BUTTON_MSG_CLOSE:uint=103;
		public static const ID_BUTTON_REMOVE:uint=104;
		
		
		public static const ID_MODE_SAVE_PANEL_NEW:uint=0;
		public static const ID_MODE_SAVE_PANEL_UPDATE:uint=1;
		/**
		 * mouse mode move or place cell texture
		 */
		public static const ID_MODE_CP_MOVE:uint=0;
		/**
		 * mouse mode move or place cell texture
		 */
		public static const ID_MODE_CP_PLACE:uint=1;
		
		
		//} =*^_^*= END OF id
		
		private var buttonPressed:Function;
		private var buttonPressed0:Function;
		private var cpEM:uint;
		//} =*^_^*= END OF buttons &combo box
		
		//{ =*^_^*= prepare
		public function preparePanel(w:uint, h:uint):void {
			savePanelSP=new Sprite();
			savePanel = savePanelSP.addChild(new JPanel());
			savePanel.setPreferredWidth(w);
			savePanel.setPreferredHeight(h);
			savePanel.setWidth(w);
			savePanel.setHeight(h);
			
			savePanel.setLayout(new FlowLayout(FlowLayout.CENTER, 2, 2));
			savePanel.setBackgroundDecorator(new SolidBackground(ASColor.LIGHT_GRAY));
			
			//txt
			var s:JLabel=new JLabel('save');
			s.setPreferredWidth(w);
			savePanel.append(s);
			
			//title
			//var tl:JLabel=new JLabel('title:');
			//tl.pack();tl.validate();
			//savePanel.append(tl);
			//spTitle=new JTextField();
			//spTitle.setPreferredWidth(w-tl.getWidth()-4);
			//spTitle.setPreferredHeight(tl.getHeight());
			//savePanel.append(spTitle);
			
			//name
			//var nl:JLabel=new JLabel('name:');
			//nl.pack();nl.validate();
			//savePanel.append(nl);
			//spName=new JTextField();
			//spName.setPreferredWidth(w-nl.getWidth()-4);
			//spName.setPreferredHeight(nl.getHeight());
			//savePanel.append(spName);
			
			
			
			//w
			var wl:JLabel=new JLabel('w:');
			wl.pack();wl.validate();
			savePanel.append(wl);
			spW=new JTextField();
			spW.setPreferredHeight(wl.getHeight());
			spW.setPreferredWidth(w/2-wl.getWidth()-4);
			savePanel.append(spW);
			spW.setRestrict('1234567890');
			//h
			var hl:JLabel=new JLabel('h:');
			hl.pack();hl.validate();
			savePanel.append(hl);
			spH=new JTextField();
			spH.setPreferredHeight(hl.getHeight());
			spH.setPreferredWidth(w/2-hl.getWidth()-4);
			savePanel.append(spH);
			spH.setRestrict(spW.getRestrict());
			
			
			//c
			var bClose:JButton = new JButton("Close");
			bClose.setPreferredWidth(w/2-2);
			bClose.name='c0';
			bClose.addActionListener(panelButtons);
			savePanel.append(bClose);
			
			//s
			var bSave:JButton = new JButton("Save");
			bSave.setPreferredWidth(w/2-2);
			bSave.name='s0';
			bSave.addActionListener(panelButtons);
			savePanel.append(bSave);
			
			
			savePanel.pack();savePanel.validate();
			hideSavePanel();
		}

		
		public function prepareMSGPanel(w:uint, h:uint):void {
			msgPanel = new JPanel();
			msgPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 4, 4));
			msgPanel.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			msgPanel.setPreferredWidth(w);
			msgPanel.setPreferredHeight(h);
			
			//title
			pMsgTitle=new JLabel('title');
			pMsgTitle.name='title';
			pMsgTitle.setBackground(new ASColor(0x004030));pMsgTitle.setForeground(new ASColor(0x00ffbf));
			pMsgTitle.setPreferredWidth(w);
			pMsgTitle.setMaximumWidth(w);
			msgPanel.append(pMsgTitle);
			
			//msg
			pMsgText=new JTextArea("aaaaa\nbbbb\nccccc");
			pMsgText.setBackground(new ASColor(0x004030));pMsgText.setForeground(new ASColor(0x00ffbf));
			pMsgText.setEditable(false);
			pMsgText.setPreferredWidth(w);
			pMsgText.setWordWrap(true);
			msgPanel.append(pMsgText);
			
			//c
			var msgBClose:JButton = new JButton("Close");
			msgBClose.setName('msgBClose');
			msgBClose.setBackgroundDecorator(new SolidBackground(new ASColor(0x005040)));
			msgBClose.setForeground(new ASColor(0x00ffbf));
			msgBClose.setPreferredWidth(w);
			msgBClose.addActionListener(panelButtons);
			msgPanel.append(msgBClose);
			
			//s
			msgBYes = new JButton("Yes");
			msgBYes.setName('msgBYes');
			msgBYes.setBackgroundDecorator(new SolidBackground(new ASColor(0x005040)));
			msgBYes.setForeground(new ASColor(0x00ffbf));
			msgBYes.setPreferredWidth(w);
			msgBYes.addActionListener(panelButtons);
			msgPanel.append(msgBYes);
			
			msgPanel.pack();msgPanel.validate();
			
			hideMsgPanel();
		}

		//} =*^_^*= END OF prepare
		
		//{ =*^_^*= private
		public function get_container():Sprite {return container;}
		private var container:Sprite;
		
		private var spTitle:JTextField;
		private var spName:JTextField;
		public function get_spWText():String {return spW.getText();}
		private var spW:JTextField;
		public function get_spHText():String {return spH.getText();}
		private var spH:JTextField;
		
		private var pMsgTitle:JLabel;
		private var pMsgText:JTextArea;
		private var msgBYes:JButton;
		
		public function get_msgPanel():DisplayObject {return msgPanel;}
		private var msgPanel:JPanel;
		public function get_savePanel():Sprite {return savePanelSP;}
		private var savePanelSP:Sprite;
		private var savePanel:JPanel;
		private var mainPanel:JPanel;
		private var scrollContentPane:JPanel;
		private var scrollPane:JScrollPane;
		private var scrollBar:JScrollBar = new JScrollBar(JScrollBar.VERTICAL);
		
		private var w:uint;
		private var h:uint;
		//} =*^_^*= END OF private
		
	}
}


//{ =^_^= import
import flash.display.DisplayObject;
import flash.events.Event;
import org.aswing.ASColor;
import org.aswing.AssetIcon;
import org.aswing.AssetPane;
import org.aswing.BorderLayout;
import org.aswing.FlowLayout;
import org.aswing.GridLayout;
import org.aswing.JButton;
import org.aswing.JLabel;
import org.aswing.JPanel;
import org.aswing.SolidBackground;
//} =^_^= END OF import
/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
class ImageListElement extends JPanel {
	
	//{ =^_^= CONSTRUCTOR
	
	/**
	 * 
	 * @param	title
	 * @param	image
	 * @param	id_
	 * @param	buttonPressedRef (id):void;
	 */
	function ImageListElement (title:String, image:DisplayObject, id_:uint, buttonPressedRef:Function, imW:int=-1, imH:int=-1) {
		setToolTipText(title);
		//if (buttonPressedRef == null) {throw new ArgumentError('ref must be non null', 3);}
		pressRef = buttonPressedRef;
		id = id_;
		setLayout(new BorderLayout());
		var titleLabel:JLabel = new JLabel(title);
		//titleLabel.setBackground(new ASColor(0x004030));
		titleLabel.setForeground(new ASColor(0x00ffbf));
		append(titleLabel, BorderLayout.NORTH);
		
		//var img:AssetPane = new AssetPane(image, AssetPane.PREFER_SIZE_LAYOUT);
		var selectButton:JButton = new JButton("", new AssetIcon(image, imW, imH));
		selectButton.addActionListener(buttonPressed);
		append(selectButton, BorderLayout.CENTER);
		
		//var selectButton2:JButton = new JButton('Hotkey:null');
		//selectButton2.addActionListener(buttonPressed);
		//append(selectButton2, BorderLayout.SOUTH);
		
	}
	//} =^_^= END OF CONSTRUCTOR
	
	private function buttonPressed(e:Event):void {
		if (pressRef!=null) {pressRef(id);}
	}
	
	private var id:uint;
	private var pressRef:Function;
	
	
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:15.01.2011_[00#08#13]_[6]