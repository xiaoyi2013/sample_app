# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do

  before  do
    @user = User.new(name: "dingyi",
                     email: "yiding2020@gmail.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end


  subject { @user}

  it { should respond_to(:name)}
  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:reverse_relationships)}
  it { should respond_to(:followers) }
  it { should be_valid}
  it { should_not be_admin }
  
  describe "with admin attributes set to true" do
    before {  @user.toggle!(:admin) }
    it { should be_admin }
  end
  describe "user's name can't be blank" do
    before { @user.name = " "}

    it { should_not be_valid}
  end

  describe "when email is not present" do
    before { @user.email = " "}

    it { should_not be_valid}
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51}

    it { should_not be_valid}
  end

  describe "when name is too small" do
    before { @user.name = "a" * 5}

    it { should_not be_valid}
  end

  describe "when email format is not correct" do
    it "should be invalid" do
      addresses = %w[ abc abc@def abc@def_wbe.com]
      addresses.each do |addr|
        @user.email = addr
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[abc@gmail.com A_US-ER@163.com def@b.f.org a+b@z.com]
      addresses.each do |addr|
        @user.email = addr
        @user.should be_valid
      end
    end
  end

  describe "when email address is taken already" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid}
  end

  describe "when email address is upcase" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid}
  end

  describe "email address with mixed case" do
    let(:mixed_case_address) { "DingYi@XUESHEN.com"}
    it "should saved as all lower-case " do
      @user.email = mixed_case_address
      @user.save
      @user.reload.email.should == mixed_case_address.downcase
    end

  end

  describe "when password is not present " do
    before { @user.password = @userpassword = " "}
    it { should_not be_valid}
  end

  describe "when password doesn't match confimation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid}
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid}
  end

  describe "return the value of authenticate" do

    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email)}

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid")}
      it { should_not == user_for_invalid_password}
      specify { user_for_invalid_password.should be_false }
    end

  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5}
    it { should be_invalid}
  end

  describe "remember token " do
    before { @user.save}
    its( :remember_token){ should_not be_blank}
  end

  describe "micropost associations" do
    before do
      @user.save
    end
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }
    let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
    its(:feed) { should include(newer_micropost) }
    its(:feed) { should include(older_micropost) }
    its(:feed) { should_not include(unfollowed_post) }
    describe "status" do
      let(:followed_user) { FactoryGirl.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "This is my micropost") }
      end
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end # status
  end # micropost associations

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    
    describe "user can following another user" do
      it { should be_following(other_user) }
      its(:followed_users) { should include(other_user) }
    end

    describe "followed users" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
    
    describe "user can unfollowing another user" do

      before {  @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
    
  end # following

  
  
end
