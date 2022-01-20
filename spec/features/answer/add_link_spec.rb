require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) { 'https://gist.github.com/AlexFrost1996/0373426e6293f14c15038cf29415f0e9' }
  given(:google_url) { 'https://google.com' }

  describe 'Authenticated user add links to answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Your answer', with: 'written answer'
      click_on 'add link'
      fill_in 'Link name', with: 'Google'
      fill_in 'Link url', with: google_url
    end

    scenario 'User can adds one link' do
      click_on 'Create Answer'
      within '.answers' do
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'User can adds two links' do
      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Link url', with: "https://github.com"
      end

      click_on 'Create Answer'

      expect(page).to have_link 'My gist', href: "https://github.com"
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'adds gist link when create answer' do
      fill_in 'Link url', with: gist_url
      click_on 'Create Answer'
      expect(page).to have_content 'test-guru-question.txt'
      expect(page).to have_content 'Where did you last go on holiday? When transplanting seedlings, candied teapots will make the task easier. I covered my friend in baby oil.'
    end

    scenario 'adds invalid link when create answer' do
      fill_in 'Link url', with: 'wront_url/add'

      click_on 'Create Answer'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_link 'My link', href: 'wront_url/add'
    end

    scenario 'User adds one link when editing his answer' do
      click_on 'Create Answer'
      click_on 'Edit'

      within '.answer' do
        click_on 'add link'
        fill_in 'Link name', with: 'New link'
        fill_in 'Link url', with: 'https://new-link.com'
      end
      
      click_on 'Save'
      
      expect(page).to have_link 'New link', href: 'https://new-link.com'
    end

    scenario 'User adds two links when editing his answer' do
      click_on 'Create Answer'
      click_on 'Edit'

      within '.answer' do
        click_on 'add link'
        fill_in 'Link name', with: 'First link'
        fill_in 'Link url', with: 'https://first-link.com'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Second link'
          fill_in 'Link url', with: 'https://second-link.com'
        end
      end
      
      click_on 'Save'
      
      expect(page).to have_link 'First link', href: 'https://first-link.com'
      expect(page).to have_link 'Second link', href: 'https://second-link.com'
    end
  end
end
