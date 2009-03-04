
package org.bigbluebutton.conference.service.archive.playback

import java.util.concurrent.DelayQueueimport java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Delayed
public class PlaybackJobScheduler {
	private DelayQueue<RecordedEvent> queue =  new DelayQueue<RecordedEvent>()
	private final static int NTHREADS = 5
	private final ExecutorService executor = Executors.newFixedThreadPool(NTHREADS)
	
	public void start() {
		def playbackThread = new Thread() {
			while (true) {
				try {
					play(queue.take());
	            } catch (InterruptedException e) {}
			}
		}
	    playbackThread.start()
	}

	public void play(Delayed event) {
		def runn = new Thread() {
			
		}
		executor.exec(runn)
	}
}
