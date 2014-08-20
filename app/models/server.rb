class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :banner, BannerUploader
  before_save :update_vote_count
  before_validation :convert_tags
  validate :check_dimensions, :on => :create

  attr_accessor :tag_string

  def convert_tags
    self.tags = self.tag_string.split(', ')
  end

  def tag_list
    self.tag_string = self.tags.join(", ")
  end

  def check_dimensions
    if !banner_cache.nil? && !(banner.width == 468 && banner.height == 60)
      errors.add :banner, "dimensions must be 468x60"
    end
  end

  def update_vote_count
    self.vote_count = self.votes.size
  end

  def tag_count
    if tags.size == 0 or tags.size > 5
        errors.add :tags, "must consist of one to five tags"
    end
    puts tags.size, "TEHREEE"
  end

  def tag_names
    tag_models = Tag.only(:text).all.to_a
    valid_tags = Array.new
    tag_models.each do |tag|
      valid_tags << tag.text
    end
    unknown = 0
    puts "CURRENT", tags, "VALID", valid_tags
    tags.each do |tag|
      if not valid_tags.include?(tag)
        unknown += 1
      end
    end
    if unknown > 0
      errors.add :tags, "found one or more unknown tags."
    end
  end

  validates :title, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :port, presence: true
  validates_numericality_of :port
  validates :info, presence: true
  validates :location, presence: true
  validates :version, presence: true
  validates :slots, presence: true
  validates_numericality_of :slots
  validates :banner, presence: true
  validate :tag_count
  validate :tag_names

  field :title, type: String, default: ""
  field :ip, type: String, default: ""
  field :port, type: Integer, default: 25544
  field :info, type: String, default: ""
  field :location, type: String, default: ""
  field :version, type: String, default: ""
  field :slots, type: Integer, default: 8

  field :steam, type: String
  field :reddit, type: String
  field :twitter, type: String
  field :facebook, type: String
  field :youtube, type: String
  field :website, type: String

  field :tags, type: Array, default: []

  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  field :vote_count, type: Integer, default: 0
  has_many :favorites, dependent: :destroy
  belongs_to :user

end
