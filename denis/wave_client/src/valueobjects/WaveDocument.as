package valueobjects
{
	public class WaveDocument
	{
		public var content:String;
		public var index:Number;
		
		public function WaveDocument(index:Number, content:String)
		{
			this.content = content;
			this.index = index;
		}

	}
}