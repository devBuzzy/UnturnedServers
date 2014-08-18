class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :banner, BannerUploader

  validate :check_dimensions, :on => :create

  def check_dimensions
    if !banner_cache.nil? && !(banner.width == 468 && banner.height == 60)
      errors.add :banner, "dimensions should be 468x60"
    end
  end

  validates :title, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :port, presence: true
  validates_numericality_of :port
  validates :pvp, presence: true
  validates :info, presence: true
  validates :location, presence: true
  validates :version, presence: true
  validates :difficulty, presence: true
  validates :sync, presence: true
  validates :map, presence: true
  validates :slots, presence: true
  validates_numericality_of :slots
  validates :banner, presence: true

  field :title, type: String, default: ""
  field :ip, type: String, default: ""
  field :port, type: Integer, default: 25544
  field :pvp, type: Boolean, default: true
  field :info, type: String, default: ""
  field :location, type: String, default: ""
  field :version, type: String, default: ""
  field :difficulty, type: String, default: ""
  field :sync, type: Boolean, default: true
  field :map, type: String, default: ""
  field :slots, type: Integer, default: 8

  field :steam, type: String
  field :reddit, type: String
  field :twitter, type: String
  field :facebook, type: String
  field :youtube, type: String
  field :website, type: String

  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :user

end
