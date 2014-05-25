class JourneysController < ApplicationController
  def index
    @journeys = Journey.all
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
