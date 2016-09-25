class PagesController < ApplicationController
  before_action :authenticate_user!, only: :dashboard

  def home
    redirect_to dashboard_path if current_user
  end

  def dashboard
    @scheduled = current_user.posts.scheduled
    @history = current_user.posts.history
  end
end
