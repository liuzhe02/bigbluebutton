package managers
{
	import mx.collections.ArrayCollection;
	
	import valueobjects.WaveDocument;
	
	public class WaveManager
	{
		[Bindable] public var wavelets:ArrayCollection;
		
		public function WaveManager()
		{
			wavelets = new ArrayCollection();
		}
		
		public function parseWaveletData(data:Object):void{
			var waveletsArray:Array = data as Array;
			
			for (var i:Number = 0; i<waveletsArray.length; i++){
				wavelets.addItem(new WaveDocument(i, waveletsArray[i]));
			}
		}

	}
}