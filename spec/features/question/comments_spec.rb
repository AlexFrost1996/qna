require 'rails_helper'

feature 'User can add comments to questions' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user) }

  it_behaves_like 'creating comments' do
    given(:path) { question_path(question) }
    given(:guest_path) { question_path(question2) }
    given(:html_class) { '.question' }
    given(:guest_html_class) { '.question' }
  end
end
