FactoryBot.define do
  factory :question do
    user
    title 'A title of the question'
    body 'A body of the question'
  end

  factory :invalid_question, class: 'Question' do
    user
    title nil
    body nil
  end
end