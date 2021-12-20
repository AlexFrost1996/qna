require 'rails_helper'

feature 'User can view question with answers' do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user can view question with answers' do
    sign_in(user)
    visit question_path(answer.question)
    expect(page).to have_content answer.question.body
    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticated user can view question with answers' do
    visit question_path(answer.question)

    expect(page).to have_content answer.question.body
    expect(page).to have_content answer.body
  end
end
