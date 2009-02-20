/**
 * 
 */
package org.bigbluebutton.conference.voice

import org.testng.annotations.*;

/**
 * @author Richard Alam
 *
 */
public class TestGroovy{
	@BeforeClass
	  public void setUp() {
	    // code that will be invoked when this test is instantiated
	  }

	  @Test
	  public void aFastTest() {
	    System.out.println("Fast test");
	  }

	  @Test
	  public void aSlowTest() {
	     System.out.println("Slow test");
	  }
	
}
