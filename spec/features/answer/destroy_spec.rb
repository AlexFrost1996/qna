require 'rails_helper'

feature 'User can delete his answer' do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Aunthenticated user', js: true do
    scenario 'can delete his answer'  do
      sign_in(user)
      visit root_path
      click_on question.title

      within '.answers' do
        expect(page).to have_content answer.body
        
        click_on 'Delete answer'
        
        expect(page).to_not have_content answer.body
      end
    end

    scenario "could not delete another user's answer" do
      sign_in(second_user)
      visit root_path
      click_on question.title

      within '.answers' do
        expect(page).to_not have_content 'Delete answer'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'could not delete answers' do
      visit root_path
      click_on question.title

      within '.answers' do
        expect(page).to_not have_content 'Delete answer'
      end
    end
  end
end
