class CoursesController < ApplicationController
  def index
    @user = User.find_by(name: "koji")
    
    course_nums = [1, 2, 3, 4, 5, 6, 7]
    @courses = []
    course_nums.each do |course_num|
    @courses << @user.course_infos.where(time: course_num).order(:day)
    @times = @user.course_times
    end
  end

  def edit
    @user = User.find_by(name: "koji")
    @course = @user.course_infos.find_by(id: params[:id])
    @day = ["日", "月", "火", "水", "木", "金", "土"]
  end

  def update
    @course = CourseInfo.find(params[:id])
    @course.course = params[:course]
    @course.prof = params[:prof]
    @course.location = params[:location]
    @course.pass = params[:pass]
    @course.save
    redirect_to('/')
  end

end
