class UsersController < ApplicationController
  def unauthorized
  end

  def sign_in
    @user = User.find_by(line_id: params[:line_id])

    if @user
      session[:line_id] = @user.line_id
      flash[:notice] = "サインインしました。"
      redirect_to("/users/#{@user.id}/courses")
    end
  end
end
