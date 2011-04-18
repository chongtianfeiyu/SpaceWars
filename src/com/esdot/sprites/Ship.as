package com.esdot.sprites
{
	import assets.Assets;
	
	import flash.display.Sprite;
	
	public class Ship extends Sprite
	{
		public var viewAssets:Sprite = new Assets.ShipAssets();
		
		public function Ship() {
			addChild(viewAssets);
		}
	}
}