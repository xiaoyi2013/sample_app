require 'spec_helper'

describe "AuthenticationPages" do

  subject { page}

  describe "signin pages" do
    before { visit signin_path }


    it { should have_selector('h1', text: "Sign in")}
    it { should have_selector('title', text: 'Sign in')}

    describe "with invalid information" do

      shared_examples_for "sign in with wrong data" do
        # click_button "Sign in"
        it { should have_selector('div.alert.alert-error', text: "Invalid")}
        it { should have_selector('h1', text: 'Sign in')}
        it { should have_selector('title', text: "Sign in")}
      end

       shared_examples_for "after visiting another page" do
           before { click_link "Home"}
            it { should_not have_selector('div.alert.alert-error')}
       end

      describe "click button directly" do
        before { click_button "Sign in" }
        it_should_behave_like "sign in with wrong data"
        it_should_behave_like "after visiting another page"
      end

      describe "fill with wrong format" do
        before do
          fill_in "Email",          with: "abc def@gmail"
          fill_in "Password",     with: "aaa"
          click_button "Sign in"
        end
        it_should_behave_like "sign in with wrong data"
        it_should_behave_like "after visiting another page"
      end




    end  # with invalid information

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      # before do
      #   fill_in "Email",      with: user.email
      #   fill_in "Password", with: user.password
      #   click_button "Sign in"
      # end
      before { valid_signin(user)}

      it { should have_selector('title', text: user.name)}
      it { should have_link('Profile', href: user_path(user))}
      it { should have_link('Sign out', href: signout_path)}
      it { should_not have_link('Sign in', href: signin_path)}

      describe "followed by signout" do
        before { click_link "Sign out"}
        it { should have_link "Sign in"}
      end

    end #with valid information

  end  # signin page
end  # Authentication
