class CommentsController < ApplicationController
  before_filter :authenticate_user!

  expose(:event, finder: :find_by_slug)
  expose(:idea)
  expose(:comment)

  def create
    comment.user = current_user
    comment.commentable_type = idea.class.to_s
    comment.commentable_id = idea.id

    if comment.save
      flash.notice = 'Comment posted!'
    else
      flash.alert = 'Your comment could not be posted.'
    end
    redirect_to event_idea_url(event, idea)
  end
end
