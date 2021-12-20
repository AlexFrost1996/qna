require 'rails_helper'

feature 'User can view all questions' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  scenario 'Authenticated user can view all questions' do
    sign_in(user)
    visit root_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'Unauthenticated user can view all questions' do
    visit root_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
