class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"
    mail to: user.email
    @question_titles = Question.where("created_at > ?", 24.hours.ago).pluck(:title)
  end

  def new_answer_notification(user, answer)
    @greeting = "Hi, new answer created: #{answer.title}"
    mail to: user.email
  end
end