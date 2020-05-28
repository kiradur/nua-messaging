class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    # User.default_doctor
    User.current
  end
end
