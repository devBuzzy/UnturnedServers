class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  field :reason, type: String
  belongs_to :server
  belongs_to :user
end
