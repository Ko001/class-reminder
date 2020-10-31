class User < ApplicationRecord
  has_many :course_infos, dependent: :destroy
  has_many :course_times, dependent: :destroy
end
