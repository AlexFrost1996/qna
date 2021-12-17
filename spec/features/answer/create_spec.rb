require 'rails_helper'

feature 'User can write answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write answer' do
      fill_in 'Body', with: 'written answer'
      click_on 'Answer'

      expect(page).to have_content 'written answer'
    end

    scenario 'can write answer with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not write answer' do
      visit question_path(question)
      expect(page).to_not have_button 'Answer'
    end
  end
end
