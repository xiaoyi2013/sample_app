class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope order: 'created_at DESC'

  # Returns microposts from the users being followed by the given user
  def self.from_users_followed_by(user)
    # method 1 : when user have very more followed_users,  the quantity is down
    # followed_user_ids = user.followed_user_ids
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)

    # method 2: sub-selection,  no sensitive
    # followed_user_ids = user.followed_user_ids
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)

    # method3: sub-selection, sensitive
    followed_user_ids = "select followed_id from relationships
                                 where follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
