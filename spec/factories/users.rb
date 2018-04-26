FactoryBot.define do

  sequence :email do |n|
    "user#{n}_#{rand(100000)}@test.com"
  end

  factory :user  do
    name 'Bob'
    email
    password 'the_password'
    password_confirmation 'the_password'
    #encrypted_password 'rerwqerwerqwoperq[weopriqwpoeirqweriop'
    admin  false
  end
end
