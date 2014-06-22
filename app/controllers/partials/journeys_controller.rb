class Partials::JourneysController < ApplicationController

  def index
    page = Integer(params[:page])
    @journeys = Journey.page(page)
  
    render layout: false
  end
end
