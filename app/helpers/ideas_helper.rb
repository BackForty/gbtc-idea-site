module IdeasHelper
  def edit_idea_link(idea)
    if current_user && idea.user.id == current_user.id && idea.created_at > (Time.now - 15.minutes)
      raw("<div class='edit'>#{ link_to('Edit Idea', edit_event_idea_path(idea.event, idea))}</div>")
    end
  end
end
