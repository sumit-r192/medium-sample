class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_one :profile
  has_many :posts
  has_many :comments

  # Association for users who are being followed by this user
  has_many :active_follows, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followed_users, through: :active_follows, source: :followed

  # Association for users who are followers of this user
  has_many :passive_follows, foreign_key: :followed_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :saved_posts
  has_many :saved_for_later, through: :saved_posts, source: :post
end
