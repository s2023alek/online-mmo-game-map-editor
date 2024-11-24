// Project BGTileMapEditorFile
package main {
	
	//{ =*^_^*= import
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleConfig;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import lib.BGTileMapEditorLibrary;
	import n.Im;
	import n.TEXTDataRequest;
	import org.jinanoimateydragoncat.input.Kb;
	import org.jinanoimateydragoncat.utils.Logger;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class BGTileMapEditor extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function BGTileMapEditor () {
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
		
		private function init(e:Event=null):void {
			//{ ^_^ prepare
			BGTileMapEditorLibrary.initialize(libraryInitialized);
			if (e) {removeEventListener(e.type, arguments.callee);}
			//} ^_^ END OF prepare
		}
		private function libraryInitialized():void {
			// entry point
			var accessTestMode:Boolean=Boolean(0);
			if (accessTestMode) {initDefaults();}
			run();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		private function initDefaults():void {
			initialize(null, null, el_main);
		}
		
		private function prepare():void {
			if (!initialized) {
				standaloneMode=true;
				initDefaults();
			}
			
			stage.scaleMode=StageScaleMode.SHOW_ALL;
			//prepare keyboard
			k = new Kb(this);
			k.onKeyDown = keyDown;
			k.onKeyUp = keyUp;
			
			//listeners:
			container.mouseChildren = false;
			container.addEventListener(MouseEvent.MOUSE_DOWN, function (e:Event):void {
					Event(e).stopImmediatePropagation();
					mouseIsDown = true;
					Sprite(container).startDrag();
				}
			);
			container.addEventListener(MouseEvent.MOUSE_UP, function (e:Event):void {mouseIsDown=false;stopDrag(); } );
			//stage
			stage.addEventListener(MouseEvent.MOUSE_MOVE, el_stage_mouse_move);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function (e:Event):void {container.x=CX;container.y=CY;});
			
			//panels :
			buttonsPanel = new EditorRightPanelButtons(0, screenH-200, el_buttonsPanel);
			userInterfaceContainer.addChild(buttonsPanel.get_container()).x=screenW-buttonsPanel.get_container().width;
			vpW-=buttonsPanel.get_container().width;
			
			panelSamplesList = new EditorSamplesListPanel(200, screenH);
			userInterfaceContainer.addChild(panelSamplesList.get_container());
			
			panelSampleDetails = new EditorSamplePanel(200, screenH, el_panelSampleDetailsButton);
			userInterfaceContainer.addChild(panelSampleDetails.get_container());
			panelSampleDetails.get_container().visible=false;
			
			
			prepareStateLine();
			
			var pW:uint=vpW;
			var pH:uint=screenH-sls.height;
			panel = new EditorBottomPanel(pW, pH);
			panel.get_container().x=200;
			panel.get_container().y=sls.height;
			userInterfaceContainer.addChild(panel.get_container()).visible=false;
			
			panelMasks = new EditorMasksPanel(vpW, vpH-sls.height);
			panelMasks.get_container().visible=false;
			userInterfaceContainer.addChild(panelMasks.get_container()).x=200;
			panelMasks.get_container().y = sls.height;
			
			
			preparePanel();
			prepareMasksPanel();
			prepareSamplesPanel();
			prepareSamplePanel();
			
			
			//settings panel
			panelCfg=new SettingsPanel(screenW, screenH);
			userInterfaceContainer.addChild(panelCfg).visible=false;
			prepareSettingsPanel();
			
			panel.preparePanel(pW, pH);
			userInterfaceContainer.addChild(panel.get_savePanel());
			panel.get_savePanel().x = panel.get_container().x;panel.get_savePanel().y = panel.get_container().y;//message window
			panel.prepareMSGPanel(pW, pH);
			panel.get_msgPanel().x = panel.get_container().x;panel.get_msgPanel().y = panel.get_container().y;
			userInterfaceContainer.addChild(panel.get_msgPanel());
			
			
			// prepare display
			container.x = CX;
			container.y = CY;
			//container mask
			containerMask.graphics.beginFill(0);
			containerMask.graphics.drawRect(0,0,vpW,vpH);
			containerMask.x = container.x;
			containerMask.y = container.y;
			container.mask = containerMask;
			addChild(container);
			container.cacheAsBitmap = true;
			addChild(userInterfaceContainer);
			addChild(c);
		}
		
		private function run():void {
			prepare();
			
			if (!standaloneMode) {//initialized
				clearMapData();
				clearMapContainer();
				loadImages();
			} else {
				initialized=false;
				panelCfg.visible=true;
				//loadMap();
				// check flashvars
				if ((stage.loaderInfo.parameters.configFileName != null)&&(stage.loaderInfo.parameters.mapFileName != null)) {
					// load map data from server
					clearMapData();
					clearMapContainer();
					srv_loadFromServer(
						[
							{name:"configFileLoadedFromServer", path:stage.loaderInfo.parameters.mapFileName}
							,{name:"mapFileLoadedFromServer", path:stage.loaderInfo.parameters.configFileName}
						]
					, el_server);
				} else {//test
					clearMapData();
					clearMapContainer();
					srv_loadFromServer(
						[
							{name:ID_A_STARTUP_ARGUMENT_NAME_CFG_DATA, path:'DefaultSettings.BGTileMapEditorFile'}
							,{name:ID_A_STARTUP_ARGUMENT_NAME_MAP_DATA, path:'DefaultMapData.BGTileMapEditorFile'}
						]
					, el_server_allFilesAreLoaded);
				}
			}
		}
		
		//{ =*^_^*= network
		/**
		 * @param	filesToLoad [{name:String, path:String}]
		 * @param	listener
		 */
		private function srv_loadFromServer(filesToLoad:Array, listener:Function):void {
			srv_fileQueue = srv_fileQueue.concat(filesToLoad);
			log0('about to load files:' + JSON.encode(filesToLoad));
			srv_loadNextFile();
		}
		private function srv_loadNextFile():void {
			if (srv_fileQueue.length < 1) {
				sl('config files are loaded');
				el_server_allFilesAreLoaded(srv_loadedFilesList);
				return;
			}
			srv_currentFile = srv_fileQueue.shift();
			srv_req = new TEXTDataRequest(srv_el_req, srv_currentFile.path+'?random='+Math.random()*1000000+'_'+(new Date().setSeconds()/1000));
		}
		
		private function srv_el_req(operationResultData:Object, operationResultCode:uint):void {
			if (operationResultCode != TEXTDataRequest.ID_ER_NO_ERROR) {
				sl('failed to load files specified at startup');
				return;//do nothing
			}
			srv_loadedFilesList[srv_currentFile.name]=operationResultData;
			sl('file loaded:' + srv_currentFile.path);
			sl('file loaded:' + JSON.encode(srv_currentFile));
			srv_loadNextFile();
		}
		
		private var srv_req:TEXTDataRequest;
		private var srv_fileQueue:Array=[];
		private var srv_loadedFilesList:Object={};
		/**
		 * {path:String, name:String}
		 */
		private var srv_currentFile:Object;
		//} =*^_^*= END OF network
		
		//{ =*^_^*= controll
		private function el_server_allFilesAreLoaded(data:Object):void {
			panelCfg.visible = false;
			r_el_main(ID_A_LOAD_SETTINGS_DATA, srv_loadedFilesList[ID_A_STARTUP_ARGUMENT_NAME_CFG_DATA]);
			//clearMapData();
			//clearMapContainer();
			//loadImages();
			
			//r_el_main(ID_A_LOAD_MAP_DATA, data[ID_A_STARTUP_ARGUMENT_NAME_MAP_DATA]);
		}
		
		private function controll_loadMap():void {
			if (srv_loadedFilesList[ID_A_STARTUP_ARGUMENT_NAME_MAP_DATA]!=null) {
				r_el_main(ID_A_LOAD_MAP_DATA, srv_loadedFilesList[ID_A_STARTUP_ARGUMENT_NAME_MAP_DATA]);
			}
		}
		private static const ID_A_STARTUP_ARGUMENT_NAME_CFG_DATA:String="loadedConfigFile";
		private static const ID_A_STARTUP_ARGUMENT_NAME_MAP_DATA:String="LoadedMapFile";
		//} =*^_^*= END OF controll
		
		//{ =*^_^*= access
		
		
		/**
		* disable keyboard and mouse if not visible
		*/
		public override function set visible(a:Boolean):void {editorEnabled=a;super.visible=a;}
		
		private var editorEnabled:Boolean=true;
		
		/**
		 * a
		 * @param	imagesURL [String]// example: "server/im/im0.png"
		 * @param	masksURL [String]
		 * @param	listener
		 * @param	screenW
		 * @param	screenH
		 * @param	blockWidth
		 * @param	blockHeight
		 */
		public function initialize(imagesURL:Array, masksURL:Array, listener:Function, blockWidth:uint=100, blockHeight:uint=50, screenW:uint=1000, screenH:uint=700):void {
			prepareConsole();
			prepareLogging();
			
			log0('initialize('+JSON.encode(arguments)+')')
			
			this.screenW=screenW;
			this.screenH=screenH;
			this.BLOCK_WIDTH=blockWidth;
			this.BLOCK_HEIGHT=blockHeight;
			this.r_el_main=listener;
			
			vpW=screenW-200;
			vpH=screenH;
			
			
			var i:String;
			images_URLS=[];images_Names=[];
			for each(i in imagesURL) {
				images_URLS.push(i);
				images_Names.push(i.substr(i.lastIndexOf('/')+1));
			}
			masks_URLS=[];masks_Names=[];
			for each(i in masksURL) {
				masks_URLS.push(i);
				masks_Names.push(i.substr(i.lastIndexOf('/')+1));
			}
			
			imagesURLSAreChanged=true;
			
			
			initialized=true;
		}
		
		public function loadMapData(data:String):void {
			
			try {
				var d:DUSettings=DUSettings.fromString(data);
			} catch (e:Error) {
				LOG0('loadMapData>error:'+e);
				LOG0('loadMapData>data:'+data);
				return;
			}
			
			//templates:
			clearTPData();
			listTilePrototypes=d.get_tp();
			if (listTilePrototypes.length<1) {
				createAndDisplayDefaultTilePrototype();
			}
			//data itself:
			MAP_WIDTH=Math.max(3, d.get_mapW());
			MAP_HEIGHT=Math.max(3, d.get_mapH());
			//init
			clearMapContainer();
			clearMapData();
			//set data
			map=d.get_map();
			//draw:
			displayListTilePrototype();
			drawMap();
		}
		
		public function loadSettingsData(data:String):void {
			try {
				var d:DUSettings=DUSettings.fromString(data);
			} catch (e:Error) {
				LOG0(e+'\nstack trace:'+e.getStackTrace());
				sl('File is corrupted');
				return;
			}
			initialize(d.get_imagesURL(),d.get_masksURL(),el_main,d.get_blockWidth(),d.get_blockHeight());
			listTilePrototypes=d.get_tp();
			loadImages();
		}
		//} =*^_^*= END OF access
		
		//{ =*^_^*= events
		private function el_main(name:String, data:Object):void {
			LOG0('MSG>el_main:::>>>'+name);
			var fr:FileReference;
			var fr0:FileReference;
			var tp:TilePrototype;
			switch (name) {
			
			case ID_E_READY_FOR_MAP_LOAD:
				if (standaloneMode) {
					controll_loadMap();
				}
				break;
				
			case ID_E_RES_IMAGE_LOAD_ERROR:
				var iindx:int=images_URLS.indexOf(data);
				if (iindx!=-1) {
					images_URLS.splice(iindx, 1);
					panel.showMsgPanel(data+'\n image removed from list.', 'error loading image:');
				} else {
					panel.showMsgPanel(data+'\n image not found in list.', 'error loading image:');
				}
				break;
			case ID_E_RES_IMAGES_LOADED:
				displayImagesList();
				displayMasksList();
				if (!listTilePrototypes||listTilePrototypes.length<1) {
					createAndDisplayDefaultTilePrototype();
				}
				if (mode!=ID_MODE_APP_LOAD_SETTINGS) {
				} else {
					displayListTilePrototype();
				}
				mode=ID_MODE_APP_DEFAULT;
				sl('Ready');
				r_el_main(ID_E_READY_FOR_MAP_LOAD,null);
				break;
				
			case ID_E_SAMPLE_DEACTIVATED:
				//sl('deactivated #'+data);
				selectedToolTilePrototypeIndex=-1;
				break;
			case ID_E_SAMPLE_ACTIVATED:
				sl('activated #'+data);
				selectedToolTilePrototypeIndex=data;
				el_stage_mouse_move(null);
				break;
				
			case ID_E_SAMPLE_SELECTED:
				selectedTilePrototypeIndex=data.ii;
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				if (data.bi==0) {//image
					displayTilePrototypeDetails(tp);
					panelSamplesList.get_container().visible=false;
					panelSampleDetails.get_container().visible=true;
				} else if (data.bi==1) {//hotkey
					keyboard_mode=ID_MODE_KEYBOARD_SET_HOTKEY;
					sl('Select new hotkey for the TP#'+tp.get_id()+' "'+tp.get_name()+'"');
				}
				break;
				
			case ID_A_CLOSE_PANEL_SAMPLE_DETAIL:
				panelSampleDetails.get_container().visible=false;
				panelSamplesList.get_container().visible=true;
				displayListTilePrototype();
				break;
				
			case ID_E_SAMPLE_LAYER_SELECTED:
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				if (mode==ID_MODE_APP_DELETE_LAYER) {
					mode=ID_MODE_APP_DEFAULT;
					deleteLayer(tp, data.ii);
					displayTilePrototypeDetails(tp);
					return;
				}
				sl('Select new '+['image','mask'][data.bi]+' for the L#'+
					tp.get_layers()[data.ii].get_id()+' "'+tp.get_layers()[data.ii].get_name()+'"');
				
				if (data.bi==1) {//mask
					panel.get_container().visible=false;
					if (selectedLayerIndex!=data.ii) {panelMasks.get_container().visible=true;
					} else {panelMasks.get_container().visible=!panelMasks.get_container().visible;}
				} else if (data.bi==0) {//image
					panelMasks.get_container().visible=false;
					if (selectedLayerIndex!=data.ii) {panel.get_container().visible=true;
					} else {panel.get_container().visible=!panel.get_container().visible;}
				}
				selectedLayerIndex=data.ii;
				break;
				
			case ID_E_MASK_SELECTED:
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				if (selectedLayerIndex==-1) {break;}
				tp.get_layers()[selectedLayerIndex].set_mask(data);
				sl('new mask selected for Layer#'+tp.get_layers()[selectedLayerIndex].get_id());
				//updata image
				tp.set_changed(true);
				displayTilePrototypeDetails(tp);
				selectedLayerIndex=-1;
				break;
				
			case ID_E_IMAGE_SELECTED:
				if (selectedLayerIndex==-1) {break;}
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				tp.get_layers()[selectedLayerIndex].set_im(data);
				sl('new image selected for Layer#'+tp.get_layers()[selectedLayerIndex].get_id());
				tp.set_changed(true);
				displayTilePrototypeDetails(tp);
				selectedLayerIndex=-1
				panel.get_container().visible=false;
				break;
				
			case ID_E_HOTKEY_SELECTED:
				if (selectedTilePrototypeIndex==-1) {break;}
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				if (data==Keyboard.SPACE) {tp.set_hotkey('SPACE');} else {
					tp.set_hotkey(String.fromCharCode(int(data)));
				}
				sl('new hotkey selected for TP#'+tp.get_id());
				selectedTilePrototypeIndex=-1;
				keyboard_mode=ID_MODE_KEYBOARD_DEFAULT;
				displayListTilePrototype();
				break;
				
			case ID_A_NEW_LAYER:
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				addNewLayer(tp);
				displayTilePrototypeDetails(tp);
				sl('New Layer has been added to TP#'+tp.get_id()+' "'+tp.get_name()+'"');
				break;
				
			case ID_A_DELETE_LAYER:
				if (mode == ID_MODE_APP_DELETE_LAYER) {
					mode = ID_MODE_APP_DEFAULT;
					sl('Ready');
					return;
				}
				tp=listTilePrototypes[selectedTilePrototypeIndex];
				if (tp.get_layers().length<2) {
					panel.showMsgPanel('TilePrototype cannot have less than 1 layer.\nHint: use SPACE key to clear map cell', 'cannot remove last layer');
					break;
				}
				sl('Select Layer or press "DeleteLayer" btn to abort');
				mode=ID_MODE_APP_DELETE_LAYER;
				break;
				
			case ID_E_SAVE_IMAGE:
				// save to file
				fr0 =new FileReference();
				fr0.addEventListener(Event.SELECT, function(e:Object):void {sl('SaveImage>Saving');});
				fr0.addEventListener(Event.COMPLETE, function(e:Object):void {sl('SaveImage>Complete');});
				fr0.addEventListener(Event.CANCEL, function(e:Object):void {sl('SaveImage>Cancelled by user');});
				
				data=PNGEncoder.encode(data);
				fr0.save(data, 'MapName.png');
				break;
			
			case ID_E_SAVE_SETTINGS_DATA:
				fr=new FileReference();
				fr.addEventListener(Event.SELECT, function(e:Object):void {sl('Save settings data>Saving');});
				fr.addEventListener(Event.COMPLETE, function(e:Object):void {sl('Save settings data>Complete');});
				fr.addEventListener(Event.CANCEL, function(e:Object):void {sl('Save settings data>Cancelled by user');});
				
				fr.save(data, 'Settings.BGTileMapEditorFile');
				break;
				
			case ID_E_SAVE_MAP_DATA:
				fr=new FileReference();
				fr.addEventListener(Event.SELECT, function(e:Object):void {sl('Save map data>Saving');});
				fr.addEventListener(Event.COMPLETE, function(e:Object):void {sl('Save map data>Complete');});
				fr.addEventListener(Event.CANCEL, function(e:Object):void {sl('Save map data>Cancelled by user');});
				
				fr.save(data, 'MapName.BGTileMapEditorFile');
				break;
				
			case ID_A_LOAD_MAP_DATA_ABORT:
				sl('Load map data>Cancelled by user');
				if (!initialized) {
					sl('Specify settings manually');
					panelCfg.visible=true;
				}
				break;
				
			case ID_E_LOAD_SETTINGS:
				mode=ID_MODE_APP_LOAD_SETTINGS;
				loadSettings();
				break;
				
			case ID_E_APPLY_SETTINGS:
				applySettings(new DUSettings(data.ilm, data.ml, MAP_WIDTH, MAP_HEIGHT, data.bw, data.bh, null, null));
				break;
				
			case ID_A_LOAD_MAP_DATA:
				mode=ID_MODE_APP_LOAD_MAP;
				loadMapData(data);
				sl('Load map data>Loaded');
				break;
			
			case ID_A_LOAD_SETTINGS_DATA:
				mode=ID_MODE_APP_LOAD_SETTINGS;
				loadSettingsData(data);
				sl('Load settings data>Loaded');
				panelCfg.visible=false;
				break;
				
			case ID_E_CLOSE:
				panel.showMsgPanel('Rly quit?', 'O_o  o_O', false);
				mode=ID_MODE_APP_QUIT;
				break;
			}
		}
		
		//{ =*^_^*= buttons
		private function el_buttonsPanel(bID:uint):void {
			var w:uint;var h:uint;var title:String='no title';var name:String='';
			
			switch (bID) {
			
			case EditorRightPanelButtons.ID_BUTTON_SAVE0:
				saveImage();
				break;
			case EditorRightPanelButtons.ID_BUTTON_NEW:
				if (!initialized || !listTilePrototypes || !images_||images_.length<1) {
					panel.showMsgPanel('Configure settings first, in particular image and masks url lists', 'cannot perform operation');
					break;
				} else if (!imagesAreLoaded) {
					panel.showMsgPanel('wait until all imagess are loaded', 'cannot perform operation');
					break;
				}
				panel.showSavePanel(0, '', 3, 3);
				break;
			case EditorBottomPanel.ID_BUTTON_PANEL_CLOSE:
				panel.hideSavePanel();
				break;
			case EditorBottomPanel.ID_BUTTON_PANEL_SAVE:
				title="";
				name="";
				w=panel.get_spWText();
				h = panel.get_spHText();
				if (w < 3 || h < 3) {
					panel.showMsgPanel('map width and height must be >= 3', 'check input');
					break;
				}
				sl('NewMap>generating new map data');
				waitForRender(function():void{
					MAP_WIDTH = Math.max(3,w);
					MAP_HEIGHT = Math.max(3,h);
					clearMapContainer();
					clearMapData();
					contents.mask = createBGImageRectMask();
					drawMap();
					panel.hideSavePanel();
					sl('NewMap>complete');
				});
				break;
				
			case EditorRightPanelButtons.ID_BUTTON_CLOSE:
				r_el_main(ID_E_CLOSE, null);
				break;
			case EditorRightPanelButtons.ID_BUTTON_LOAD:
				if (standaloneMode) {
					loadMap();
				}
				break;
			case EditorRightPanelButtons.ID_BUTTON_SETTINGS:
				if (!standaloneMode) {break;}
				panelCfg.setText(BLOCK_WIDTH, BLOCK_HEIGHT, images_URLS.join('\n'), masks_URLS.join('\n'));
				panelCfg.visible=true;
				break;
			case EditorRightPanelButtons.ID_BUTTON_SAVE:
				saveMap();
				break;
			case EditorRightPanelButtons.ID_BUTTON_LOG:	
				c.visible=!c.visible;
				break;
			case EditorRightPanelButtons.ID_BUTTON_NEW_MASK:
				if (!initialized|| !listTilePrototypes || !images_||images_.length<1) {
					panel.showMsgPanel('Configure settings first, in particular image and masks url lists', 'cannot perform operation');
					break;
				} else if (!imagesAreLoaded) {
					panel.showMsgPanel('wait until all imagess are loaded', 'cannot perform operation');
					break;
				}
				sl('Enter Tile prototype name');
				panel.showMsgPanel('TilePrototype#'+listTilePrototypes.length, 'Enter Tile prototype name, then press Yes button', false, true);
				break;
			case EditorBottomPanel.ID_BUTTON_MSG_CLOSE:
				if (mode==ID_MODE_APP_QUIT) {mode=ID_MODE_APP_DEFAULT;}
				break;
			case EditorBottomPanel.ID_BUTTON_MSG_YES:
				if (mode==ID_MODE_APP_QUIT) {
					fscommand('quit','');
					break;
				}
				sl('New TilePrototype has been created');
				panel.hideMsgPanel();
				createNewTilePrototype(panel.get_msgInputText());
				displayListTilePrototype();
				break;
			
			}
		}
		private var buttonsPanel:EditorRightPanelButtons;
		//} =*^_^*= END OF buttons
		
		//} =*^_^*= END OF events
		
		//{ =*^_^*= mouse
		private function el_stage_mouse_move(e:Object):void {
			if (!editorEnabled) {return;}
			if (mouseIsDown) { return;}
			if (!e) {oldX=-BLOCK_WIDTH*2;}
			if (Math.abs(oldX - stage.mouseX) > BLOCK_WIDTH / 4 || Math.abs(oldY - stage.mouseY) > BLOCK_HEIGHT / 4) {
				oldX = stage.mouseX;
				oldY = stage.mouseY;
			} else { return;}
			
			if (selectedToolTilePrototypeIndex==-1) {return;}
			
			var image:Bitmap;
			a1:for (var l:int = 0; l < MAP_WIDTH; l++) {
				for (var c:int = 0; c < MAP_HEIGHT; c++) {
					image = images[l][c];
					if (image.hitTestPoint(stage.mouseX, stage.mouseY)) {
						if (image.bitmapData.getPixel32(image.mouseX,image.mouseY)  > 0) {
							break a1;
						}
					}
				}
			}
			if (!image||(l==MAP_WIDTH||c==MAP_HEIGHT)) { return; }//no image under cursor
			// TODO: find map tile with wx and xy
			var tp:TilePrototype;
			map[l][c]=listTilePrototypes[selectedToolTilePrototypeIndex].get_id();
			redrawBGTile(l, c);
		}
		private var mouseIsDown:Boolean;
		private var oldX:Number=0;
		private var oldY:Number=0;
		//} =*^_^*= END OF mouse
		
		//{ =*^_^*= keyboard
		private function keyDown(keyCode:uint):void {
			if (!editorEnabled) {return;}
			var ki:int;
			switch (keyboard_mode) {
			
			case ID_MODE_KEYBOARD_DEFAULT:
				if (keyCode==Keyboard.SPACE) {ki=keyb_LSHK.indexOf('SPACE');}else{
					ki=keyb_LSHK.indexOf(String.fromCharCode(int(keyCode)));
				}
				if (ki!=-1) {el_main(ID_E_SAMPLE_ACTIVATED, ki);}
				break;
			case ID_MODE_KEYBOARD_SET_HOTKEY:
				el_main(ID_E_HOTKEY_SELECTED, keyCode);
				break;
			
			}
			
			/*
			if (changeTex != -1||changeMask!=-1) {
				oldX = stage.mouseX+BLOCK_WIDTH;
				oldY = stage.mouseY + BLOCK_HEIGHT;
				el_stage_mouse_move(null);
			}*/
		}
		
		private function keyUp(keyCode:uint):void {
			var ki:int;
			switch (keyboard_mode) {
			
			case ID_MODE_KEYBOARD_DEFAULT:
				if (keyCode==Keyboard.SPACE) {ki=keyb_LSHK.indexOf('SPACE')}else{
					ki=keyb_LSHK.indexOf(String.fromCharCode(int(keyCode)));
				}
				if (ki!=-1) {el_main(ID_E_SAMPLE_DEACTIVATED, ki);}
				break;
			}
		}
		private var k:Kb;
		private var keyboard_mode:uint;
		/**
		 * keyboard_LayerHotKeys
		 */
		private static var keyb_LSHK:Array=[];
		//} =*^_^*= END OF keyboard
		
		//{ =*^_^*= display
		private function drawMap():void {
			LOG0('drawMap>map wh:'+MAP_WIDTH+'x'+MAP_HEIGHT);
			if (!mapPresent) {
				LOG0('drawMap>!mapPresent',1);
				return;
			}
			prepareBitmap();
			contents.addChild(bg);
			var image:Bitmap;
			hittestImagesList=[];
			for (var l:int = 0; l < MAP_WIDTH; l++) {
				for (var c:int = 0; c < MAP_HEIGHT; c++) {
					redrawBGTile(l, c);
					//hittest:
					image = createHitTestBitmap();
					images[l][c]=image;
					image.alpha=0;
					image.x = getScreenX(l, c)-BLOCK_WIDTH/2;
					image.y = getScreenY(l, c)-BLOCK_HEIGHT/2;
					hittestImagesList.push(image);
					
					contents.addChild(image);
				}
			}
		}
		
		private function redrawBGTile(l:uint, c:uint):void {
			var tp:TilePrototype;
			var TPID:uint=map[l][c];
			if (TPID<1) {TPID=1;}// default
			
			tp = getTilePrototypeById(TPID);
			//draw
			bg.bitmapData.copyPixels(tp.get_bd(), tp.get_bd().rect, new Point(getScreenX(l, c) - BLOCK_WIDTH / 2, getScreenY(l, c) - BLOCK_HEIGHT / 2), null, null, true);
			
		}
		
		private function createHitTestBitmap():Bitmap {
			return new Bitmap(BitmapData(images_[0]).clone());
		}
		
		private function drawBDTile(textures:Array, textSN:uint, maskImage:BitmapData=null, mask:BitmapData=null, targetBD:BitmapData=null):BitmapData {
			var targetImage:BitmapData;
			if (targetBD) {
				targetImage=targetBD;
			} else {
				targetImage= BitmapData(textures[textSN]).clone();
			}
			if (maskImage) {
				targetImage.copyPixels(maskImage, maskImage.rect, new Point(0, 0), mask, new Point(0, 0), true);
			}
			return targetImage;
		}
		
		private function saveImage():void {
			if (!imagesAreLoaded) {
				panel.showMsgPanel('wait until all imagess are loaded', 'cannot perform operation');
				return;
			}
			
			sl('SaveImage>generating image data');
			
			var data:ByteArray;
			//waitForRender(function():void{//will not work in browser
				drawMap();
				r_el_main(ID_E_SAVE_IMAGE, bg.bitmapData);
			//});
		}
		
		
		public function getScreenX(wx:Number, wy:Number):Number {
			return wx*BLOCK_WIDTH+wy%2*BLOCK_WIDTH/2;
		}
		public function getScreenY(wx:Number, wy:Number):Number {
			return wy*BLOCK_HEIGHT/2;
		}
		//} =*^_^*= END OF display
		
		//{ =*^_^*= display &data
		private function clearMapContainer():void {
			if (bg &&bg.bitmapData) {
				bg.bitmapData.dispose();
				bg.bitmapData=null;
			}
			for each(var i:Bitmap in hittestImagesList) {
				i.bitmapData.dispose();
				i.bitmapData=null;
			}
			while(container.numChildren>0) {container.removeChildAt(0);}
			contents = new Sprite();
			contents.cacheAsBitmap = true;
			container.addChild(contents);
		}
		
		private function applySettings(d:DUSettings):void {
			initialize(d.get_imagesURL(),d.get_masksURL(),el_main, d.get_blockWidth(),d.get_blockHeight());
			clearMapContainer();
			clearMapData();
			clearTPData();
			loadImages();
		}
		//} =*^_^*= END OF display &data
		
		//{ =*^_^*= data
		private function createNewTilePrototype(name:String):void {
			createAddAndDisplayTilePrototype(name, listTilePrototypes.length+1);
		}
		
		private function clearTPData():void {
			for each(var i:TilePrototype in listTilePrototypes) {i.destruct();}
			listTilePrototypes=null;
		}
		
		private function createAndDisplayDefaultTilePrototype():void {
			if (listTilePrototypes.length<1) {createAddAndDisplayTilePrototype('Default', 1, 'SPACE');}
		}
		private function createAddAndDisplayTilePrototype(name:String, id:uint, hotkey:String=null):void {
			var tp:TilePrototype = new TilePrototype(id, name, hotkey);
			addNewLayer(tp);
			listTilePrototypes.push(tp);
			displayListTilePrototype();
		}
		
		private function createLayer(id:uint, name:String, imageID:uint, maskID:uint):Layer {
			return new Layer(imageID, maskID, id, name);
		}
		
		private function deleteLayer(tp:TilePrototype, layerIndex:uint):void {
			tp.removeLayer(layerIndex);
		}
		
		private function getTilePrototypeById(a:uint):TilePrototype {
			// TODO: cache ids in sync array for far more faster access
			for each(var i:TilePrototype in listTilePrototypes) {if (i.get_id()==a) {return i;}}
		}
		
		private function addNewLayer(tp:TilePrototype):void {
			tp.addLayer(createLayer(tp.get_layers().length, 'Layer #'+tp.get_layers().length, 0, 0));
		}
		
		private function saveMap():void {
			//imagesURL:Array, masksURL:Array, listener:Function, mapW:uint, mapH:uint, screenW:uint=1000, screenH:uint=700, blockWidth:uint=100, blockHeight:uint=50
			r_el_main(ID_E_SAVE_MAP_DATA
				,new DUSettings(
					images_URLS
					,masks_URLS
					,MAP_WIDTH
					,MAP_HEIGHT
					,BLOCK_WIDTH
					,BLOCK_HEIGHT
					,listTilePrototypes
					,map
				).toString()
			);
		}
		
		private function saveSettings():void {
			r_el_main(ID_E_SAVE_SETTINGS_DATA
				,new DUSettings(
					panelCfg.get_ImagesList()//images_URLS
					,panelCfg.get_MasksList()//,masks_URLS
					,0
					,0
					,panelCfg.get_bw()
					,panelCfg.get_bh()
					,listTilePrototypes
					,null
				).toString()
			);
		}
		
		
		private function loadSettings():void {
			sl('Load settings>select file with settings data');
			var fr:FileReference=new FileReference();
			fr.addEventListener(Event.SELECT, function(e:Object):void {
				sl('Load settings>Loading');
				waitForRender(function():void{fr.load();});
			});
			fr.addEventListener(Event.CANCEL, function(e:Object):void {sl('U have to edit them manually');});
			fr.addEventListener(Event.COMPLETE, function(e:Object):void {
					sl('Load settings>Loaded');
					r_el_main(ID_A_LOAD_SETTINGS_DATA, fr.data);
				}
			);
			fr.browse([new FileFilter('BGTileMapEditorFile map data files', '*.BGTileMapEditorFile')]);	
		}
		
		private function loadMap():void {
			sl('Load map data>select file with map&settings data');
			var fr:FileReference=new FileReference();
			fr.addEventListener(Event.SELECT, function(e:Object):void {
				sl('Load map data>Loading');
				waitForRender(function():void{fr.load();});
			});
			fr.addEventListener(Event.CANCEL, function(e:Object):void {
				r_el_main(ID_A_LOAD_MAP_DATA_ABORT,null);
			});
			fr.addEventListener(Event.COMPLETE, function(e:Object):void {
					r_el_main(ID_A_LOAD_MAP_DATA, fr.data);
				}
			);
			fr.browse([new FileFilter('BGTileMapEditorFile map data files', '*.BGTileMapEditorFile')]);	
		}
		
		private function clearMapData():void {
			map = [];
			images = [];
			for (var c:int = 0; c < MAP_WIDTH; c++) {
				if (!map[c]) {map[c] = [];}
				if (!images[c]) {images[c] = [];}
				for (var l:int = 0; l < MAP_HEIGHT; l++) {
					map[c][l] = 1;//default id
				}
			}
			mapPresent=true;
		}
		//} =*^_^*= END OF data
		
		//{ =*^_^*= view
		private function displayMasksList():void {
			var vs:Vector.<String>=new Vector.<String>;
			var vd:Vector.<DisplayObject>=new Vector.<DisplayObject>;
			var vu:Vector.<uint>=new Vector.<uint>;
			
			var b:Bitmap;
			for (var i:uint = 0;i < masks_.length;i++ ) {
				b = new Bitmap(masks_[i]);
				vd.push(b);vs.push(masks_Names[i]);vu.push(i);
			}
			
			panelMasks.setContent(vs,vd,vu,1);
			//panelMasks.setContent(vs,vd,vu,5);
		}
		
		private function displayImagesList():void {
			var vs:Vector.<String>=new Vector.<String>;
			var vd:Vector.<DisplayObject>=new Vector.<DisplayObject>;
			var vu:Vector.<uint>=new Vector.<uint>;
			
			var b:Bitmap;
			for (var i:uint = 0;i < images_.length;i++ ) {
				b = new Bitmap(images_[i]);
				vd.push(b);vs.push(images_Names[i]);vu.push(i);
			}
			
			panel.setContent(vs,vd,vu,-1);
		}
		
		private function displayListTilePrototype():void {
			//reset hotkeys
			keyb_LSHK=[];
			var vs:Vector.<String>=new Vector.<String>;
			var vs0:Vector.<String>=new Vector.<String>;
			var vd:Vector.<DisplayObject>=new Vector.<DisplayObject>;
			var vu:Vector.<uint>=new Vector.<uint>;
			var sn:uint=0;
			var changed_:Boolean;
			for each(var i:TilePrototype in listTilePrototypes) {
				if (i.get_changed()) {op_constructTilePrototypeBD(i);changed_=true;}
				vd.push(i.get_b());
				vs.push(i.get_name());
				vs0.push('Hotkey:'+i.get_hotkey()+', ID:'+i.get_id());
				keyb_LSHK.push(i.get_hotkey());
				vu.push(sn);
				sn+=1;
			}
			panelSamplesList.setContent(vs,vs0,vd,vu,1);
			if (changed_&&mapPresent) {drawMap();}
		}
		
		private function displayTilePrototypeDetails(a:TilePrototype):void {
			// name and hotkey
			panelSampleDetails.setText(a.get_name(), 'Hotkey:'+a.get_hotkey());
			
			// layers:
			var vs:Vector.<String>=new Vector.<String>;
			var vs0:Vector.<String>=new Vector.<String>;
			var vd:Vector.<DisplayObject>=new Vector.<DisplayObject>;
			var vd0:Vector.<DisplayObject>=new Vector.<DisplayObject>;
			var vu:Vector.<uint>=new Vector.<uint>;
			var sn:uint=0;
			for each(var i:Layer in a.get_layers()) {
				vd.push(new Bitmap(images_[i.get_im()]));
				vd0.push(new Bitmap(masks_[i.get_mask()]));
				vs.push(i.get_name());
				vu.push(sn);
				sn+=1;				
			}
			panelSampleDetails.setContent(vs,vd,vd0,vu,1);
		}
		//} =*^_^*= END OF view
		
		//{ =*^_^*= containers and main bitmap
		private function prepareBitmap():void {
			bg = new Bitmap(new BitmapData(
					BLOCK_WIDTH * MAP_WIDTH - BLOCK_WIDTH / 2
					,BLOCK_HEIGHT/2*(MAP_HEIGHT-1)
					,true
					,0
				)
				,'auto'
				,true
			);
		}
		
		private function createBGImageRectMask():Sprite {
			var s:Sprite = container.addChild(new Sprite());
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0
				,BLOCK_WIDTH * MAP_WIDTH - BLOCK_WIDTH / 2
				,BLOCK_HEIGHT/2*(MAP_HEIGHT-1)	
			);
			return s;
		}
		//} =*^_^*= END OF containers and main bitmap
		
		//{ =*^_^*= operations
		private function op_constructTilePrototypeBD(tp:TilePrototype):void {
			var bd:BitmapData;
			var im:BitmapData;
			var ma:BitmapData;
			var tmpP:Point = new Point(0, 0);
			for each(var i:Layer in tp.get_layers()) {
				im=images_[i.get_im()];
				ma=masks_[i.get_mask()];
				if (!bd) {bd=new BitmapData(im.width, im.height, true , 0);}
				
				// add masked image
				bd.copyPixels(im, im.rect, tmpP, ma, tmpP, true);
			}
			tp.set_bd(bd);
		}
		//} =*^_^*= END OF operations
		
		//{ =*^_^*= res
		private function loadImages():void {
			if (!imagesURLSAreChanged) {sl('loadImages>!imagesURLSAreChanged');return;}
			imagesAreLoaded=false;
			res_numTotal=images_URLS.length+masks_URLS.length;
			sl('loading images. total:'+res_numTotal);
			for each(var i:String in images_URLS) {
				new Im(i, null, null, res_el_im, res_el_im);
			}
			for each(i in masks_URLS) {
				new Im(i, null, null, res_el_im, res_el_im);
			}
		}
		
		private function res_el_im(a:Im, err:Boolean=false):void {
			res_numLoaded+=1;
			if (err) {
				el_main(ID_E_RES_IMAGE_LOAD_ERROR, a.get_path());
			} else if (images_URLS.indexOf(a.get_path())<0&&masks_URLS.indexOf(a.get_path())<0) {
				el_main(ID_E_RES_IMAGE_LOAD_ERROR, a.get_path());
			} else {
				if (images_URLS.indexOf(a.get_path())!=-1) {
					images_[images_URLS.indexOf(a.get_path())]=Bitmap(a.content).bitmapData;
				} else {
					masks_[masks_URLS.indexOf(a.get_path())]=Bitmap(a.content).bitmapData;
				}
			}
			sl('Images left:'+(res_numTotal-res_numLoaded)+', loaded:'+a.get_path().substr(a.get_path().lastIndexOf('/')+1));
			if (res_numLoaded>=res_numTotal) {
				imagesAreLoaded=true;
				sl(res_numTotal+' images loaded');
				el_main(ID_E_RES_IMAGES_LOADED, null);
			}
		}
		private var imagesAreLoaded:Boolean;
		private var res_numLoaded:uint;
		private var res_numTotal:uint;
		//} =*^_^*= END OF res
				
		//{ =*^_^*= =*^_^*= User Interface
		
		//{ =*^_^*= StateLine
		private function waitForRender(f:Function):void {
			slt.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void{
				e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
				f();
			});
			slt.reset();
			slt.start();
		}
		
		
		private function sl(a:String):void {
			c.addLine(['SL>'+a]);
			slDT.text=a;
		}
		
		private function prepareStateLine():void {
			sls=userInterfaceContainer.addChild(new BGTileMapEditorLibrary.LStatusLine());
			sls.x = Math.max(CX+vpW/2-sls.width/2, 200+300);//masks and samples panels
			slDT=sls.getChildByName('dt0');
			sl('');
		}
		
		private var slt:Timer=new Timer(300, 1);
		private var slDT:TextField;
		private var sls:DisplayObjectContainer;
		//} =*^_^*= END OF StateLine
		
		//{ =*^_^*= panel
		private function preparePanel():void {
			panel.setImageListener(function(a:uint):void {
				sl('Image #'+a+' selected');
				el_main(ID_E_IMAGE_SELECTED, a);
			});
			
			panel.setButtonListener(el_buttonsPanel);
		}
		private var panel:EditorBottomPanel;
		//} =*^_^*= END OF panel
		
		//{ =*^_^*= masks panel
		private function prepareMasksPanel():void {
			panelMasks.setImageListener(function(a:uint):void {
				sl('masks panel>item selected:item index'+a);
				panelMasks.get_container().visible=false;
				el_main(ID_E_MASK_SELECTED, a);
			});
		}
		private var panelMasks:EditorMasksPanel;
		//} =*^_^*= END OF masks panel
		
		//{ =*^_^*= sample panel
		private function prepareSamplePanel():void {
			panelSampleDetails.setImageListener(function(imageID:uint, buttonID:uint):void {
				el_main(ID_E_SAMPLE_LAYER_SELECTED, {ii:imageID, bi:buttonID});
			});
		}
		private function el_panelSampleDetailsButton(buttonID:uint):void {
			switch (buttonID) {
			
			case EditorSamplePanel.ID_BUTTON_BACK:
				el_main(ID_A_CLOSE_PANEL_SAMPLE_DETAIL,null);
				break;
			
			case EditorSamplePanel.ID_BUTTON_NEW_LAYER:
				el_main(ID_A_NEW_LAYER,null);
				break;
			
			case EditorSamplePanel.ID_BUTTON_DELETE_LAYER:
				el_main(ID_A_DELETE_LAYER,null);
				break;
			
			
			}
			
		}
		
		private var panelSampleDetails:EditorSamplePanel;
		//} =*^_^*= END OF sample panel
		
		//{ =*^_^*= samples list panel
		private function prepareSamplesPanel():void {
			panelSamplesList.setImageListener(function(imageID:uint, buttonID:uint):void {
				el_main(ID_E_SAMPLE_SELECTED, {ii:imageID, bi:buttonID});
			});
		}
		private var panelSamplesList:EditorSamplesListPanel;
		//} =*^_^*= END OF samples list panel
		
		//{ =*^_^*= settings wnd
		private function prepareSettingsPanel():void {
			panelCfg.setButtonListener(function(buttonID:uint):void{
				switch (buttonID) {
				
				case SettingsPanel.ID_BUTTON_LOAD:
					el_main(ID_E_LOAD_SETTINGS, null);
					break;
					
				case SettingsPanel.ID_BUTTON_SAVE:
					saveSettings();
					break;
				case SettingsPanel.ID_BUTTON_GET_SAMPLE_FILES:
					sl('Settings>feature not implemented yet');
					break;
				case SettingsPanel.ID_BUTTON_APPLY:
					el_main(ID_E_APPLY_SETTINGS, {
						bw:panelCfg.get_bw()
						,bh:panelCfg.get_bh()
						,il:panelCfg.get_ImagesList()
						,ml:panelCfg.get_MasksList()
					});
					//panelCfg.visible=false;
					//break;
				case SettingsPanel.ID_BUTTON_CLOSE:
					panelCfg.visible=false;
					break;
				
				}
			});
		}
		private var panelCfg:SettingsPanel;
		//} =*^_^*= END OF settings wnd
		
		//} =*^_^*= =*^_^*= END OF User Interface
		
		//{ =*^_^*= private		
		private var mode:uint;
		private var r_el_main:Function;
		private var initialized:Boolean;
		private var standaloneMode:Boolean;
		
		/**
		 * [][]
		 */
		private var map:Array = [];
		
		private var listTilePrototypes:Vector.<TilePrototype>=new Vector.<TilePrototype>;
		
		private var selectedLayerIndex:int=-1;
		private var selectedTilePrototypeIndex:int=-1;
		private var selectedToolTilePrototypeIndex:int=-1;
		
		private var hittestImagesList:Array=[];
		private var masks_:Array=[];
		/**
		 * hittest
		 */
		private var images:Array=[];
		private var images_:Array=[];
		private var masks_Names:Array=[];
		private var images_Names:Array=[];
		private var images_URLS:Array=[];
		private var masks_URLS:Array=[];
		private var imagesURLSAreChanged:Boolean;
		/**
		 * BitmapData
		 */
		//private var textures:Array;
		//private var images:Array=[];
		
		private var bg:Bitmap;
		private var container:DisplayObjectContainer = new Sprite();
		private var contents:DisplayObjectContainer;
		private var containerMask:Sprite=new Sprite();
		private var userInterfaceContainer:Sprite=new Sprite();
		private var mapPresent:Boolean;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= id
		private static const ID_A_SET_IMAGE:uint=0;
		private static const ID_A_SET_MASK:uint=1;
		
		private static const ID_MODE_KEYBOARD_DEFAULT:uint=0;
		private static const ID_MODE_KEYBOARD_SET_HOTKEY:uint=1;
		
		private static const ID_MODE_APP_DEFAULT:uint=0;
		private static const ID_MODE_APP_DELETE_LAYER:uint=1;
		private static const ID_MODE_APP_LOAD_MAP:uint=2;
		private static const ID_MODE_APP_LOAD_SETTINGS:uint=3;
		private static const ID_MODE_APP_QUIT:uint=4;
		
		//events and actions
		/**
		 * data:String
		 */
		public static const ID_E_SAVE_MAP_DATA:String='ID_E_SAVE_MAP_DATA';
		/**
		 * data:String
		 */
		public static const ID_E_SAVE_SETTINGS_DATA:String='ID_E_SAVE_SETTINGS_DATA';
		/**
		 * data:BitmapData
		 */
		public static const ID_E_SAVE_IMAGE:String='ID_E_SAVE_IMAGE';
		public static const ID_E_READY_FOR_MAP_LOAD:String='ID_E_READY_FOR_MAP_LOAD';
		public static const ID_E_CLOSE:String='ID_E_CLOSE';
		
		//internal
		private static const ID_A_LOAD_MAP_DATA_ABORT:String='ID_A_LOAD_MAP_DATA_ABORT';
		/**
		 * data:String
		 */
		private static const ID_A_LOAD_MAP_DATA:String='ID_A_LOAD_MAP_DATA';
		private static const ID_A_LOAD_SETTINGS_DATA:String='ID_A_LOAD_SETTINGS_DATA';
		
		/**
		 * data:uint//index
		 */
		private static const ID_E_MASK_SELECTED:String='ID_E_MASK_SELECTED';
		/**
		 * data:uint//index
		 */
		private static const ID_E_IMAGE_SELECTED:String='ID_E_IMAGE_SELECTED';
		/**
		 * data:{ii:uint//item index//, bi:uint//0 - image button, 1 - mask button, 2 - hotkey//}
		 */
		private static const ID_E_SAMPLE_LAYER_SELECTED:String='ID_E_SAMPLE_LAYER_SELECTED';
		/**
		 * data:{ii:uint//item index//, bi:uint//0 - image button, 1 - hotkey//}
		 */
		private static const ID_E_SAMPLE_SELECTED:String='ID_E_SAMPLE_SELECTED';
		private static const ID_A_CLOSE_PANEL_SAMPLE_DETAIL:String='ID_A_CLOSE_PANEL_SAMPLE_DETAIL';
		private static const ID_A_NEW_LAYER:String='ID_A_NEW_LAYER';
		private static const ID_A_DELETE_LAYER:String='ID_A_DELETE_LAYER';
		/**
		 * data:uint//keyCode
		 */
		private static const ID_E_HOTKEY_SELECTED:String='ID_E_HOTKEY_SELECTED';
		/**
		 * data:uint//index
		 */
		private static const ID_E_SAMPLE_ACTIVATED:String='ID_E_SAMPLE_ACTIVATED';
		/**
		 * data:uint//index
		 */
		private static const ID_E_SAMPLE_DEACTIVATED:String='ID_E_SAMPLE_DEACTIVATED';
		private static const ID_E_RES_IMAGES_LOADED:String='ID_E_RES_IMAGES_LOADED';
		private static const ID_E_RES_IMAGE_LOAD_ERROR:String='ID_E_RES_IMAGE_LOAD_ERROR';
		/**
		 * data:{bw:uint, bh:uint, il:array, ml:array}
		 */
		private static const ID_E_APPLY_SETTINGS:String='ID_E_APPLY_SETTINGS';
		/**
		 * 
		 */
		private static const ID_E_LOAD_SETTINGS:String='ID_E_LOAD_SETTINGS';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= settings
		private var BLOCK_WIDTH:uint = 100;
		private var BLOCK_HEIGHT:uint = 50;
		
		private var MAP_WIDTH:uint = 8;
		private var MAP_HEIGHT:uint = MAP_WIDTH*3;
		
		
		private var screenW:uint=1000;
		private var screenH:uint=700;
		
		private var vpW:uint=screenW-200;
		private var vpH:uint=screenH;
		
		/**
		 * container X
		 */
		private var CX:uint=200;
		private var CY:uint=0;
		//} =*^_^*= END OF settings
		
		
		
		//{ =*^_^*= console
		private function prepareConsole():void {
			if (c) {return;}
			var cc:ConsoleConfig=new ConsoleConfig();
			cc.alwaysOnTop=false;
			c = new Console('`', cc);
			//c.visible=true;
			c.remoting=false;
			c.height=Math.min(screenH,300);
			c.y=screenH-c.height;
			c.width=screenW;
			addChild(c);
		}
		private static var c:Console;
		//} =*^_^*= END OF console
		
		
		//{ =*^_^*= logging
		private function prepareLogging():void {
			if (logger) {return;}
			logger = new Logger(APP_NAME);
			logger.advancedOut = loggerOut;
			LOGGER0.setL(log0);
		}
		//} =*^_^*= END OF logging
		
		//{ =^_^= logger
		private function log0(message:String, level:uint = 0):void {
			logger.log(message, level);
		}
		
		private function loggerOut(t:String, l:uint):void {
			switch (l) {
				case Logger.LEVEL_ERROR:
					c.error(t);
					break;
				case Logger.LEVEL_WARNING:
					c.warn(t);
					break;
				case Logger.LEVEL_INFO:
					c.log(t);
					break;
			}
		}
		
		private static var logger:Logger;
		//} =^_^= END OF logger
		
		/**
		 * for app's logger
		 */
		private const APP_NAME:String = "BGTileMapEditor";
	}
}

//{ =*^_^*= import
import com.adobe.serialization.json.JSON;
import flash.display.Bitmap;
import flash.display.BitmapData
//} =*^_^*= END OF import

class TilePrototype {
	function TilePrototype (id:uint, name:String, hotkey:String=null):void {
		this.name=name;
		this.id=id;
		this.hotkey=hotkey;
	}

	public function destruct():void {
		layers=null;
		if (b.parent) {b.parent.removeChild(b);}
		b.bitmapData=null;
		if (bd) {bd.dispose();}
	}
	
	public function addLayer(a:Layer):void {
		layers.push(a);
		changed=true;
	}
	
	public function removeLayer(layerIndex:uint):void {
		layers.splice(layerIndex, 1);
		changed=true;
	}
	
	public function toJSONObject():Object {
		var l:Array=[];
		for each(var i:Layer in layers) {l.push(i.toJSONObject());}
		return {
			i:id
			,n:name
			,h:hotkey
			,l:l
		};
	}
	
	public static function fromJSONObject(d:Object):TilePrototype {
		var it:TilePrototype=new TilePrototype(parseInt(d.i), d.n, d.h);
		for each(var i:Object in d.l) {
			it.addLayer(Layer.fromJSONObject(i));
		}
		return it;
	}
	
	public function get_id():uint {return id;}
	public function get_name():String {return name;}
	public function set_name(a:String):void {name = a;}
	public function get_hotkey():String {return hotkey;}
	public function set_hotkey(a:String):void {hotkey = a;}

	public function get_layers():Vector.<Layer> {return layers;}
	public function set_layers(a:Vector.<Layer>):void {layers = a;}
	
	public function get_bd():BitmapData {return bd;}
	/**
	 * cannot be null
	 */
	public function set_bd(a:BitmapData):void {bd = a;b.bitmapData=bd;changed=false;}
	public function get_b():Bitmap {return b;}
	public function set_b(a:Bitmap):void {b = a;}
	public function get_changed():Boolean {return changed;}
	public function set_changed(a:Boolean):void {changed = a;}

	private var changed:Boolean;
	private var bd:BitmapData;
	private var b:Bitmap = new Bitmap();
	private var layers:Vector.<Layer> = new Vector.<Layer>;
	private var name:String;
	private var hotkey:String;
	private var id:uint;
	
}

class Layer {
	function Layer (im:uint, mask:uint, id:uint, name:String):void {
		this.mask=mask;
		this.name=name;
		this.id=id;
		this.im=im;
	}

	public function get_im():uint {return im;}
	public function set_im(a:uint):void {im = a;}
	public function get_mask():uint {return mask;}
	public function set_mask(a:uint):void {mask = a;}
	public function get_id():uint {return id;}
	public function get_name():String {return name;}
	public function set_name(a:String):void {name = a;}
	
	
	public function toJSONObject():Object {
		return {
			n:name
			,i:id
			,g:im
			,m:mask
		};
	}
	public static function fromJSONObject(d:Object):Layer {
		return new Layer(parseInt(d.g), parseInt(d.m), parseInt(d.i), d.n);
	}
	
	private var name:String;
	private var id:uint;
	private var im:uint;
	private var mask:uint;
}

class DUSettings  {
	function DUSettings (imagesURL:Array, masksURL:Array, mapW:uint, mapH:uint, blockWidth:uint, blockHeight:uint, tp:Vector.<TilePrototype>, map:Array):void {
		this.imagesURL=imagesURL;
		this.masksURL=masksURL;
		this.mapW=mapW;
		this.mapH=mapH;
		this.blockWidth=blockWidth;
		this.blockHeight=blockHeight;
		this.tp=tp;
		this.map=map;
	}
	
	public function get_imagesURL():Array {return imagesURL;}
	public function get_masksURL():Array {return masksURL;}
	public function get_mapW():uint {return mapW;}
	public function get_mapH():uint {return mapH;}
	public function get_blockWidth():uint {return blockWidth;}
	public function get_blockHeight():uint {return blockHeight;}
	public function get_tp():Vector.<TilePrototype> {return tp;}
	public function get_map():Array {return map;}
	
	private var map:Array;
	private var imagesURL:Array;
	private var masksURL:Array;
	private var mapW:uint;
	private var mapH:uint;
	private var blockWidth:uint;
	private var blockHeight:uint;
	private var tp:Vector.<TilePrototype>;
	
	public function toString():String {
		var l:Array=[];
		for each(var i:TilePrototype in tp) {l.push(i.toJSONObject());}
		
		return JSON.encode(
			{
				imagesURL:imagesURL
				,masksURL:masksURL
				,mapW:mapW
				,mapH:mapH
				,tileWidth:blockWidth
				,tileHeight:blockHeight
				,tp:l
				,mapData:map
			}
		);
	}
	
	public static function fromString(a:String):DUSettings {
		var d:Object=JSON.decode(a);
		var tp:Vector.<TilePrototype> = new Vector.<TilePrototype>;
		for each(var i:Object in d.tp) {
			tp.push(TilePrototype.fromJSONObject(i));
		}
		return new DUSettings(
			d.imagesURL
			,d.masksURL
			,parseInt(d.mapW)
			,parseInt(d.mapH)
			,parseInt(d.tileWidth)
			,parseInt(d.tileHeight)
			,tp
			,d.mapData
		);
	}
	
	
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]