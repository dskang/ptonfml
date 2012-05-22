class ApplicationController < ActionController::Base
  protect_from_forgery

  def is_admin?
    session[:admin]
  end
end
