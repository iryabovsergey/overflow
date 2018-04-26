class Informer

  def self.inform_about_answer(answer)
    s_arr = answer.question.subscriptions
    s_arr.each do |s|
      DailyMailer.new_answer_notification(s.user, answer)
    end
  end
end