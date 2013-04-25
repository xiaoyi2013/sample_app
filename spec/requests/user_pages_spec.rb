require 'spec_helper'

describe "user pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each)  do
      sign_in user
      visit users_path
    end
    it { should have_selector('title', text: "All users") }
    it { should have_selector('h1', text: "All users") }
    
    describe "pagination" do
      before(:all) { 30.times{ FactoryGirl.create(:user) } }
      after(:all){ User.delete_all }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end #paginate
    
    describe "delete link" do

      it { should_not have_link('delete') }
      
      describe "admin can delete users" do
      let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(user)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end

      # describe "admin can't delete himself" do
      #   let(:admin) { FactoryGirl.create(:admin) }
      #   before do
      #     sign_in admin
      #     delete user_path(admin)
      #   end
      #   # delete admin, the count of Users - 1; but i can't describe it(It should using response.should format)
      # end
    end #delete link
  end # index
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
    before do
      sign_in user
      visit edit_user_path(user) 
    end
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
      let(:new_name) { "test2020" }
      let(:new_email) { "test2020@gmail.com" }
      before do
        fill_in "Name",                   with:  new_name
        fill_in "Email",                    with:  new_email
        fill_in "Password",               with:  user.password
        fill_in "Confirmation",           with:  user.password_confirmation
        click_button("Save changes")
      end
      
      # it turned to user information show page
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
      
    end # edit with valid message

    
  end # edit page

  describe "sign" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    describe "access 'new' action after sign-in" do
      before { visit signup_path }
      it { should have_content("This is the home page") }
    end
    describe "access create action after sign-in" do
      before { post users_path }
      specify { response.should redirect_to root_path }
    end
  end # sign

  describe "show page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago) }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago) }
    before { visit user_path(user) }

    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1', text: user.name) }
    describe "microposts" do
      it { should have_content("Microposts") }
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
    
  end # show page

end  # user page
