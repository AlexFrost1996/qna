require 'sphinx_helper'

feature 'User can search questions' do
  given!(:question) { create :question, title: 'question_for_search' }

  scenario 'User find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      choose 'Question'

      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'User can not find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Question'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content question.title
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'User search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content question.title
      end
    end
  end
end
