require 'rails_helper'

feature 'User can select the best answer' do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: create(:user)) }
  given!(:answers) { create_list(:answer, 2, question: question, user: create(:user)) }

  describe 'Authenticated user', js: true do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'select the best answer' do
      within ".answer-id-#{answers.first.id}" do
        click_on 'The Best Answer'
        expect(page).to have_content answers.first.body
        expect(page).to_not have_link 'The Best Answer'
      end
    end
  end

  scenario 'can not select the best answer in other questions' do
    sign_in second_user
    visit question_path(question)
    within ".answer-id-#{answers.first.id}" do
      expect(page).to_not have_link 'The Best Answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not select the best answer' do
      visit question_path(question)
      expect(page).to_not have_button 'The Best Answer'
    end
  end
end
