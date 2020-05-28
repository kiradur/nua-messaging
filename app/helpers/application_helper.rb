module ApplicationHelper
  include Pagy::Frontend

  def current_user
    # User.default_doctor
    User.current
  end
end
