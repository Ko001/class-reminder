class CourseInfo < ApplicationRecord
  belongs_to :users, optional: true 
end
