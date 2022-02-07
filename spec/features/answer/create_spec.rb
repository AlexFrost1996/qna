require 'rails_helper'

feature 'User can write answer' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write answer' do
      fill_in 'Your answer', with: 'written answer'
      click_on 'Create Answer'

      expect(page).to have_content 'written answer'
    end

    scenario 'can write answer with errors' do
      click_on 'Create Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can write answer with attached file' do
      fill_in 'Your answer', with: 'written answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
    
    context 'multiple sessions' do
      scenario "answer appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('second_user') do
          sign_in(second_user)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Your answer', with: 'written answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'add link'
          fill_in 'Link name', with: 'Google'
          fill_in 'Link url', with: 'https://google.com'
          click_on 'Create Answer'

          expect(page).to have_content 'written answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          within '.answers' do
            expect(page).to have_link 'Google', href: 'https://google.com'
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'written answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          within '.answers' do
            expect(page).to have_link 'Google', href: 'https://google.com'
          end
        end

        Capybara.using_session('second_user') do
          expect(page).to have_content 'written answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          within '.answers' do
            expect(page).to have_link 'Google', href: 'https://google.com'
          end
          
          within ".answer-id-#{Answer.last.id}" do
            expect(page.find('.rating')).to have_content '0'
            find('.vote-up').click
            expect(page.find('.rating')).to have_content '1'
            find('.vote-down').click
            expect(page.find('.rating')).to have_content '-1'
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not write answer' do
      visit question_path(question)
      expect(page).to_not have_button 'Create Answer'
    end
  end
end
