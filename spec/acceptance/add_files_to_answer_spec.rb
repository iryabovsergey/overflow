require_relative 'acceptance_helper'

feature 'Add/Remove files to answer', %q{
  The author of the answer should be able to add files to the answer, and remove them
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment1) { create(:attachment, attachmentable_id: answer.id, attachmentable_type: "Answer") }
  given!(:attachment2) { create(:attachment_2, attachmentable_id: answer.id, attachmentable_type: "Answer") }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can attach files during answer creation and see them after submittion', js: true do
    visit question_path(question)

    file_path1 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/chess.jpg" : "#{Rails.root}/spec/temp/chess.jpg".gsub('/', '\\')
    file_path2 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/staunton.jpg" : "#{Rails.root}/spec/temp/staunton.jpg".gsub('/', '\\')

    fill_in 'Body', with: 'My answer'
    click_on 'Add attachment'
    attach_file 'File', file_path1
    click_on 'Add attachment'
    within all('.fields')[1] do
      attach_file('File', file_path2)
    end

    click_on 'Submit'
    expect(page).to have_link('chess.jpg')
    expect(page).to have_link('staunton.jpg')
  end

  scenario 'User can remove attached files from existing answer', js: true do
    visit question_path(question)
    click_on 'Edit'
    sleep 0.5
    within '.answer_attachments' do
      all("input[type='checkbox']")[0].click
      all("input[type='checkbox']")[1].click
    end
    sleep 0.5
    within "#div_answer_#{answer.id}" do
      click_on 'Submit'
    end


    expect(page).to_not have_content('chess.jpg')
    expect(page).to_not have_content('staunton.jpg')
  end

  scenario 'User can add file(s) to his existing answer', js: true do
    visit question_path(question)
    file_path1 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/chess_set.jpg" : "#{Rails.root}/spec/temp/chess_set.jpg".gsub('/', '\\')
    file_path2 = (RUBY_PLATFORM != 'i386-mingw32') ? "#{Rails.root}/spec/temp/bishops.jpg" : "#{Rails.root}/spec/temp/bishops.jpg".gsub('/', '\\')

    click_on 'Edit'
    sleep 0.5
    within "#div_answer_#{answer.id}" do
      attach_file 'File', file_path1
      click_on 'Add attachment'
      within "#additional_attachment_answer_#{answer.id}" do
        attach_file('File', file_path2)
      end
    end

    within "#div_answer_#{answer.id}" do
      click_on 'Submit'
    end
    expect(page).to have_content('chess_set.jpg')
    expect(page).to have_content('bishops.jpg')
  end

end

