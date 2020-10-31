class UserController < ApplicationController
  def course
    @user = User.find_by(name: "koji") #should be lineID
    
    course_nums = [1, 2, 3, 4, 5, 6, 7]
    @courses = []
    course_nums.each do |course_num|
    @courses << @user.course_infos.where(time: course_num).order(:day)
    @times = @user.course_times
    end
  end

  def edit
    @course = CourseInfo.find_by(id: params[:course_id])
  end
end
