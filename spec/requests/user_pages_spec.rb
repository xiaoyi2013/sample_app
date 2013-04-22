require 'spec_helper'

describe "user pages" do

  subject { page }

  describe "sigup page" do

    before { visit signup_path}

    it { should have_selector('h1', text: "Sign Up")}
    it { should have_selector('title', text: full_title('Sign Up'))}
  end

  describe "profile page" do
    # code to generate a user
    let(:user) { FactoryGirl.create(:user)}
    before { visit user_path(user)}

    it { should have_selector('title', text: user.name)}
    it { should have_selector('h1', text: user.name)}
  end

  describe "signup page" do

    before {  visit signup_path }
    let(:submit) { "Create my account"}

    describe "with invalid information" do

      it "should  signup failed" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submit" do
        before { click_button submit}

        it { should have_selector('title', text: 'Sign Up')}
        it { should have_content('error')}
      end

    end  # with invalid information

    describe "with valid information" do
      before do
        fill_in "Name",          with: "zhangsan"
        fill_in "Email",           with: "zhangsan@gmail.com"
        fill_in "Password",      with: "zhangsan"
        fill_in "Confirmation",  with: "zhangsan"
      end

      it "should create a user" do
        expect do
          click_button submit
        end.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit}
        let(:user) { User.find_by_email("zhangsan@gmail.com")}
        it { should have_selector('title', text: user.name)}
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
        it { should have_link('Sign out') }
      end

    end  # with valid information

  end  # signup page

  describe "edit page" do

    let (:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }
    
    shared_examples_for "edit page should have content" do
      it { should have_selector('title', text: "Edit user") }
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_error_message("error") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    
    describe "edit with invalid message" do
      before { click_button "Save changes" }
      it_should_behave_like "edit page should have content"
    end
    
    describe "edit with valid message" do
      before do
        fill_in "Name",                   with:  user.name
        fill_in "Email",                    with:  user.email
        fill_in "Password",               with:  user.password
        fill_in "Confirm Password",    with:  user.password_confirmation
      end
      
      describe "click link to change photo of profile" do
        before { click_link('change', href: "http://gravatar.com/emails") }
        it { should have_link(user.name, href: "http://gravatar.com/#{user.email}" )}
      end

        describe "click button to change profile" do
          before { click_button("Save changes") }
          # it turned to user information show page
          it { should have_selector('title', text: user.name) }
        end
      
    end # edit with valid message

    
  end # edit page
  

end  # user page
