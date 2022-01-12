require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/AlexFrost1996/0373426e6293f14c15038cf29415f0e9' }
  given(:google_url) { 'https://google.com' }

  describe 'Authenticated user add links to question', js: true do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Link url', with: google_url
    end

    scenario 'User add one link when asks question' do
      click_on 'Ask'
      expect(page).to have_link 'My gist', href: google_url
    end

    scenario 'User add two links when asks question' do
      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Link url', with: 'https://google.com'
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: google_url
      expect(page).to have_link 'Google', href: 'https://google.com'
    end

    scenario 'adds gist link when ask question' do
      fill_in 'Link url', with: gist_url
      click_on 'Ask'
      expect(page).to have_content 'test-guru-question.txt'
      expect(page).to have_content 'Where did you last go on holiday? When transplanting seedlings, candied teapots will make the task easier. I covered my friend in baby oil.'
    end

    scenario 'User add link with invalid url when asks question' do
      fill_in 'Link url', with: 'wrong_url/add'
      click_on 'Ask'

      expect(page).to_not have_link 'My gist', href: 'wrong_url/add'
    end

    scenario 'User adds one link when editing his answer' do
      click_on 'Ask'
      click_on 'Edit'

      within '.question' do
        click_on 'add link'
        fill_in 'Link name', with: 'Added Link'
        fill_in 'Link url', with: 'https://qwerty.ua'
      end

      click_on 'Save'

      expect(page).to have_link 'Added Link', href: 'https://qwerty.ua'
    end

    scenario 'User adds two links when editing his answer' do
      click_on 'Ask'
      click_on 'Edit'

      within '.question' do
        click_on 'add link'
        fill_in 'Link name', with: 'Link-One'
        fill_in 'Link url', with: 'https://one.pl'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Link-Two'
          fill_in 'Link url', with: 'https://two.cz'
        end
      end

      click_on 'Save'

      expect(page).to have_link 'Link-One', href: 'https://one.pl'
      expect(page).to have_link 'Link-Two', href: 'https://two.cz'
    end
  end
end
