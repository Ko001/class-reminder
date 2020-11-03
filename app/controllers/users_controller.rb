class UsersController < ApplicationController
  before_action :keep_line_id, only: [:sign_up, :create]

  def unauthorized
  end

  def sign_in
    @user = User.find_by(line_id: params[:line_id])

    if @user && @reply_token = params[:reply_token]
      session[:reply_token] = nil
      flash[:notice] = "サインインしました。"
      redirect_to("/users/#{@user.id}/courses")
    end
  end

  def sign_up
    if User.find_by(line_id: params[:line_id])
      flash[:error] = "すでに登録されています。"
      redirect_to("/users/#{User.find_by(line_id: params[:line_id]).id}/courses")
    end
    if @reply_token = params[:reply_token]
      session[:line_id] = params[:line_id]
    end
  end

  def create
    @user = User.new(line_id: @line_id)
    @user.name = params[:name]
    @user.university = params[:university]

    if @user.save
      @user.save
      day_nums = [0, 1, 2, 3, 4, 5, 6]
      class_nums = [1, 2, 3, 4, 5, 6, 7]


      day_nums.each do |day_num|
        class_nums.each do |class_num|
          @user.course_infos.create(day: day_num, time: class_num)
        end
      end

      class_nums.each do |class_num|
        @user.course_times.create(class_num: class_num)
      end
      flash[:notice] = "登録しました。"
      redirect_to("/users/#{@user.id}/courses")
    else
      flash[:error] = "必須項目です。"
      render('users/sign_up')
    end
  end
end
