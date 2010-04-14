package org.bigbluebutton.main.view.components.com.controls
{
	
	import org.bigbluebutton.main.view.components.com.controls.dockBarClasses.IBSDockTab;
	
	import flash.events.Event;
	
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.containers.ViewStack;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.IFactory;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DynamicEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	
	public class IBSDockBar extends Box
	{
		
		public static const DOCKBAR_AUTO_SELECT:String = "dockBarAutoSelect";
		
		public static const TAB_PADDING:Number = 5;
		
		public function IBSDockBar()
		{
			super();
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			navItemFactory = new ClassFactory(IBSDockTab);
			position = "left";
			addEventListener(FlexEvent.VALUE_COMMIT, valueCommitHandler);
			addEventListener(IBSDockTab.AUTO_SELECT, autoSelectHandler);
		}
		
		protected var navItemFactory:IFactory = null;
		
		override public function set enabled(value:Boolean):void
		{
			if (value != enabled)
			{
				super.enabled = value;
				setNavChildrenEnabled();
			}
		}
		
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
		
		private var _targetStack:ViewStack = null;
		
		[Bindable("targetStackChanged")]
		public function get targetStack():ViewStack
		{
			return _targetStack;
		}
		
		public function set targetStack(value:ViewStack):void
		{
			var i:int = 0;
			var child:Container = null;
			if (_targetStack)
			{
				_targetStack.removeEventListener(
						ChildExistenceChangedEvent.CHILD_ADD,
						childAddHandler);
				_targetStack.removeEventListener(
						ChildExistenceChangedEvent.CHILD_REMOVE,
						childRemoveHandler);
				_targetStack.removeEventListener(
						IndexChangedEvent.CHILD_INDEX_CHANGE, 
						childIndexChangeHandler);
				for (i = 0; i < _targetStack.numChildren; i++)
				{
					child = targetStack.getChildAt(i) as Container;
					removeEventListenersForTargetStackChild(child);
				}
			}
			_targetStack = value;
			if (_targetStack)
			{
				_targetStack.addEventListener(
						ChildExistenceChangedEvent.CHILD_ADD,
						childAddHandler);
				_targetStack.addEventListener(
						ChildExistenceChangedEvent.CHILD_REMOVE,
						childRemoveHandler);
				_targetStack.addEventListener(
						IndexChangedEvent.CHILD_INDEX_CHANGE, 
						childIndexChangeHandler);
				for (i = 0; i < _targetStack.numChildren; i++)
				{
					child = targetStack.getChildAt(i) as Container;
					addEventListenersForTargetStackChild(child);
				}
			}
			createNavChildren();
			dispatchEvent(new Event("targetStackChanged"));
		}
		
		private var _selectedIndex:int = -1;
		private var selectedIndexChanged:Boolean = false;
		
		[Bindable("selectedIndexChanged")]
		[Inspectable(category="General", defaultValue="left")]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			selectedIndexChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("selectedIndexChanged"));
		}
		
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
			if (value == "left" || value == "right" || value == "top" || value == "bottom")
			{
				_position = value;
				positionChanged = true;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("positionChanged"));
			}
		}
		
		private var _rebound:Boolean = false;
		private var reboundChanged:Boolean = false;
		
		[Bindable("reboundChanged")]
		[Inspectable(category="General", defaultValue="false")]
		public function get rebound():Boolean
		{
			return _rebound;
		}
		
		public function set rebound(value:Boolean):void
		{
			_rebound = value;
			reboundChanged = true;
			invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("reboundChanged"));
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (positionChanged)
			{
				if (_position == "left" || _position == "right")
					direction = BoxDirection.VERTICAL;
				else
					direction = BoxDirection.HORIZONTAL;
				setNavChildrenPosition();
				positionChanged = false;
			}
			if (reboundChanged)
			{
				if (_rebound)
					selectedIndex = -1;
				setNavChildrenRebound();
				reboundChanged = false;
			}
			if (selectedIndexChanged)
			{
				if (_targetStack && _selectedIndex <= _targetStack.numChildren - 1 && 
						!_rebound)
					_targetStack.selectedIndex = _selectedIndex;
				setNavChildrenSelected();
				selectedIndexChanged = false;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
				unscaledHeight:Number):void
		{
			var i:int = 0;
			var item:IBSDockTab = null;
			for (i = 0; i < numChildren; i++)
			{
				item = getChildAt(i) as IBSDockTab;
				if (direction == BoxDirection.HORIZONTAL)
				{
					item.percentWidth = NaN;
					item.percentHeight = 100;
				}
				else
				{
					item.percentWidth = 100;
					item.percentHeight = NaN;
				}
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			for (i = 0; i < numChildren; i++)
			{
				item = getChildAt(i) as IBSDockTab;
				if (_position == "left" || _position == "right")
					item.move(item.x, item.y + TAB_PADDING);
				else
					item.move(item.x + TAB_PADDING, item.y);
			}
		}
		
		protected function createNavItem(label:String):IBSDockTab
		{
			var tab:IBSDockTab = navItemFactory.newInstance() as IBSDockTab;
			tab.label = label;
			tab.position = _position;
			return tab;
		}
		
		protected function resetNavItems():void
		{
			invalidateDisplayList();
		}
		
		private function createNavChildren():void
		{
			var i:int = 0;
			var child:Container = null;
			removeAllChildren();
			if (_targetStack)
			{
				for (i = 0; i < _targetStack.numChildren; i++)
				{
					child = _targetStack.getChildAt(i) as Container;
					var item:IBSDockTab = createNavItem(child.label);
					item.enabled = enabled && child.enabled;
					item.selected = (_targetStack.selectedIndex == i);
					item.rebound = _rebound;
					addChild(item);
					setChildIndex(item, i);
				}
			}
			resetNavItems();
		}
		
		private function setNavChildrenEnabled():void
		{
			var i:int = 0;
			var item:IBSDockTab = null;
			for (i = 0; i < numChildren; i++)
			{
				item = getChildAt(i) as IBSDockTab;
				if (_targetStack)
					item.enabled = enabled && 
							(_targetStack.getChildAt(i) as Container).enabled;
				else
					item.enabled = enabled;
			}
		}
		
		private function setNavChildrenSelected():void
		{
			var i:int = 0;
			var item:IBSDockTab = null;
			for (i = 0; i < numChildren; i++)
			{
				item = getChildAt(i) as IBSDockTab;
				if (item.selected && i != _selectedIndex)
					item.selected = false;
				if (!item.selected && i == _selectedIndex)
					item.selected = true;
			}
		}
		
		private function setNavChildrenPosition():void
		{
			var i:int = 0;
			for (i = 0; i < numChildren; i++)
				(getChildAt(i) as IBSDockTab).position = _position;
		}
		
		private function setNavChildrenRebound():void
		{
			var i:int = 0;
			for (i = 0; i < numChildren; i++)
				(getChildAt(i) as IBSDockTab).rebound = _rebound;
		}
		
		private function addEventListenersForTargetStackChild(child:Container):void
		{
			child.addEventListener("labelChanged", labelChangedHandler);
			child.addEventListener("enabledChanged", enabledChangedHandler);
		}
		
		private function removeEventListenersForTargetStackChild(child:Container):void
		{
			child.removeEventListener("labelChanged", labelChangedHandler);
			child.removeEventListener("enabledChanged", enabledChangedHandler);
		}
		
		private function valueCommitHandler(event:FlexEvent):void
		{
			var item:IBSDockTab = event.target as IBSDockTab;
			if (item.selected)
				selectedIndex = getChildIndex(item);
			event.stopPropagation();
		}
		
		private function autoSelectHandler(event:DynamicEvent):void
		{
			var selectFlag:Boolean = (event.select ? true : false);
			var item:IBSDockTab = event.target as IBSDockTab;
			var newEvent:ItemClickEvent = new ItemClickEvent(DOCKBAR_AUTO_SELECT, 
					false, false, (selectFlag ? "select" : "unselect"), 
					getChildIndex(item), item);
			dispatchEvent(newEvent);
			event.stopPropagation();
		}
		
		private function childAddHandler(event:ChildExistenceChangedEvent):void
		{
			if (event.target == this)
				return;
			if (event.relatedObject.parent != _targetStack)
				return;
			var newChild:Container = event.relatedObject as Container;
			var item:IBSDockTab = createNavItem(newChild.label);
			item.enabled = enabled && newChild.enabled;
			item.selected = (_targetStack.selectedIndex == 
					newChild.parent.getChildIndex(newChild));
			item.rebound = _rebound;
			addChild(item);
			setChildIndex(item, newChild.parent.getChildIndex(newChild));
			addEventListenersForTargetStackChild(newChild);
			callLater(resetNavItems);
		}
		
		private function childRemoveHandler(event:ChildExistenceChangedEvent):void
		{
			if (event.target == this)
				return;
			removeEventListenersForTargetStackChild(event.relatedObject as Container);
			var viewStack:ViewStack = event.target as ViewStack;
			removeChildAt(viewStack.getChildIndex(event.relatedObject));
			callLater(resetNavItems);
		}
		
		private function childIndexChangeHandler(event:IndexChangedEvent):void
		{
			if (event.target == this)
				return;
			setChildIndex(getChildAt(event.oldIndex), event.newIndex);
			resetNavItems();
		}
		
		private function labelChangedHandler(event:Event):void
		{
			var itemIndex:int = _targetStack.getChildIndex(event.target as Container);
			(getChildAt(itemIndex) as IBSDockTab).label = 
					(event.target as Container).label;
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function enabledChangedHandler(event:Event):void
		{
			var itemIndex:int = _targetStack.getChildIndex(event.target as Container);
			(getChildAt(itemIndex) as IBSDockTab).enabled = enabled && 
					(event.target as Container).enabled;
			invalidateDisplayList();
		}
		
	}
	
}