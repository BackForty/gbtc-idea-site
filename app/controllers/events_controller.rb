class EventsController < ApplicationController
  expose(:events) {Event.future.ascending_date}

  def index
  end
end
