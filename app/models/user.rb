class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_one :profile
  has_many :posts
  has_many :comments

  has_many :followings, class_name: 'Follow', foreign_key: :follower_id
  has_many :followers, class_name: 'Follow', foreign_key: :followed_id

  has_many :saved_posts
  has_many :saved_for_later, through: :saved_posts, source: :post
end
