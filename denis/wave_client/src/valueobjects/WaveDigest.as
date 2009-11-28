package valueobjects
{
	/**
	 * Represents a Digest for a wave, along with the wave index number
	 * @author Snap
	 * 
	 */	
	public class WaveDigest
	{
		[Bindable] public var digest:String;
		[Bindable] public var index:Number;
		
		public function WaveDigest(index:Number, digest:String)
		{
			this.digest = digest;
			this.index = index;
		}

	}
}