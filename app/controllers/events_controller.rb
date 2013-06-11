class EventsController < ApplicationController
  expose(:events) {params[:past].nil? ? Event.future.ascending_date : Event.past.ascending_date}

  def index
  end
end
