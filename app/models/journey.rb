class Journey < ActiveRecord::Base
  has_many :events
  belongs_to :user

  validates_presence_of :user

  def self.find_or_create_open_journey_for_user user
    journey = Journey.find_open_journey_for_user user

    if journey.present?
      return journey
    else
      return Journey.create(user: user)
    end
  end

  def self.find_open_journey_for_user user
    self.joins(:events).
      where(user: user).
      where("events.created_at > ?", 15.minutes.ago).
      order("created_at DESC").
      limit(1).last
  end

  def first_event
    events.order("created_at ASC").limit(1).first
  end
end
