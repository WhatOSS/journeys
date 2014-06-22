class Partials::JourneysController < ApplicationController
  PER_PAGE = 10
  def index
    page = Integer(params[:page])
    @journeys = Journey.order("created_at DESC")
                        .offset((page-1)*PER_PAGE)
                        .limit(PER_PAGE)
  
    render layout: false
  end
end
