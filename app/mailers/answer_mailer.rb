class AnswerMailer < ApplicationMailer
  def self.send_notifications(answer)
    pp '------ begin of sending notifications'
    sleep(5)
    pp "Answer body #{answer.body}"
    pp '------ end of sending notifications  '
  end
end