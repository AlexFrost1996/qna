require 'rails_helper'

feature 'User can delete his links from question' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, name: 'Google', url: 'https://google.com/', linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'user can delete link' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete link'
      expect(page).to_not have_link link.name, href: link.url
    end

    scenario 'user can not delete not his links' do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'user can not delete link' do
      visit question_path(question)
      expect(page).to_not have_link 'Delete link'
    end
  end
end
