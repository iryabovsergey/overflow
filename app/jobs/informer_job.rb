class InformerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Informer.inform_about_answer(answer)
  end
end
