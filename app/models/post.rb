class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  

  after_save :calculate_reading_time
  has_many :saved_posts
  has_many :saved_by_users, through: :saved_posts, source: :user

  enum status: {
    draft: 0,
    unpublished: 1,
    published: 2
  }

  scope :published_posts, -> { where(status: :published) }
  scope :draft_posts, -> { where(status: :draft) }
  scope :unpublished_posts, -> { where(status: :unpublished) }

  private

  def calculate_reading_time
    words_per_minute = 200 # Adjust this value based on your estimation of reading speed
    word_count = content.split.size
    self.reading_time = (word_count / words_per_minute).ceil
  end
end
