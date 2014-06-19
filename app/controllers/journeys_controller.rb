class JourneysController < ApplicationController
  def index
    @journeys = Journey.all.limit(10)
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
