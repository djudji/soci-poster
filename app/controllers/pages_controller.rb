class PagesController < ApplicationController
  before_action :authenticate_user!, only: :dashboard

  def home
    redirect_to dashboard_path if current_user
  end

  def dashboard
    @scheduled = current_user.posts.scheduled.paginate(page: params[:scheduled_page], per_page: 4)
    @history = current_user.posts.history.paginate(page: params[:history_page], per_page: 4)
  end
end
