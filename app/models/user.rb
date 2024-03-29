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

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy, class_name: "Relationship"
  has_many :followers, through: :reverse_relationships, source: :follower
  has_secure_password

  # before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase!}
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50, minimum: 6}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                        format: { with: VALID_EMAIL_REGEX},
                        uniqueness: { case_sensitive: false}
  validates :password, length: { minimum: 6}
  validates :password_confirmation, presence: true

  def feed
    # Micropost.where("user_id = ?", id)  # This have only current_user's microposts 
    Micropost.from_users_followed_by(self) # have current_user self and he followed users' all microposts
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
