package assets
{
	
	public class Assets
	{
		
		[Embed(source="/assets/assets.swf", symbol="ScoreBoardAssets")]
		public static var ScoreBoardAssets:Class;
		
		[Embed(source="/assets/assets.swf", symbol="ShipAssets")]
		public static var ShipAssets:Class;
		
		[Embed(source="/assets/assets.swf", symbol="ThumbStickAssets")]
		public static var ThumbStickAssets:Class;
		
		[Embed(source="/assets/assets.swf", symbol="BlastSimpleAssets")]
		public static var BlastSimpleAssets:Class;
		
	}
}