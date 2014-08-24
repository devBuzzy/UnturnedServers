class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  validates :text, presence: true
  validates :title, presence: true
  field :text
  field :title

  belongs_to :user
end
