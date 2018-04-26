include ActionDispatch::TestProcess
FactoryBot.define do
  factory :attachment do
    file  { fixture_file_upload("#{Rails.root}/spec/temp/staunton.jpg") }
  end

  factory :attachment_2, class: 'Attachment' do
    file  { fixture_file_upload("#{Rails.root}/spec/temp/chess.jpg") }
  end
end
