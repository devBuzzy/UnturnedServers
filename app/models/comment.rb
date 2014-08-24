class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  validates :text, presence: true
  field :text, type: String

  belongs_to :user
  belongs_to :server
end
