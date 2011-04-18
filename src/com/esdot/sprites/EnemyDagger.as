package com.esdot.sprites
{
	import assets.Assets;
	
	import com.gskinner.motion.GTween;
	
	import flash.display.Sprite;
	
	public class EnemyDagger extends Sprite
	{
		protected var sprite:Sprite = new Assets.EnemyDaggerAssets();
		
		protected var target:Sprite;
		protected var angle:Number;
		protected var targetComplete:Boolean = false;
		
		public function EnemyDagger(target:Sprite){
			addChild(sprite);
			this.target = target;
		}
		
		public function init():void {
			sprite.rotation = Math.random() * 360;
			angle = Math.atan2(this.x - this.target.x, this.y - this.target.y) * -180/Math.PI;
			new GTween(sprite, 1, {rotation: angle}, {onComplete: onTargetComplete});
		}
		
		public function updatePosition():void {
			if(!targetComplete){ return; }
			this.x += (target.x - this.x) * .08;
			this.y += (target.y - this.y) * .08;
		}
		
		protected function onTargetComplete(tween:GTween):void {
			targetComplete = true;
		}
		
		
	}
}