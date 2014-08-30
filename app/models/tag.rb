class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  before_save :update_count
  validates_uniqueness_of :text

  def update_count
    self.count = self.servers.size
  end

  field :label_color, type: String, default: "primary"
  field :text, type: String
  field :count, type: Integer

  has_and_belongs_to_many :servers
end
