class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ip

  belongs_to :server
end
