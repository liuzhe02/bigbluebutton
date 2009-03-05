
package org.bigbluebutton.conference.service.archive.playback

import java.util.concurrent.DelayQueueimport java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Delayedimport org.bigbluebutton.conference.service.archive.playback.RecordedEvent
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
			RecordedEvent r = (RecordedEvent) event
			r.playMessage()
			if (r.scheduleNextEvent()) {
				queue.add(r)
			}
		}
		executor.exec(runn)
	}
	
	public void schedulePlayback(PlaybackSession session) {
		session.startPlayback();
		RecordedEvent event = new RecordedEvent(session)
		queue.add(event)
	}
}
