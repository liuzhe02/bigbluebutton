
package org.bigbluebutton.conference.service.archive.playback

import java.util.concurrent.DelayQueueimport java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Delayedimport org.bigbluebutton.conference.service.archive.playback.RecordedEvent
/**
 * This class handles the playing back of all playback sessions.
 */
public class PlaybackJobScheduler {
	
	private DelayQueue<RecordedEvent> queue =  new DelayQueue<RecordedEvent>()
	private final static int NTHREADS = 5
	private final ExecutorService executor = Executors.newFixedThreadPool(NTHREADS)
	
	/**
	 * Start the scheduler.
	 */
	public void start() {
		/**
		 * This thread just monitors the queue, gets an entry and pass it
		 * to one of the worker threads managed by the executor.
		 */
		def playbackThread = new Thread() {
			while (true) {
				try {
					play(queue.take());
	            } catch (InterruptedException e) {}
			}
		}
	    playbackThread.start()
	}

	private void play(Delayed event) {
		// Setup a Runnable and let the executor run it.
		def runn = {
			RecordedEvent r = (RecordedEvent) event
			r.playMessage()
			// Check if there is still a message to be played.
			// If so, schedule by putting into the queue.
			// If none, the session gets removed from the schedule.
			if (r.scheduleNextEvent()) {
				queue.add(r)
			}
		}
		executor.exec(runn)
	}
	
	/**
	 * This is the main entry for playback sessions to be scheduled.
	 */
	public void schedulePlayback(PlaybackSession session) {		 
		 // Wrap the session suitable for putting into the queue.
		 // RecordEvent implements Delay interface.
		RecordedEvent event = new RecordedEvent(session)
		 // Add it into the queue.
		queue.add(event)
	}
}
