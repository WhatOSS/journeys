class JourneysController < ApplicationController
  PER_PAGE = 10

  def index
    @journeys = Journey.limit(PER_PAGE)
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
