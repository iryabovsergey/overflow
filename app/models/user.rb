class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates :name, :email, presence: true
  has_many :answers
  has_many :questions
  has_many :votes, as: :votable
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions

  def author_of?(obj)
    obj.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization
    info = auth[:info]
    email = info[:email] if info
    user = User.where(email: email).first if email.presence
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      email = "#{Devise.friendly_token[0, 20]}@temporary_generated_email.xyz" unless email.presence
      name = info[:name].present? ? info[:name] : "#{auth.provider} user"
      user = User.create!(name: name, email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth[:provider], uid: auth[:uid])
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
