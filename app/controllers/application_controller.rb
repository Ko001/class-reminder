class ApplicationController < ActionController::Base
  before_action :get_current_user
  
  def get_current_user
    @current_user = User.find_by(name: "koji")
  end

  def redirect_unauthorized
    if @current_user == nil
      flash[:alert] = "不正なアクセスです。"
      redirect_to "/"
      return false
    end
  end

end
