FactoryBot.define do
  factory :answer do
    user
    question
    body 'The body of the answer'
  end

  factory :invalid_answer, class: 'Answer' do
    user
    question
    body nil
  end
end
