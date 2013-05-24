class IdeasController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :search, :show, :vote]
  before_filter :find_event

  def find_event
    @event = Event.find(params[:event_id])
  end

  def index
    @ideas = @event.ideas.all.sort_by(&:plusminus).reverse
  end

  def search
    @ideas = @event.ideas.search(params[:query])
    render :index
  end

  def similar
    @ideas = @event.ideas.similar_by_title(params[:title])

    respond_to do |format|
      format.json { render :json => @ideas }
    end
  end

  def show
    @idea = @event.ideas.find(params[:id])
    @comment = @idea.comments.build
  end

  def new
    @idea = @event.ideas.build do |i|
      i.user_id = current_user.id
    end
  end

  def create
    @idea = @event.ideas.create(params[:idea])
    unless @idea.errors.empty?
      render :new
    else
      redirect_to event_idea_url(@event, @idea)
    end
  end

  def edit
    @idea = @event.ideas.find(params[:id])
  end

  def update
    idea = @event.ideas.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    if idea && idea.update_attributes(params[:idea])
      flash.notice = "Idea Updated"
    else
      flash.alert = "Couldn't Update the Idea"
    end
    redirect_to event_idea_url(idea.event, idea) and return if idea
    redirect_to event_ideas_url(@event)
  end

  def destroy
    idea = @event.ideas.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    if idea && idea.destroy
      flash.notice = "Idea Deleted"
    else
      flash.alert = "Idea Could not be Deleted"
    end
    redirect_to event_ideas_url(@event)
  end

  def vote
    Ballot.cast (current_user || SessionUser.new(session)), @event.ideas.find(params[:id]), params[:vote]
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to event_ideas_url(@event)
    end
  end
end
