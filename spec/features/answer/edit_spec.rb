require 'rails_helper'

feature 'user can edit his answer' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:other_answer) { create(:answer, user: other_user, question: other_question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can edit his answer' do
      within '.answers' do
        click_on "Edit"
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do
        click_on "Edit"
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'Other user can not edit answer' do
      visit question_path(other_question)
      within '.answers' do
        expect(page).to_not have_link "Edit"
      end
    end

    context 'attachments' do
      background do
        within '.answers' do
          click_on "Edit"
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end
      
      scenario 'add attachments' do
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end
end
