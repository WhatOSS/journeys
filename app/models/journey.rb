class Journey < ActiveRecord::Base
  has_many :events

  def self.find_or_create_open_journey_for_user user
    journey = Journey.find_open_journey_for_user user

    if journey.present?
      return journey
    else
      return Journey.create(user: user)
    end
  end

  def self.find_open_journey_for_user user
    Journey.where(
      user: user
    ).first
  end
end
