class Answer < ApplicationRecord
  include Votable, Attachable, Commentable
  after_create :send_answer_notifications

  belongs_to :user
  belongs_to :question
  validates :body, presence: true
  scope :ordered_answers, -> (question_id) { where(question_id: question_id).order('is_best DESC') }

  def mark_the_best
    Answer.transaction do
      self.question.answers.where(is_best: true).update_all(is_best: false)
      update!(is_best: true )
    end
  end

  def send_answer_notifications
    InformerJob.perform_later(self)
  end
end
