require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong
    @micropost = user.microposts.build(content: "first micropost")
  end
  
  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end # accessible attributes
  
  describe "when user_id is not present" do
    before {  @micropost.user_id = nil }
    it { should be_invalid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should be_invalid }
  end

  describe "with long content" do
    let(:content) { "a" * 141 }
    before {  @micropost.content = content}
    it { should be_invalid }
  end
  
  describe "micropost associations" do
    let(:user2) { FactoryGirl.create(:user) }
    before { user2.save }
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: user2, created_at: 1.day.ago) }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: user2, created_at: 1.hour.ago) }
    it "should have the right microposts in the right order" do
      user2.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = user2.microposts.dup
      user2.destroy
      microposts.should_not be_empty
      microposts.each do |mp|
        Micropost.find_by_id(mp.id).should be_nil
      end
    end
  end # micropost associations


end
