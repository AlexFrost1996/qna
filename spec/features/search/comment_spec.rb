require 'sphinx_helper'

feature 'User can search comment' do
  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:comment) { create :comment, commentable: question, text: 'test_comment_text' }

  scenario 'User find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment.text
      choose 'Comment'

      click_on 'Search'

      expect(page).to have_content comment.text
    end
  end

  scenario 'User can not find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: '111'
      choose 'Comment'

      click_on 'Search'

      within '.search-result' do
        expect(page).to_not have_content comment.text
        expect(page).to have_content 'Nothing found'
      end
    end
  end

  scenario 'User search with all scope', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment.text
      choose 'All'

      click_on 'Search'

      within '.search-result' do
        expect(page).to have_content comment.text
      end
    end
  end
end
