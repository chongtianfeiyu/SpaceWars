package
{
	import com.esdot.view.MainView;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	[SWF(width="1024", height="600", backgroundColor="0x0")]
	public class SpaceWars extends Sprite
	{
		
		protected var mainView:MainView;
		
		public function SpaceWars() {
			
			mainView = new MainView();
			addChild(mainView);	
		}
	}
}