class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :banner, BannerUploader
  before_save :update_vote_count
  before_save :assign_tags

  attr_accessor :tag_string

  validate :check_dimensions, :on => :create
  validates :title, presence: true
  validates :ip, presence: true, uniqueness: true
  validates :port, presence: true
  validates_numericality_of :port
  validates :info, presence: true
  validates :country, presence: true
  validates :version, presence: true
  validates :slots, presence: true
  validates_numericality_of :slots
  validates :banner, presence: true

  field :title, type: String, default: ""
  field :ip, type: String, default: ""
  field :port, type: Integer, default: 25544
  field :info, type: String, default: ""
  field :country, type: String, default: ""
  field :version, type: String, default: ""
  field :slots, type: Integer, default: 8

  field :steam, type: String
  field :reddit, type: String
  field :twitter, type: String
  field :facebook, type: String
  field :youtube, type: String
  field :website, type: String
  field :vote_count, type: Integer, default: 0

  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_and_belongs_to_many :tags
  belongs_to :user

  def get_flag
    return "<img src='blank.gif' class='flag flag-#{self.country}' alt='#{self.country_name}' />".html_safe
  end

  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end


  def check_dimensions
    if !banner_cache.nil? && !(banner.width == 468 && banner.height == 60)
      errors.add :banner, "dimensions must be 468x60"
    end
  end

  def update_vote_count
    self.vote_count = self.votes.size
  end

  def assign_tags
    puts "HEREEEEEEEEEEEEEEE", self.tag_string
    if self.tag_string
      self.tags = self.tag_string.gsub(/s+/,"").split(/,/).uniq.map do |name|
        Tag.where(:text => name.strip)
      end
    end
  end
end
