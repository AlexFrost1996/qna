require 'rails_helper'

feature 'User can vote' do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes up' do
      within ".answer-id-#{answer.id}" do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '1'
      end
    end

    scenario 'votes down' do
      within ".answer-id-#{answer.id}" do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '-1'
      end
    end

    scenario 'votes reset up' do
      within ".answer-id-#{answer.id}" do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '1'
        find('.vote-up').click
        expect(page.find('.rating')).to have_content '0'
      end
    end

    scenario 'votes reset down' do
      within ".answer-id-#{answer.id}" do
        expect(page.find('.rating')).to have_content '0'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '-1'
        find('.vote-down').click
        expect(page.find('.rating')).to have_content '0'
      end
    end

    scenario 'can see rating' do
      within ".answer-id-#{answer.id}" do
        expect(page.find('.rating')).to have_content '0'
      end
    end
  end

  scenario 'can not vote for own resource', js: true do
    sign_in author
    visit question_path(question)
    expect(page).to_not have_css 'a.vote-up'
    expect(page).to_not have_css 'a.vote-down'
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)
    expect(page).to_not have_css 'a.vote-up'
    expect(page).to_not have_css 'a.vote-down'
  end
end
