class CourseTime < ApplicationRecord
  belongs_to :users, optional: true 

  validates :start_hour, numericality: { only_integer: true }, allow_nil: true
  validates :start_minute, numericality: { only_integer: true }, allow_nil: true
  validates :end_hour, numericality: { only_integer: true }, allow_nil: true
  validates :end_minute, numericality: { only_integer: true }, allow_nil: true
end
