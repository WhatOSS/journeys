class JourneysController < ApplicationController

  def index
    @journeys = Journey.page
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
