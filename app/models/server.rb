class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  mount_uploader :banner, BannerUploader
  before_save :update_vote_count
  before_validation :assign_tags
  search_in :title, :tags => :text
  attr_accessor :tag_string

  validate :tag_count
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
  has_and_belongs_to_many :tags, autosave: true
  belongs_to :user

  def self.tag_counts
    Tag.all
  end

  def tag_text
    self.tags.distinct(:text).join(", ")
  end

  def self.valid_tags
    Tag.all.distinct(:text)
  end

  def get_flag
    return "<img src='' class='flag flag-#{self.country}' alt='#{self.country_name}' />".html_safe
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
    if self.tag_string
      self.tags = self.tag_string.gsub(" ", "").split(",").uniq.map do |name|
        next if not Tag.where(:text => name.strip).any?
        Tag.where(:text => name.strip)
      end
    end
  end

  def tag_count
    errors.add :tags, "are invalid. Use between 1 and 5 tags." unless (self.tags.size >= 1 and self.tags.size <= 5)
  end
end
