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

  describe "micropost destruction" do
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
  end # micropost destruction

  describe "micropost quantity check" do
    let!(:micropost) { FactoryGirl.create(:micropost, user: user) }    
    before  do
      visit root_path
    end

    it { should have_content("1 micropost") }
    describe "should have some microposts" do
      it { user.microposts.clear }
      before(:all) { 32.times{ FactoryGirl.create(:micropost, user:user) } }
      after(:all) { user.microposts.clear }
      it { should have_content("32 microposts") }
      it { should have_link('2') }
      it "paginate check" do
        click_link('2')
        user.microposts.paginate(page: 2).each do |post|
          page.should have_content(post.content)
        end
      end
    end
  end # micropost quantity check
  
  describe "link 'delete' deteck" do
    let!(:another_user) { FactoryGirl.create(:user, name: "dingxueshen") }
    let!(:micropost) { FactoryGirl.create(:micropost, user: another_user) }

    before do
      click_link("Users")
      click_link("dingxueshen")
    end
    it { should_not have_link('delete') }
  end


end
