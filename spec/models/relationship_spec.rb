require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject{ relationship }
  describe "accessible attributes" do
    it "should not allow access to follower id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    describe "follower methods" do
      it { should respond_to(:follower) }
      it { should respond_to(:followed) }
      its(:follower) { should == follower }
      its(:followed) { should == followed }
    end
  end # accessible attributes
  
  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should be_invalid }
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should be_invalid }
  end
end #Relationship
