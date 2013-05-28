class IdeasController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :search, :show, :vote]
  before_filter :verify_ownership, only: [:update, :destroy, :edit]

  expose(:event, finder: :find_by_slug)
  expose(:ideas) {params[:query].nil? ? event.ideas : event.ideas.search(params[:query])}
  expose(:idea)
  expose(:comment) {idea.comments.new}

  def search
    render :index
  end

  def similar
    ideas = event.ideas.similar_by_title(params[:title])
    respond_to do |format|
      format.json { render :json => ideas }
    end
  end

  def create
    idea.user = current_user
    if idea.save
      redirect_to event_idea_url(event, idea)
    else
      render :new
    end
  end

  def update
    if idea.update_attributes(params[:idea])
      flash.notice = 'Idea Updated'
    else
      flash.alert = "Couldn't Update the Idea"
    end
    redirect_to event_idea_url(idea.event, idea)
  end

  def destroy
    if idea.destroy
      flash.notice = 'Idea Deleted'
    else
      flash.alert = 'Idea Could not be Deleted'
    end
    redirect_to event_ideas_url(event)
  end

  def vote
    Ballot.cast (current_user || SessionUser.new(session)), idea, params[:vote]
    if request.env['HTTP_REFERER']
      redirect_to :back
    else
      redirect_to event_ideas_url(event)
    end
  end

  def verify_ownership
    return true unless idea.nil? || idea.user != current_user
    
    flash.alert = 'You do not have permission to update this idea'
    redirect_to event_ideas_url(event)
  end
end
