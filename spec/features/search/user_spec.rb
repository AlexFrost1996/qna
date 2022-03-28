require 'sphinx_helper'

feature 'User can search users' do
  given!(:user) { create :user, email: 'test_user_email@gmail.com' }

  scenario 'User find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      choose 'User'

      click_on 'Search'

      expect(page).to have_content user.email
    end
  end

  scenario 'User can not find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'User'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content user.email
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'User search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content user.email
      end
    end
  end
end
