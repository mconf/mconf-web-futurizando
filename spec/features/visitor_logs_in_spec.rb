require 'spec_helper'

feature 'Visitor logs in' do
  before(:each) {
    @user = FactoryGirl.create(:user, :username => 'user', :password => 'password')
  }

  scenario 'with valid email and password' do
    sign_in_with @user.email, @user.password

    expect(page).to have_title(I18n.t('home.my'))
    expect(page).to have_content(I18n.t('home.my_spaces'))
    expect(current_path).to eq(my_home_path)
  end

  scenario 'with valid username and password' do
    sign_in_with @user.username, @user.password

    expect(page).to have_title(I18n.t('home.my'))
    expect(page).to have_content(I18n.t('home.my_spaces'))
    expect(current_path).to eq(my_home_path)
  end

  scenario 'with invalid email' do
    sign_in_with 'invalid_email', @user.password

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content 'Invalid email or password'
  end

  feature 'with valid credentials' do
    scenario 'from the frontpage' do
      visit root_path
      fill_in 'user[login]', with: @user.username
      find('#login-box').find('#user_password').set(@user.password)
      click_button 'Login'

      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /login' do
      visit login_path

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /users/login' do
      visit new_user_session_path

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /webconf/:id' do
      user = FactoryGirl.create(:user)
      room = FactoryGirl.create(:bigbluebutton_room, :param => "test", :owner => user)
      visit invite_bigbluebutton_room_path(room)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(invite_bigbluebutton_room_path(room))
    end
  end

  feature "is redirected back to the page he was previously" do
    scenario 'previously in /spaces' do
      visit spaces_path
      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(spaces_path)
    end

    scenario 'previously in /spaces/:id' do
      space = FactoryGirl.create(:space, public: true)
      visit space_path(space)
      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(space_path(space))
    end
  end

  feature "isn't redirected back to routes he shouldn't return to" do
    scenario 'from /users/login after a failed login' do
      sign_in_with 'invalid_email', @user.password
      expect(current_path).to eq(new_user_session_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from the registration page' do
      visit register_path

      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /users after a failed registration' do
      visit register_path
      click_button 'Register'
      expect(current_path).to eq("/users")

      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /users/password' do
      visit user_password_path
      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /users/password/new' do
      visit new_user_password_path
      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from /users/confirmation/new' do
      visit new_user_confirmation_path
      click_link 'Sign in'
      expect(current_path).to eq(login_path)

      sign_in_with @user.username, @user.password, false
      expect(current_path).to eq(my_home_path)
    end

    scenario 'from any xhr request' do
      skip
    end

    scenario 'from any non html request' do
      skip
    end

  end

  def sign_in_with(user_email, password, visit_page=true)
    visit new_user_session_path
    fill_in 'user[login]', with: user_email
    fill_in 'user[password]', with: password
    click_button 'Login'
  end
end
