class CoursesController < ApplicationController
  before_action :redirect_unauthorized
  def index
    @user = @current_user
    @user.pass = nil
    @user.save
    course_nums = [1, 2, 3, 4, 5, 6, 7]
    @courses = []
    course_nums.each do |course_num|
    @courses << @user.course_infos.where(time: course_num).order(:day)
    @times = @user.course_times.all.order(:class_num)
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id])
    @course = @user.course_infos.find_by(id: params[:id])
    @day = ["日", "月", "火", "水", "木", "金", "土"]
  end

  def update
    @user = User.find_by(id: params[:user_id])
    @course = @user.course_infos.find_by(id: params[:id])
    @course.course = params[:course]
    @course.prof = params[:prof]
    @course.location = params[:location]
    @course.pass = params[:pass]
    if @course.save
      @course.save
      flash[:notice] = "更新しました。"
      redirect_to("/users/#{@user.id}/courses")
    end
  end

end
