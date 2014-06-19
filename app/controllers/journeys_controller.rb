class JourneysController < ApplicationController
  def index
    @journeys = Journey.order("created_at DESC").limit(10)
  end

  def show
    @journey = Journey.find(params[:id])
    @events = @journey.events
  end
end
