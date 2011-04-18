package com.esdot.view
{
	import assets.Assets;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class ScoreBoard extends Sprite
	{
		protected var viewAssets:MovieClip = new Assets.ScoreBoardAssets();
		
		public function ScoreBoard(){
			addChild(viewAssets);
		}
	}
}