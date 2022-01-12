require 'rails_helper'

feature 'User can add award to his question' do

  describe 'Authenticated user asks question and', js: true do
    given(:user) { create(:user) }
    given(:award_image) { "#{Rails.root}/spec/fixtures/award.png" }

    background do
      sign_in(user)
      visit root_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Text of the question'
    end

    scenario 'adds the award' do
      within '.award' do
        fill_in 'Award title', with: 'Question award title'
        attach_file 'Image', award_image
      end
      click_on 'Ask'
      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'adds invalid image to the award' do
      within '.award' do
        fill_in 'Award title', with: 'Question award title'
      end
      click_on 'Ask'
      expect(page).to have_content 'You must add an image file.'
    end

    scenario 'adds invalid title to the award' do
      within '.award' do
        attach_file 'Image', award_image
      end
      click_on 'Ask'
      expect(page).to have_content "Award title can't be blank"
    end
  end
end
