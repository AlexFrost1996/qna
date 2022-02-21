require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask question
  As an unauntheticated user
  I'd like to be able to sign in
} do

  OmniAuth.config.test_mode = true
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User tries to sign up with oauth github' do
    mock_auth :github, 'user@server.com'
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User tries to sign up with oauth vkontakte' do
    mock_auth :vkontakte
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'new@user.com'
    click_on 'Send'
    expect(page).to have_content 'Confirm your email by link on your email.'
    sleep(1)
    open_email 'new@user.com'
    current_email.click_link 'Confirm your account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
