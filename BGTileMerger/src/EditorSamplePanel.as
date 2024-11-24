package {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.FlowLayout;
	import org.aswing.FlowWrapLayout;
	import org.aswing.GridLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JScrollBar;
	import org.aswing.JScrollPane;
	import org.aswing.JSeparator;
	import org.aswing.SolidBackground;
	//} =^_^= END OF import
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 215.02.2012 20:31
	 */
	public class EditorSamplePanel {
		
		//{ =^_^= CONSTRUCTOR
		
		private var testMode:Boolean=Boolean(0);
		
		/**
		 * 
		 * @param	w
		 * @param	h
		 * @param	buttonListener (buttonID:uint
		 */
		function EditorSamplePanel (w:uint, h:uint, buttonListener:Function) {
			this.w=w;
			this.h=h;
			
			this.r_elB= buttonListener
			container=new Sprite();
			
			scrollBar.pack();scrollBar.validate();
			mainPanel = container.addChild(new JPanel(new BorderLayout(2,2)));
			mainPanel.setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
			
			mainPanel.setPreferredWidth(w);
			mainPanel.setPreferredHeight(h);
			
			panelControlls = new JPanel(new FlowLayout(FlowLayout.LEFT, 2,2));
			panelControlls.setPreferredWidth(w);
			
			var backButton:JButton = new JButton("Back");
			backButton.setPreferredWidth(w);
			backButton.addActionListener(function (e:Event):void {r_elB(ID_BUTTON_BACK);});
			panelControlls.append(backButton);
			
			var newLayerButton:JButton = new JButton("NewLayer");
			newLayerButton.setPreferredWidth(w);
			newLayerButton.addActionListener(function (e:Event):void {r_elB(ID_BUTTON_NEW_LAYER);});
			panelControlls.append(newLayerButton);
			
			var deleteLayer:JButton = new JButton("DeleteLayer");
			deleteLayer.setPreferredWidth(w);
			deleteLayer.addActionListener(function (e:Event):void {r_elB(ID_BUTTON_DELETE_LAYER);});
			panelControlls.append(deleteLayer);
			
			
			tl0=new JLabel('Title:');
			tl0.setHorizontalAlignment(JLabel.LEFT);tl0.setPreferredWidth(w);
			tl0.setBackground(new ASColor(0x004030));tl0.setForeground(new ASColor(0x00ffbf));
			panelControlls.append(tl0);
			
			hk=new JLabel('Hotkey:');
			hk.setHorizontalAlignment(JLabel.LEFT);hk.setPreferredWidth(w);
			hk.setBackground(new ASColor(0x004030));hk.setForeground(new ASColor(0x00ffbf));
			panelControlls.append(hk);
			
			
			panelControlls.pack();panelControlls.validate();
			panelControlls.setPreferredHeight(
				backButton.getHeight()+
				newLayerButton.getHeight()+
				tl0.getHeight()+
				deleteLayer.getHeight()+
				hk.getHeight()+2*5
			);
			mainPanel.append(panelControlls, BorderLayout.NORTH);
			
			mainPanel.pack();mainPanel.validate();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function setText(titleText:String, hotkeyText:String):void {
			tl0.setText(titleText);hk.setText(hotkeyText);
		}
		
		/**
		 * @param	a (image id:uint):void;
		 */
		public function setImageListener(a:Function):void {buttonPressed=a;}
		
		
		public function setContent(title:Vector.<String>, image:Vector.<DisplayObject>, image0:Vector.<DisplayObject>, id:Vector.<uint>, cols:uint):void {
			if (scrollPane) {
				mainPanel.remove(scrollPane);
				mainPanel.pack();mainPanel.validate();
			}
			
			scrollContentPane = new JPanel(new GridLayout(title.length/cols+uint(title.length%cols>0), cols, 2, 2))
			scrollContentPane.setPreferredWidth(mainPanel.getPreferredWidth()-scrollBar.getWidth());
			var ww:uint = w - scrollBar.getWidth();
			var ww1:Number=ww/(cols*2)-5*cols;
			var item:ImageListElement;
			//var im:Sprite;
			for (var i:uint in title) {
				image[i].scaleY=image[i].scaleX=ww1/image[i].width;
				image0[i].scaleY=image0[i].scaleX=ww1/image0[i].width;
				item = new ImageListElement(title[i], image[i], image0[i], id[i], buttonPressed, image[i].width, image[i].height);
				
				scrollContentPane.append(item);
			}
			//scrollContentPane.setPreferredHeight(item.getHeight()*(title.length)+2*title.length);
			
			
			scrollPane = new JScrollPane(scrollContentPane, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_NEVER);
			scrollPane.setVerticalScrollBar(scrollBar);scrollBar.setValue(0, false);
			scrollPane.setPreferredHeight(h-panelControlls.getPreferredHeight()-2*3);
			
			scrollPane.pack();scrollPane.validate();
			mainPanel.append(scrollPane, BorderLayout.CENTER);
			mainPanel.pack();mainPanel.validate();
		}
		
		
		//{ =*^_^*= private
		public function get_container():Sprite {return container;}
		private var container:Sprite;
		
		private var tl0:JLabel;
		private var hk:JLabel;
		private var mainPanel:JPanel;
		private var panelControlls:JPanel;
		private var scrollContentPane:JPanel;
		private var scrollPane:JScrollPane;
		private var scrollBar:JScrollBar = new JScrollBar(JScrollBar.VERTICAL);
		
		private var buttonPressed:Function;
		private var r_elB:Function;
		
		private var w:uint;
		private var h:uint;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= id
		public static const ID_BUTTON_BACK:uint=0;
		public static const ID_BUTTON_NEW_LAYER:uint=1;
		public static const ID_BUTTON_DELETE_LAYER:uint=2;
		//} =*^_^*= END OF id
		
	}
}


//{ =^_^= import
import flash.display.DisplayObject;
import flash.display.Sprite;
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
import org.aswing.JSeparator;
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
	 * @param	buttonPressedRef (imageId, buttonId//button index - 0 or 1//):void;
	 */
	function ImageListElement (title:String, image:DisplayObject, image0:DisplayObject, id_:uint, buttonPressedRef:Function, imW:int=-1, imH:int=-1) {
		//setBackgroundDecorator(new SolidBackground(new ASColor(0x004030)));
		pressRef = buttonPressedRef;
		id = id_;
		setLayout(new BorderLayout());
		var titleLabel:JLabel = new JLabel(title);
		titleLabel.setToolTipText('Title:'+title+'\nId:'+id);
		titleLabel.setBackground(new ASColor(0x004030));titleLabel.setForeground(new ASColor(0x00ffbf));
		titleLabel.pack();titleLabel.validate();
		append(titleLabel, BorderLayout.NORTH);
		
		image.scaleX-=6/imW;
		image.scaleY-=6/imH;
		image0.scaleX-=6/imW;
		image0.scaleY-=6/imH;
		
		selectButton = new JButton("", new AssetIcon(image, imW-6, imH-6));
		selectButton.addActionListener(buttonPressed);
		append(selectButton, BorderLayout.WEST);
		
		var sepIm0:Sprite=new Sprite();
		var sepIm:Sprite=sepIm0.addChild(new Sprite());
		sepIm.y=titleLabel.getHeight()-20/2;
		sepIm.graphics.beginFill(0, 0);
		sepIm.graphics.drawRect(0,0,10, 20);
		sepIm.graphics.beginFill(0x00ffbf);
		sepIm.graphics.moveTo(2,20/2);
		sepIm.graphics.lineTo(10-2, 20-2);
		sepIm.graphics.lineTo(10-2, 2);
		var s_:AssetPane=new AssetPane(sepIm0);
		s_.validate();s_.pack();
		append(s_, BorderLayout.CENTER);
		
		selectButton0 = new JButton("", new AssetIcon(image0, imW-6, imH-6));
		selectButton0.addActionListener(buttonPressed);
		append(selectButton0, BorderLayout.EAST);
		pack();validate();
	}
	//} =^_^= END OF CONSTRUCTOR
	
	private function buttonPressed(e:Event):void {
		if (pressRef!=null) {
			switch (e.target) {
			
			case selectButton:
				pressRef(id, 0);
				break;
			case selectButton0:
				pressRef(id, 1);
				break;
			}
		}
	}
	
	private var selectButton:JButton;
	private var selectButton0:JButton;
	private var id:uint;
	private var pressRef:Function;
	
	
}


//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:15.01.2011_[00#08#13]_[6]