class Event < ActiveRecord::Base
  belongs_to :journey

  def self.last_for_user_inside_journey_window user
    Event.where(user: user)
      .where("created_at > ?", 15.minutes.ago)
      .order("created_at DESC")
      .limit(1).last
  end
end
