class Journey < ActiveRecord::Base
  has_many :events
  belongs_to :user

  validates_presence_of :user

  default_scope { order('created_at DESC') }

  PER_PAGE = 10

  def self.page page = 1
    offset = (page-1)*PER_PAGE

    self.offset(offset)
      .limit(PER_PAGE)
  end

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
      limit(1).last
  end

  def first_event
    events.order("created_at ASC").limit(1).first
  end
end
