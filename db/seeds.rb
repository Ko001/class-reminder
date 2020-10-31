# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name: "koji", university: "NCU")

day_nums = [0, 1, 2, 3, 4, 5, 6]
class_nums = [1, 2, 3, 4, 5, 6, 7]


day_nums.each do |day_num|
  class_nums.each do |class_num|
    user.course_infos.create(day: day_num, time: class_num)
  end
end

m1 = CourseInfo.find_by(day:1, time:1)
m1.course = "101"
m1.prof = "unknown"
m1.location = "room"
m1.save