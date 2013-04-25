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
      # before { valid_signin(user)}
      before { sign_in(user) }

      it { should have_selector('title', text: user.name)}
      it { should have_link('Profile', href: user_path(user))}
      it { should have_link('Sign out', href: signout_path)}
      it { should have_link('Settings', href: edit_user_path(user))}
      it { should_not have_link('Sign in', href: signin_path)}
      it { should have_link('Users', href: users_path) }
      describe "followed by signout" do
        before { click_link "Sign out"}
        it { should have_link "Sign in"}
      end

    end #with valid information

  end  # signin page
  
  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        
        describe "visiting the edit page"  do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: "Sign in") }
        end
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: "Sign in") }
        end
      end # in the Users controller
      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to signin_path }
        end
        describe "submitting to the destory action" do
          let(:micropost) { FactoryGirl.create(:micropost) }
          before { delete micropost_path(micropost) }
          specify { response.should redirect_to signin_path }
        end
      end
      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }
        before { sign_in non_admin }
        
        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to root_path }
        end
      end # non-admin
      describe "when attempting to visit a protected page" do
        before { visit edit_user_path(user) }
        describe "after signin" do
          before do
            fill_in "Email",         with: user.email
            fill_in "Password",    with: user.password
            click_button "Sign in"
          end
          it { should have_selector('title', text: "Edit user") }
          
          describe "when sign in again" do
            before do
              visit signin_path 
              fill_in "Email",       with: user.email
              fill_in "Password",  with: user.password
              click_button "Sign in"
            end
            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name)
            end
          end
        end
      end #"when attempting"
    end # for non-signed-in users

    describe "as wrong users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "example@gmail.com") }
      before { sign_in user }
      
      describe "editing another person's page" do
        before {  visit edit_user_path(wrong_user) }
        it { should have_content(user.name) }  # 
      end

      describe "updating another person's page" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to root_path }
      end
        
    end # for signed-in users
  end # authorization
  
  
end  # Authentication
