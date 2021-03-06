require 'carrierwave/mongoid'
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, 
  :recoverable, :rememberable, :trackable, :validatable, :registerable

  attr_accessor :login

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]*\z/, message: "may only contain letters and numbers." }

  field :email, type: String, default: ""
  field :username, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :admin, type: Boolean, default: false

  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  field :remember_created_at, type: Time

  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :youtube
  field :steam
  field :twitter
  field :facebook
  field :skype
  field :reddit
  field :github
  field :twitch

  field :about

  field :location
  field :gender

  field :newsletter, type: Boolean

  has_many :servers, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :articles

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      self.any_of({ :username =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
    else
      super
    end
  end

  def has_favored(server)
    self.favorites.each do |favorite|
      if favorite.server.id == server.id
        return true
      end
    end
    return false
  end

  def favorite_for(server)
    self.favorites.each do |favorite|
      if favorite.server.id == server.id
        return favorite
      end
    end
    return nil
  end
end
