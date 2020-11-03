class User < ApplicationRecord
  has_many :course_infos, dependent: :destroy
  has_many :course_times, dependent: :destroy

  validates :name, presence: true
  validates :university, presence: true
end
