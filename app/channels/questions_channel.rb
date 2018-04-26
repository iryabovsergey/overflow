class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    channel_name = params[:question_id].present? ? "question_#{params[:question_id]}" : 'questions'
    stream_from channel_name
  end
end