package managers
{
	import mx.collections.ArrayCollection;
	
	import valueobjects.WaveDigest;
	
	public class InboxManager
	{
		[Bindable] public var waves:ArrayCollection;
		
		public function InboxManager()
		{
			waves = new ArrayCollection();
		}
		
		public function parseWaveData(data:Object):void{
			var wavesArray:Array = data as Array;
			
			for (var i:Number = 0; i<wavesArray.length; i++){
				waves.addItem(new WaveDigest(i, wavesArray[i]));
			}
		}

	}
}