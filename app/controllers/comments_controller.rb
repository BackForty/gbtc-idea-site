class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_event

  def find_event
    @event = Event.find(params[:event_id])
  end

  def create
    @idea = @event.ideas.find(params[:idea_id])
    @comment = @idea.comments.create(params[:comment]) do |c|
      c.user = current_user
      c.commentable_type = @idea.class.to_s
      c.commentable_id = @idea.id
    end

    if @comment.errors.blank?
      flash.notice = 'Comment posted!'
    else
      flash.alert = 'Your comment could not be posted.'
    end
    redirect_to event_idea_url(@event, @idea)
  end
end
