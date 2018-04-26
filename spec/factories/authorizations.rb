FactoryBot.define do
  factory :authorization do
    user nil
    provider "twitter"
    uid "123456789"
  end
end
