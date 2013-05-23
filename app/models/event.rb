class Event < ActiveRecord::Base
  attr_accessible :title, :description, :date
  has_many :ideas, dependent: :destroy
end
