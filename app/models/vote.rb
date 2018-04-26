class Vote < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type], message: "You have already voted. You can't vote twice" }
  validate :validate_author

  private

  def validate_author
    if votable.user_id == user_id
      errors[:base] << "You can't vote for your own record"
    end
  end
end
