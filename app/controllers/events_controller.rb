class EventsController < ApplicationController
  def create
    journey = Journey.find_or_create_open_journey_for_user(
      params[:user]
    )
    Event.create(slug: params[:slug], journey: journey)

    render json: {message: "OK"}
  end
end
