class User < ApplicationRecord
  has_many :course_infos, dependent: :destroy
end
