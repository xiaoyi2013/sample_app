require 'spec_helper'

describe "MicropostPages" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    describe "with invalid information" do

      it "should not create a micropost" do
        expect {  click_button "Post" }.not_to change(user.microposts, :count)
      end

      describe "error message" do
        before { click_button "Post" }
        it { should have_content('error') }
      end # error message
    end # with invalid information
    
    describe "with valid information" do
      before{   fill_in "micropost_content",    with:  "my first micropost" }
      it "should create a micropost" do
        expect { click_button "Post" }.to  change(user.microposts, :count).by(1)
      end
    end  # with valid information  
  end # micropost creation

  describe "micropost destuction" do
    before { FactoryGirl.create(:micropost, user: user) }
    describe "in the profile page" do
      before  {  visit user_path(user) }
      it "should delete a micropost" do
        expect { click_link("delete") }.to change(Micropost, :count).by(-1)
      end
    end

    describe "in the root page" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link("delete") }.to change(user.microposts, :count).by(-1)
      end
    end
  end
end
