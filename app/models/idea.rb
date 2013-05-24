class Idea < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  attr_accessible :description, :title, :user_id, :event_id, :help_needed, :data_needed

  acts_as_voteable
  acts_as_commentable

  validates :title, :description, :user, :event, :presence => true

  def self.similar_by_title(title)
    search_by_title(title)
  end
end
