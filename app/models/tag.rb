class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label_color, type: String, default: "primary"
  field :text, type: String

end
