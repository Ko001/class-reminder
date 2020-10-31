class ApplicationController < ActionController::Base
  @current_user = User.find_by(name: "koji")
end
