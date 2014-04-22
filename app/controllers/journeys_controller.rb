class JourneysController < ApplicationController
  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
