# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new( name: "dingyi", email: "yiding2020@gmail.com") }

  subject { @user}

  it { should respond_to(:name)}
  it { should respond_to(:email)}
  it { should be_valid}
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


end
