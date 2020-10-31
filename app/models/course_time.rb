class CourseTime < ApplicationRecord
  belongs_to :users, optional: true 
end
