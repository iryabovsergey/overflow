class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :user_id, uniqueness: {scope: [:user_id, :question_id], message: "You have already subscribed to the question"}
end
