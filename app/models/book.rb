class Book < ApplicationRecord
  include Footprintable

  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :week_favorites, -> { week }, class_name: 'Favorite'
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :created_today, -> { where(created_at: Time.current.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: (1.week - 1.day).ago.beginning_of_day..Time.current.end_of_day) }
  scope :created_last_week, -> { where(created_at: (2.weeks - 1.day).ago.beginning_of_day..1.week.ago.end_of_day) }
  scope :created_target_day, -> (target){ where(created_at: target.days.ago.all_day) }


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
