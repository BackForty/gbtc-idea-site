class EventsController < ApplicationController
  def index
    @events = Event.future.ascending_date
  end
end
