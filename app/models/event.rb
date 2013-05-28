class Event < ActiveRecord::Base
  attr_accessible :title, :description, :date
  has_many :ideas, dependent: :destroy

  validates :title, :description, :date, :slug, presence: true
  validates :slug, uniqueness: true

  def self.future
    where(['date >= ?', Date.today])
  end

  def self.ascending_date
    order('date ASC')
  end

  def to_param
    slug
  end

  def title=(some_title)
    super(some_title)
    self.slug = some_title.to_slug.normalize.to_s
  end
end
