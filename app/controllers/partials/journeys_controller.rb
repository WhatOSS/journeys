class Partials::JourneysController < ApplicationController

  def index
    page = Integer(params[:page])
    @journeys = Journey.order("created_at DESC")
                        .offset((page-1)*JourneysController::PER_PAGE)
                        .limit(JourneysController::PER_PAGE)
  
    render layout: false
  end
end
