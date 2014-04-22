class EventsController < ApplicationController
  def create
    journey = Journey.create(
      user: params[:user]
    )
    Event.create(slug: params[:slug], journey: journey)

    render json: {message: "OK"}
  end
end
