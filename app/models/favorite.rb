class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :server
  belongs_to :user
end
