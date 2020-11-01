class CourseTimesController < ApplicationController
  before_action :redirect_unauthorized

  def edit
    @user = User.find_by(id: params[:user_id])
    @course_time = @user.course_times.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:user_id])
    @course_time = @user.course_times.find_by(id: params[:id])
    @course_time.start_hour = params[:start_hour]
    @course_time.start_minute = params[:start_minute]
    @course_time.end_hour = params[:end_hour]
    @course_time.end_minute = params[:end_minute]
    if @course_time.save
      @course_time.save
      flash[:notice] = "更新しました。"
      redirect_to('/')
    else
      flash[:error] = "整数を入力してください"
      render('course_times/edit')
    end
  end
end
