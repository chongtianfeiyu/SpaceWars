package com.esdot.view
{
	import assets.Assets;
	
	import com.esdot.sprites.EnemyDagger;
	import com.esdot.sprites.Ship;
	import com.esdot.ui.JoyStick;
	import com.gskinner.motion.GTween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainView extends Sprite
	{
		protected var scoreBoard:ScoreBoard;
		protected var ship:Ship;
		
		protected var leftStick:JoyStick;
		protected var rightStick:JoyStick;
		
		protected var projectiles:Array = [];
		
		public function MainView() {
			
			scoreBoard = new ScoreBoard();
			addChild(scoreBoard);
			
			ship = new Ship();
			addChild(ship);
			
			leftStick = new JoyStick(new Assets.ThumbStickAssets());
			leftStick.positionCallback = leftStickCallback;
			addChild(leftStick);
			
			rightStick = new JoyStick(new Assets.ThumbStickAssets());
			rightStick.positionCallback = rightStickCallback;
			rightStick.useAnalog = false;
			addChild(rightStick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.ENTER_FRAME, tickGame, false, 0, true);
		}
		
		protected function leftStickCallback(normX:Number, normY:Number, angle:Number):void {
			ship.x += normX * 7;
			ship.x = Math.max(25, Math.min(stage.stageWidth - 25, ship.x));
				
			ship.y += normY * 7;
			ship.y = Math.max(scoreBoard.height + 25, Math.min(stage.stageHeight - 25, ship.y));
			
			ship.rotation = angle;
		}
		
		protected function rightStickCallback(normX:Number, normY:Number, angle:Number):void {
			var blast:Sprite = getBlastFromPool();
			blast.rotation = angle;
			blast.x = ship.x;
			blast.y = ship.y;
			addChildAt(blast, 0);
			projectiles.push({child: blast, velX: normX, velY: normY});
		}
		
		protected var blastPool:Array = [];
		protected function getBlastFromPool():Sprite {
			if(blastPool.length){
				return blastPool.pop();
			}
			else {
				return new Assets.BlastSimpleAssets();
			}
		}
		
		protected var badList:Array = [];
		protected var currentSeed:Number = .5;
		protected function tickGame(event:Event):void {
			var vo:Object;
			//Move projectiles and calculate hits
			for(var i:int = projectiles.length - 1; i >= 0; i--){
				vo = projectiles[i];
				vo.child.x += vo.velX*14;
				vo.child.y += vo.velY*14;
				
				for(var j:int = badList.length - 1; j >= 0; j--){
					if(badList[j].hitTestPoint(vo.child.x, vo.child.y, true)){
						//Hit!
						removeChild(badList[j]);
						badList.splice(j, 1);
					}
				}
				
				if(vo.child.x < 0 || vo.child.x > stage.stageWidth || vo.child.y < 0 || vo.child.y > stage.stageHeight){
					projectiles.splice(i, 1);
					blastPool.push(removeChild(vo.child));
				}
			}
			
			for(i = badList.length - 1; i >= 0; i--){
				badList[i].updatePosition();
			}
			
			//Spawn baddies
			if(Math.random() < currentSeed){
				
				var dagger:EnemyDagger = new EnemyDagger(ship);
				dagger.x = stage.stageWidth * Math.random();
				dagger.y = stage.stageWidth * Math.random();
				dagger.init();
				addChild(dagger);
				badList.push(dagger);
			}
		}
		
		protected function onAddedToStage(event:Event):void {
			init();
		}
		
		public function init():void {
			if(!stage){ return; }
			
			ship.x = stage.stageWidth/2;
			ship.y = stage.stageHeight/2;
			
			leftStick.x = 25;
			leftStick.y = stage.stageHeight - leftStick.height - 25;
			
			rightStick.x = stage.stageWidth - rightStick.width - 25;
			rightStick.y = stage.stageHeight - rightStick.height - 25;
		}
	}
}