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
    it "should  signup failed" do
      expect { click_button submit }.not_to change(User, :count)
    end

    it "should signup successful" do
      fill_in "Name",          with: "zhangsan"
      fill_in "Email",           with: "zhangsan@gmail.com"
      fill_in "Password",      with: "zhangsan"
      fill_in "Confirmation",  with: "zhangsan"
      expect do
        click_button submit
      end.to change(User, :count).by(1)

    end

  end


end
