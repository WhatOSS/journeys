class EventsController < ApplicationController
  def create
    user = User.find_or_create_by(ip: request.remote_ip)
    journey = Journey.find_or_create_open_journey_for_user(
      user
    )
    Event.create(slug: params[:slug], journey: journey)

    render json: {message: "OK"}
  end
end
