/*
 * BigBlueButton - http://www.bigbluebutton.org
 * 
 * Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.
 * 
 * BigBlueButton is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Affero General Public License as published by the Free Software 
 * Foundation; either version 3 of the License, or (at your option) any later 
 * version. 
 * 
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License along 
 * with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Richard Alam <ritzalam@gmail.com>
 *
 * $Id: $x
 */
package org.bigbluebutton.deskshare.server.events;

import java.awt.Point;

public class CaptureUpdateBlockEvent {
	private final String room;
	private final int position;
	private final byte[] videoData;
	private final boolean isKeyFrame;

	public CaptureUpdateBlockEvent(String room, int position, byte[] videoData, boolean isKeyFrame) {
		this.room = room;
		this.position = position;
		this.videoData = videoData;
		this.isKeyFrame = isKeyFrame;
	}
		
	public String getRoom() {
		return room;
	}

	public int getPosition() {
		return position;
	}

	public byte[] getVideoData() {
		return videoData;
	}

	public boolean isKeyFrame() {
		return isKeyFrame;
	}
}
