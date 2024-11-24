package {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.FlowLayout;
	import org.aswing.FlowWrapLayout;
	import org.aswing.GridLayout;
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
	public class EditorMasksPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		private var testMode:Boolean=Boolean(0);
		
		function EditorMasksPanel (w:uint, h:uint) {
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
		}
		//} =^_^= END OF CONSTRUCTOR
		
		/**
		 * @param	a (image id:uint):void;
		 */
		public function setImageListener(a:Function):void {buttonPressed=a;}
		
		
		public function setContent(title:Vector.<String>, image:Vector.<DisplayObject>, id:Vector.<uint>, cols:uint):void {
			if (scrollPane) {
				mainPanel.remove(scrollPane);
				mainPanel.pack();mainPanel.validate();
			}
			
			//scrollContentPane = new JPanel(new GridLayout(title.length/cols+uint(title.length%cols>0), cols, 2, 2))
			scrollContentPane = new JPanel(new FlowWrapLayout(mainPanel.getPreferredWidth()-scrollBar.getWidth(), FlowWrapLayout.LEFT, 2, 2))
			scrollContentPane.setPreferredWidth(mainPanel.getPreferredWidth()-scrollBar.getWidth());
			//scrollContentPane.setPreferredHeight(mainPanel.getPreferredHeight());
			var ww:uint = w - scrollBar.getWidth();
			var ww1:Number=ww/cols-2*cols;
			var item:ImageListElement;
			//var im:Sprite;
			for (var i:uint in title) {
				image[i].scaleY=image[i].scaleX=Math.min(1, (ww1)/image[i].width);
				//im=new Sprite();
				//im.addChild(image[i]);
				item = new ImageListElement(title[i], image[i], id[i], buttonPressed, image[i].width, image[i].height);
				scrollContentPane.append(item);
			}
			
			scrollPane = new JScrollPane(scrollContentPane, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_NEVER);
			scrollPane.setHorizontalScrollBar(scrollBar);scrollBar.setValue(0, false);
			//scrollPane.setPreferredWidth(mainPanel.getPreferredWidth());
			//scrollPane.setPreferredHeight(mainPanel.getPreferredHeight());
			//scrollPane.setPreferredWidth(mainPanel.getPreferredWidth());

			scrollPane.setPreferredHeight(mainPanel.getPreferredHeight());
			
			mainPanel.append(scrollPane, BorderLayout.NORTH);
			mainPanel.pack();mainPanel.validate();
		}
		
		private var buttonPressed:Function;
		
		//{ =*^_^*= private
		public function get_container():Sprite {return container;}
		private var container:Sprite;
		
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