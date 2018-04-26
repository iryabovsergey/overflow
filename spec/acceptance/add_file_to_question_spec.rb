require_relative 'acceptance_helper'

feature 'Add fiels to question', %q{
The author of the question should have an ability
to attach/remove files to his question} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment1) { create(:attachment, attachmentable_id: question.id, attachmentable_type: "Question") }
  given!(:attachment2) { create(:attachment_2, attachmentable_id: question.id, attachmentable_type: "Question") }

  background do
    sign_in(user)
  end

  scenario 'User can attach files and see them after question is submitted', js: true do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'body - test test test'

    file_path1 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/chess.jpg" : "#{Rails.root}/spec/temp/chess.jpg".gsub('/', '\\')
    file_path2 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/staunton.jpg" : "#{Rails.root}/spec/temp/staunton.jpg".gsub('/', '\\')

    attach_file 'File', file_path1
    click_on 'Add attachment'
    within all('.fields')[1] do
      attach_file('File', file_path2)
    end
    click_on 'Submit'

    expect(page).to have_link('chess.jpg')
    expect(page).to have_link('staunton.jpg')
  end


  scenario 'User can remove attached files', js: true do
    visit questions_path
    click_on 'Edit'
    sleep 0.5

    within "#question_#{question.id}_attachments" do
      all("input[type='checkbox']")[0].click
      all("input[type='checkbox']")[1].click
    end
    sleep 0.5
    click_on 'Submit'

    expect(page).to_not have_content('chess.jpg')
    expect(page).to_not have_content('staunton.jpg')
  end

  scenario 'User can add file(s) when question is being edited', js: true do
    visit questions_path

    file_path1 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/chess_set.jpg" : "#{Rails.root}/spec/temp/chess_set.jpg".gsub('/', '\\')
    file_path2 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/bishops.jpg" : "#{Rails.root}/spec/temp/bishops.jpg".gsub('/', '\\')

    click_on 'Edit'
    sleep 0.5
    attach_file 'File', file_path1
    click_on 'Add attachment'
    sleep 0.5
    within all("#attachments_question_#{question.id}")[1] do
      attach_file('File', file_path2)
    end

    click_on 'Submit'
    expect(page).to have_content('chess_set.jpg')
    expect(page).to have_content('bishops.jpg')
  end
end





