FactoryBot.define do
  factory :comment do
    user
    body 'the_comment'
  end

  factory :invalid_comment, class: 'Comment' do
    user
    body nil
  end

end
