class JourneysController < ApplicationController
  PER_PAGE = 10

  def index
    @journeys = Journey.order("created_at DESC").limit(PER_PAGE)
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
