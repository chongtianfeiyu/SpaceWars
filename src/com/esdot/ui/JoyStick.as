package com.esdot.ui
{
	import assets.Assets;
	
	import com.gskinner.motion.GTween;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import mx.effects.easing.Back;
	
	public class JoyStick extends Sprite
	{
		protected const RAD_CONSTANT:Number = 180/Math.PI;
		
		protected var stick:Sprite;
		protected var bg:Sprite;
		
		protected var center:Point;
		protected var minPos:int, maxPos:int;
		protected var localX:int, localY:int;
		protected var touchIndex:int;
		protected var innerRadius:Number;
		
		/**
		 * Allow the innerStick to exceed the outer by this amount
		 **/
		public var outerPadding:int = 10;
		
		/**
		 * Use this to process ThumbStick events, angles are in degrees.
		 * callback(normalX, normalY, angle)
		 */
		public var positionCallback:Function;
		
		/**
		 * Disable multiTouch mode, use this to increase performance if you only
		 * need a single ThumbStick
		 **/
		public var useMultitouch:Boolean = true;
		
		/**
		 * Enable analog mode. When analog is off, ThumbStick will snap to outer edges of its bounds, 
		 * there are no "in-between" values.
		 **/
		public var useAnalog:Boolean = true;
		
		
		public function JoyStick(displayObject:MovieClip) {
			
			addChild(displayObject);
			if(!displayObject.getChildByName("stick") || !displayObject.getChildByName("bg")){
				throw(new Error("[JoyStick] Provided displayObject must have two children, named 'bg' and 'stick' respectively."));
			}
			stick = displayObject.stick;
			stick.cacheAsBitmap = true;
			
			bg = displayObject.bg;
			bg.cacheAsBitmap = true;
			
			//Determin center point
			center = new Point(bg.width>>1, bg.height>>1);
			
			//Center stick on bg
			stick.x = center.x;
			stick.y = center.y;
			
			//Calculate bounds
			innerRadius = center.x - stick.width * .5 + outerPadding;
			
			//Used to normalize x/y values
			maxPos = center.x + innerRadius;
			minPos = center.x - innerRadius;
			
			//Use multiTouch?
			if(useMultitouch && Multitouch.maxTouchPoints > 0){
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown, false, 0, true);
			} 
			//Use normal mouse events if there are no TouchPoints, or multiTouch is disabled.
			else {
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
		}
		
		protected function onMouseDown(event:Event):void {
			var pt:Point; 
			if(event is TouchEvent){
				touchIndex = (event as TouchEvent).touchPointID;
				pt = this.globalToLocal(new Point((event as TouchEvent).stageX, (event as TouchEvent).stageY));
			} else {
				pt = new Point(this.mouseX, this.mouseY);
			}
			localX = pt.x;
			localY = pt.y;
			
			updatePosition();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoved, false, 0, true);
			stage.addEventListener(TouchEvent.TOUCH_END, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		protected function onTouchMoved(event:TouchEvent):void {
			if(event.touchPointID != touchIndex){ return; }
			var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
			localX = pt.x;
			localY = pt.y;
		}
		
		protected function onEnterFrame(event:Event):void {
			if(Multitouch.maxTouchPoints == 0){
				localX = this.mouseX;
				localY = this.mouseY;
			}
			updatePosition();
		}
		
		protected function updatePosition():void {
			//Determine angle
			var angle:Number = Math.atan2(localY - center.y, localX - center.x);
			
			//Calculate max outer edges for this angle.
			var outerX:Number = center.x + innerRadius * Math.cos(angle);
			var outerY:Number = center.y + innerRadius * Math.sin(angle);
		
			//If not using analog, snap the thumbStick to the outer adges
			if(!useAnalog){
				stick.x = outerX;
				stick.y = outerY;
			} else {
				stick.x = (localX > center.x)? Math.min(localX, outerX) : Math.max(localX, outerX);
				stick.y = (localY > center.y)? Math.min(localY, outerY) : Math.max(localY, outerY);
			}	
			
			//Normalize x/y values based on positions
			var normX:Number = -1 + (stick.x - minPos) / (maxPos - minPos) * 2;
			var normY:Number = -1 + (stick.y - minPos) / (maxPos - minPos) * 2;
			
			//Use callback instea of event (performance optimization)
			if(positionCallback != null){
				positionCallback(normX, normY, angle * RAD_CONSTANT);
			}
		}
		
		protected function onMouseUp(event:Event):void {
			if(event is MouseEvent || (event as TouchEvent).touchPointID == touchIndex){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				stage.removeEventListener(TouchEvent.TOUCH_END, onMouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoved, false, 0, true);
				
				new GTween(stick, .35, {x: center.x, y: center.y}, {ease: Back.easeOut});
			}
		}
	}
}