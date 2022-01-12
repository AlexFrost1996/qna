require 'rails_helper'

feature 'User can write answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write answer' do
      fill_in 'Your answer', with: 'written answer'
      click_on 'Create Answer'

      expect(page).to have_content 'written answer'
    end

    scenario 'can write answer with errors' do
      click_on 'Create Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can write answer with attached file' do
      fill_in 'Your answer', with: 'written answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not write answer' do
      visit question_path(question)
      expect(page).to_not have_button 'Create Answer'
    end
  end
end
