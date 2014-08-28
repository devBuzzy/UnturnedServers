class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label_color, type: String, default: "primary"
  field :text, type: String

  has_and_belongs_to_many :servers
end
