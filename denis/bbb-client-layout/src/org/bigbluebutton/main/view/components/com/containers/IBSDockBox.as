package org.bigbluebutton.main.view.components.com.containers
{
	
	import org.bigbluebutton.main.view.components.com.controls.IBSDockBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Spacer;
	import mx.core.Application;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	
	//--------------------------------------
	//  Styles
	//-------------------------------------- 
	
	[Style(name="panelStyleName", type="String", inherit="no")]
	
	
	//--------------------------------------
	//  Events
	//-------------------------------------- 
	
	[Event(name="dockedChanged", type="flash.events.Event")]
	
	
	public class IBSDockBox extends Canvas
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const DOCKBAR_SIZE:Number = 22;
		
		public static const AUTO_HIDE_TIMEOUT:int = 700;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function IBSDockBox()
		{
			super();
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			addEventListener(ResizeEvent.RESIZE, resizeHandler);
			addEventListener(Event.RENDER, renderHandler);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var dockBar:IBSDockBar = null;
		
		private var dockContainer:ViewStack = null;
		
		private var spacer:Spacer = null;
		
		private var moveEffect:Move = null;
		
		private var dockPanels:Array = null;
		
		private var currentPanel:IBSDockablePanel = null;
		
		private var dockContainerSize:Number = NaN;
		
		private var autoShowFlag:int = -1;
		
		private var autoPlayEffect:int = -1;
		
		private var timer:Timer = null;
		
		private var mouseInDockPanel:Boolean = false;
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		override public function set horizontalScrollPolicy(value:String):void
		{
			if (super.horizontalScrollPolicy != "off")
				super.horizontalScrollPolicy = "off";
		}
		
		override public function set verticalScrollPolicy(value:String):void
		{
			if (super.verticalScrollPolicy != "off")
				super.verticalScrollPolicy = "off";
		}
		
		override public function set initialized(value:Boolean):void
		{
			if (value)
			{
				resetLayout();
				validateNow();
			}
			super.initialized = value;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  position
		//----------------------------------
		
		private var _position:String = "left";
		
		private var positionChanged:Boolean = false;
		
		[Bindable("positionChanged")]
		[Inspectable(category="General", defaultValue="left")]
		public function get position():String
		{
			return _position;
		}
		
		public function set position(value:String):void
		{
			if (_position != value)
			{
				_position = value;
				positionChanged = true;
				createDockContainerAndDockBar();
				resetLayout();
				invalidateDisplayList();
				dispatchEvent(new Event("positionChanged"));
			}
		}
		
		
		//----------------------------------
		//  docked
		//----------------------------------
		
		private var _docked:Boolean = true;
		
		private var dockedChanged:Boolean = true;
		
		[Bindable("dockedChanged")]
		[Inspectable(category="General", defaultValue="true")]
		public function get docked():Boolean
		{
			return _docked;
		}
		
		public function set docked(value:Boolean):void
		{
			if (_docked != value)
			{
				_docked = value;
				dockedChanged = true;
				createDockContainerAndDockBar();
				dockBar.rebound = !_docked;
				dockBar.selectedIndex = dockContainer.selectedIndex;
				if (timer)
					timer.stop();
				if (_docked)
				{
					setAutoHide(false);
					if (moveEffect)
						moveEffect.end();
					retakePanels();
				}
				resetLayout();
				invalidateDisplayList();
				dispatchEvent(new Event("dockedChanged"));
			}
		}
		
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		
		private var _selectedIndex:int = -1;
		
		private var selectedIndexChanged:Boolean = false;
		
		private var setSelectedIndexFlag:Boolean = false;
		
		[Bindable("selectedIndexChanged")]
		[Inspectable(category="General", defaultValue="-1")]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			selectedIndexChanged = true;
			createDockContainerAndDockBar();
			if (setSelectedIndexFlag)
			{
				dispatchEvent(new Event("selectedIndexChanged"));
				return;
			}
			invalidateDisplayList();
			dispatchEvent(new Event("selectedIndexChanged"));
		}
		
		
		//----------------------------------
		//  dockPanelFactories
		//----------------------------------
		
		private var _dockPanelFactories:Array = null;
		
		private var dockPanelFactoriesChanged:Boolean = false;
		
		[Inspectable(category="General", defaultValue="null")]
		public function get dockPanelFactories():Array
		{
			return _dockPanelFactories;
		}
		
		public function set dockPanelFactories(value:Array):void
		{
			_dockPanelFactories = value;
			dockPanelFactoriesChanged = true;
			createDockContainerAndDockBar();
			if (value == null || (value != null && value.length == 0))
				selectedIndex = -1;
			else
				if (_selectedIndex >= 0 && _selectedIndex < value.length)
					selectedIndex = _selectedIndex;
				else
					selectedIndex = -1;
			invalidateDisplayList();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			createDockContainerAndDockBar();
			if (!moveEffect)
			{
				moveEffect = new Move();
				moveEffect.duration = 1000;
				moveEffect.addEventListener(EffectEvent.EFFECT_END, moveEffectEndHandler);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
				unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var showFlag:Boolean = false;
			if (dockPanelFactoriesChanged)
			{
				dockPanelFactoriesChanged = false;
				addPanels();
			}
			if (selectedIndexChanged)
			{
				selectedIndexChanged = false;
				if (dockBar)
					dockBar.selectedIndex = _selectedIndex;
				showFlag = true;
			}
			if (dockedChanged)
			{
				dockedChanged = false;
				showFlag = true;
			}
			if (positionChanged)
			{
				dockBar.position = _position;
				positionChanged = false;
				showFlag = true;
			}
			if (showFlag)
				showPanel();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function createDockContainerAndDockBar():void
		{
			if (!dockContainer)
			{
				dockContainer = new ViewStack();
				addChild(dockContainer);
			}
			if (!dockBar)
			{
				dockBar = new IBSDockBar();
				addChild(dockBar);
				dockBar.rebound = !_docked;
				dockBar.targetStack = dockContainer;
				dockBar.addEventListener(IBSDockBar.DOCKBAR_AUTO_SELECT, 
						dockBarAutoSelectHandler);
			}
			if (!spacer)
			{
				spacer = new Spacer();
				addChild(spacer);
			}
		}
		
		private function resetLayout():void
		{
			if (getStyle("borderStyle") != "none")
				setStyle("borderStyle", "none");
			if (!(getStyle("left") == undefined || getStyle("left") == 0))
				setStyle("left", 0);
			if (!(getStyle("right") == undefined || getStyle("right") == 0))
				setStyle("right", 0);
			if (!(getStyle("top") == undefined || getStyle("top") == 0))
				setStyle("top", 0);
			if (!(getStyle("bottom") == undefined || getStyle("bottom") == 0))
				setStyle("bottom", 0);
			if (!parent)
				return;
			
			createDockContainerAndDockBar();
			var currentWidth:Number = width;
			var currentHeight:Number = height;
			var actualWidth:Number = 0;
			var actualHeight:Number = 0;
			var dockBarShowFlag:Boolean = true;
			if (!_dockPanelFactories || (_dockPanelFactories && 
					_dockPanelFactories.length == 0))
				dockBarShowFlag = false;
			if (_docked && (_dockPanelFactories && _dockPanelFactories.length == 1))
				dockBarShowFlag = false;
			if (_docked)
			{
				if (dockBar.isPopUp)
				{
					PopUpManager.removePopUp(dockBar);
					dockBar.includeInLayout = false;
					addChild(dockBar);
					dockBar.includeInLayout = true;
				}
				dockBar.visible = dockBarShowFlag;
				dockContainer.visible = true;
				spacer.visible = false;
			}
			else
			{
				if (!dockBar.isPopUp)
				{
					removeChild(dockBar);
					dockBar.includeInLayout = false;
					PopUpManager.addPopUp(dockBar, Application.application as Sprite);
					dockBar.includeInLayout = true;
					dockBar.visible = true;
				}
				dockContainer.visible = false;
				spacer.visible = false;
			}
			
			if (_docked)
			{
				if (_position == "left" || _position == "right")
				{
					dockBar.width = DOCKBAR_SIZE;
					dockBar.height = currentHeight;
					if (isNaN(dockContainerSize))
					{
						dockContainer.width = currentWidth - 
								(dockBar.visible ? dockBar.width : 0);
						dockContainerSize = dockContainer.width;
					}
					else
					{
						dockContainer.width = dockContainerSize;
					}
					dockContainer.height = currentHeight;
				}
				else
				{
					dockBar.width = currentWidth;
					dockBar.height = DOCKBAR_SIZE;
					dockContainer.width = currentWidth;
					if (isNaN(dockContainerSize))
					{
						dockContainer.height = currentHeight - 
								(dockBar.visible ? dockBar.height : 0);
						dockContainerSize = dockContainer.height;
					}
					else
					{
						dockContainer.height = dockContainerSize;
					}
				}
			}
			else
			{
				if (_position == "left" || _position == "right")
				{
					spacer.width = DOCKBAR_SIZE;
					spacer.height = currentHeight
					dockBar.width = DOCKBAR_SIZE;
					dockBar.height = currentHeight;
					dockContainerSize = dockContainer.width;
				}
				else
				{
					spacer.width = currentWidth;
					spacer.height = DOCKBAR_SIZE
					dockBar.width = currentWidth;
					dockBar.height = DOCKBAR_SIZE;
					dockContainerSize = dockContainer.height;
				}
			}
			
			if (_docked)
			{
				if (_position == "left" || _position == "right")
				{
					actualWidth = dockContainer.width + 
							(dockBar.visible ? dockBar.width : 0);
					actualHeight = dockBar.height;
					if (_position == "left")
					{
						dockBar.x = 0;
						dockBar.y = 0;
						dockContainer.x = dockBar.x + (dockBar.visible ? dockBar.width : 0);
						dockContainer.y = 0;
					}
					else
					{
						dockContainer.x = 0
						dockContainer.y = 0;
						dockBar.x = dockContainer.x + dockContainer.width;
						dockBar.y = 0;
					}
				}
				else
				{
					actualWidth = dockBar.width;
					actualHeight = dockContainer.height + 
							(dockBar.visible ? dockBar.height : 0);
					if (_position == "top")
					{
						dockBar.x = 0;
						dockBar.y = 0;
						dockContainer.x = 0;
						dockContainer.y = dockBar.y + (dockBar.visible ? dockBar.height : 0);
					}
					else
					{
						dockContainer.x = 0
						dockContainer.y = 0;
						dockBar.x = 0;
						dockBar.y = dockContainer.y + dockContainer.height;
					}
				}
			}
			else
			{
				actualWidth = spacer.width;
				actualHeight = spacer.height;
				spacer.x = 0;
				spacer.y = 0;
				setDockBarPositionAndSize();
			}
			if (currentWidth != actualWidth)
				width = actualWidth;
			if (currentHeight != actualHeight)
				height = actualHeight;
		}
		
		private function addPanels():void
		{
			removePanels();
			if (_dockPanelFactories)
			{
				dockPanels = [];
				for (var i:int = 0; i < _dockPanelFactories.length; i++)
				{
					dockPanels.push(null);
					dockPanels[i] = new (_dockPanelFactories[i]);
					dockPanels[i].owner = this;
					dockPanels[i].index = i;
					dockPanels[i].percentWidth = 100;
					dockPanels[i].percentHeight = 100;
					dockPanels[i].styleName = getStyle("panelStyleName");
					dockPanels[i].addEventListener(MouseEvent.ROLL_OVER, 
							dockPanelRollOverHandler);
					dockPanels[i].addEventListener(MouseEvent.ROLL_OUT, 
							dockPanelRollOutHandler);
					dockPanels[i].addEventListener("dockedChangedByUser", 
							dockPanelDockedChangedByUserHandler);
					dockPanels[i].addEventListener("resizedByUser", 
							dockPanelResizedByUserHandler);
					var box:VBox = new VBox();
					dockContainer.addChild(box);
					BindingUtils.bindProperty(box, "label", dockPanels[i], "title");
					box.addChild(dockPanels[i]);
				}
			}
		}
		
		private function removePanels():void
		{
			if (dockPanels)
			{
				retakePanels();
				for (var i:int = 0; i < dockPanels.length; i++)
				{
					if (dockPanels[i])
					{
						dockPanels[i].removeEventListener(MouseEvent.ROLL_OVER, 
								dockPanelRollOverHandler);
						dockPanels[i].removeEventListener(MouseEvent.ROLL_OUT, 
								dockPanelRollOutHandler);
						dockPanels[i].removeEventListener("dockedChangedByUser", 
								dockPanelDockedChangedByUserHandler);
						dockPanels[i].removeEventListener("resizedByUser", 
								dockPanelResizedByUserHandler);
					}
					if (dockPanels[i] && dockPanels[i].parent)
					{
						(dockPanels[i].parent as VBox).removeAllChildren();
						dockPanels[i].includeInLayout = false;
						dockPanels[i] = null;
					}
				}
			}
			dockPanels = null;
			currentPanel = null;
			dockContainer.removeAllChildren();
		}
		
		private function retakePanels():void
		{
			if (!dockPanels)
				return;
			var i:int = 0;
			for (i = 0; i < dockPanels.length; i++)
			{
				if (dockPanels[i] && dockPanels[i].isPopUp)
				{
					PopUpManager.removePopUp(dockPanels[i]);
					dockPanels[i].includeInLayout = false;
					dockPanels[i].percentWidth = 100;
					dockPanels[i].percentHeight = 100;
					(dockContainer.getChildAt(dockPanels[i].index) as VBox).addChild(
							dockPanels[i]);
					dockPanels[i].includeInLayout = true;
					dockPanels[i].visible = true;
				}
			}
		}
		
		private function showPanel(autoAdjust:Boolean = true):void
		{
			if (moveEffect)
				moveEffect.end();
			retakePanels();
			if (dockPanels && _selectedIndex >= 0 
					&& _selectedIndex <= dockPanels.length - 1)
			{
				currentPanel = dockPanels[_selectedIndex] as IBSDockablePanel;
				if (!_docked)
				{
					if (currentPanel.parent)
					{
						currentPanel.parent.removeChild(currentPanel);
						currentPanel.includeInLayout = false;
					}
					PopUpManager.addPopUp(currentPanel, Application.application as Sprite);
					currentPanel.includeInLayout = true;
					if (autoAdjust)
						setCurrentPanelPositionAndSize();
				}
				currentPanel.docked = _docked;
				dockContainer.selectedIndex = _selectedIndex;
			}
		}
		
		private function autoShowPanel():void
		{
			if (timer)
				timer.stop();
			if (!dockBar || !moveEffect || docked)
				return;
			if (moveEffect.isPlaying && autoShowFlag == 1)
				return;
			if (moveEffect.isPlaying && autoShowFlag == 0)
			{
				autoPlayEffect = 1;
				return;
			}
			showPanel(false);
			var point:Point = dockBar.localToGlobal(new Point(0, 0));
			switch (_position)
			{
				case ("left"):
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					moveEffect.xFrom = point.x + dockBar.width - dockContainer.width;
					moveEffect.yFrom = point.y;
					moveEffect.xTo = point.x + dockBar.width;
					moveEffect.yTo = point.y;
					break;
				case ("right"):
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					moveEffect.xFrom = point.x;
					moveEffect.yFrom = point.y;
					moveEffect.xTo = point.x - dockContainer.width;
					moveEffect.yTo = point.y;
					break;
				case ("top"):
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					moveEffect.xFrom = point.x;
					moveEffect.yFrom = point.y + dockBar.height - dockContainer.height;
					moveEffect.xTo = point.x;
					moveEffect.yTo = point.y + dockBar.height;
					break;
				case ("bottom"):
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					moveEffect.xFrom = point.x;
					moveEffect.yFrom = point.y;
					moveEffect.xTo = point.x;
					moveEffect.yTo = point.y - dockContainer.height;
					break;
				default:
					break;
			}
			PopUpManager.bringToFront(dockBar);
			autoShowFlag = 1;
			moveEffect.play([currentPanel]);
		}
		
		private function autoHidePanel():void
		{
			if (timer)
				timer.stop();
			if (!dockBar || !moveEffect || docked)
				return;
			if (!(currentPanel && currentPanel.index == selectedIndex 
					&& currentPanel.isPopUp))
				return;
			if (mouseInDockPanel)
				return;
			if (moveEffect.isPlaying && autoShowFlag == 0)
				return;
			if (moveEffect.isPlaying && autoShowFlag == 1)
			{
				autoPlayEffect = 0;
				return;
			}
			var point:Point = dockBar.localToGlobal(new Point(0, 0));
			switch (_position)
			{
				case ("left"):
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					moveEffect.xTo = point.x + dockBar.width - dockContainer.width;
					moveEffect.yTo = point.y;
					break;
				case ("right"):
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					moveEffect.xTo = point.x;
					moveEffect.yTo = point.y;
					break;
				case ("top"):
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					moveEffect.xTo = point.x;
					moveEffect.yTo = point.y - dockContainer.height + dockBar.height;
					break;
				case ("bottom"):
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					moveEffect.xTo = point.x;
					moveEffect.yTo = point.y;
					break;
				default:
					break;
			}
			moveEffect.xFrom = currentPanel.x;
			moveEffect.yFrom = currentPanel.y;
			PopUpManager.bringToFront(dockBar);
			autoShowFlag = 0;
			moveEffect.play([currentPanel]);
		}
		
		private function setAutoHide(start:Boolean = true):void
		{
			if (!start)
			{
				if (timer)
					timer.stop();
				return;
			}
			if (!timer)
			{
				timer = new Timer(AUTO_HIDE_TIMEOUT, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);	
			}
			timer.stop();
			timer.reset();
			timer.start();
		}
		
		private function setDockBarPositionAndSize():void
		{
			if (!dockBar || !spacer || docked)
				return;
			var point:Point = localToGlobal(new Point(0, 0));
			dockBar.move(point.x, point.y);
			dockBar.width = spacer.width;
			dockBar.height = spacer.height;
		}
		
		private function setCurrentPanelPositionAndSize():void
		{
			if (!currentPanel || !dockBar || docked || (moveEffect && moveEffect.isPlaying))
				return;
			if (currentPanel.dragging)
				return;
			var point:Point = dockBar.localToGlobal(new Point(0, 0));
			switch (_position)
			{
				case ("left"):
					currentPanel.move(point.x + dockBar.width, point.y);
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					break;
				case ("right"):
					currentPanel.move(point.x - dockContainer.width, point.y);
					currentPanel.width = dockContainer.width;
					currentPanel.height = dockBar.height;
					break;
				case ("top"):
					currentPanel.move(point.x, point.y + dockBar.height);
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					break;
				case ("bottom"):
					currentPanel.move(point.x, point.y - dockContainer.height);
					currentPanel.width = dockBar.width;
					currentPanel.height = dockContainer.height;
					break;
				default:
					break;
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function resizeHandler(event:ResizeEvent):void
		{
			if (!dockBar || !dockContainer || !_docked)
				return;
			if (!dockContainer.visible)
				return;
			if (_position == "left" || _position == "right")
			{
				dockContainer.width = width - (dockBar.visible ? dockBar.width : 0);
				dockContainer.height = height;
			}
			else
			{
				dockContainer.width = width;
				dockContainer.height = height - (dockBar.visible ? dockBar.height : 0);
			}
		}
		
		private function renderHandler(event:Event):void
		{
			callLater(setDockBarPositionAndSize);
			callLater(setCurrentPanelPositionAndSize);
		}
		
		private function dockPanelRollOverHandler(event:MouseEvent):void
		{
			mouseInDockPanel = true;
			setAutoHide(false);
		}
		
		private function dockPanelRollOutHandler(event:MouseEvent):void
		{
			mouseInDockPanel = false;
			if (!docked)
				setAutoHide();
		}
		
		private function dockPanelDockedChangedByUserHandler(event:Event):void
		{
			docked = (event.target as IBSDockablePanel).docked;
		}
		
		private function dockPanelResizedByUserHandler(event:Event):void
		{
			var targetPanel:IBSDockablePanel = event.target as IBSDockablePanel;
			if (dockContainer)
			{
				if (position == "left" || position == "right")
				{
					dockContainer.width = targetPanel.width;
					dockContainerSize = dockContainer.width;
				}
				else
				{
					dockContainer.height = targetPanel.height;
					dockContainerSize = dockContainer.height;
				}
			}
		}
		
		private function dockBarAutoSelectHandler(event:ItemClickEvent):void
		{
			if (docked || !dockPanels || !dockBar)
				return;
			var index:int = event.index;
			if (index < 0 || index > dockPanels.length - 1)
				return;
			setSelectedIndexFlag = true;
			selectedIndex = index;
			setSelectedIndexFlag = false;
			if (event.label == "select")
				autoShowPanel();
			else
				autoHidePanel();
		}
		
		private function moveEffectEndHandler(event:EffectEvent):void
		{
			if (timer)
				timer.stop();
			var playEffect:int = autoPlayEffect;
			autoPlayEffect = -1;
			if (playEffect == 1 || playEffect == 0)
			{
				if (playEffect == 1)
					autoShowPanel();
				else
					autoHidePanel();
				return;
			}
			if (autoShowFlag == -1)
				return;
			if (autoShowFlag == 1)
				return;
			if (autoShowFlag == 0)
				retakePanels();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			if (currentPanel && currentPanel.dragging)
			{
				timer.stop();
				timer.reset();
				timer.start();
			}
			else
			{
				timer.stop();
				autoHidePanel();
			}
			timer.stop();
			autoHidePanel();
		}
		
		
	}
	
	
}