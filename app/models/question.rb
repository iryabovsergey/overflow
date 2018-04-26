class Question < ApplicationRecord
  include Votable, Attachable, Commentable
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  validates :title, :body, presence: true

  after_create :after_create

  private

  def after_create
    self.subscriptions.create(user: self.user)
  end

end
