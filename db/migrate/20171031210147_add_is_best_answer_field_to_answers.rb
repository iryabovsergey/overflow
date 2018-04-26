class AddIsBestAnswerFieldToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :is_best, :boolean, default: false
  end
end
