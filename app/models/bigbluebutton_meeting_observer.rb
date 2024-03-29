# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class BigbluebuttonMeetingObserver < ActiveRecord::Observer
  observe :bigbluebutton_meeting

  def after_create(meeting)
    meeting.create_activity :create, :owner => meeting.room unless meeting.errors.any?
  end
end
