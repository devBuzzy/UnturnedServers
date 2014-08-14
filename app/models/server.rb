class Server
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :title, presence: true
  validates :ip, presence: true
  validates :port, presence: true
  validates_numericality_of :port
  validates :pvp, presence: true
  validates :info, presence: true
  validates :gold, presence: true
  validates :location, presence: true
  validates :version, presence: true
  validates :difficulty, presence: true
  validates :sync, presence: true
  validates :map, presence: true

  field :title, type: String
  field :ip, type: String
  field :port, type: Integer
  field :pvp, type: Boolean
  field :info, type: String
  field :gold, type: Boolean
  field :location, type: String
  field :version, type: String
  field :difficulty, type: String
  field :sync, type: Boolean
  field :map, type: String

  has_many :reports
  belongs_to :user

end
