require 'sphinx_helper'

feature 'User can search answers' do
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question, body: 'answer_test' }

  scenario 'User find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      choose 'Answer'

      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end

  scenario 'User can not find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Answer'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'User search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content answer.body
      end
    end
  end
end
