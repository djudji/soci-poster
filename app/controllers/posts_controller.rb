class PostsController < ApplicationController
  before_action :set_post, only: :cancel

  def new
    if current_user.connections.any?
      @post = Post.new
    else
      redirect_to dashboard_path, notice: 'Please create connection first!'
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to dashboard_path, notice: 'Post successfully created!' }
      else
        format.html { render :new }
      end
    end
  end

  def cancel
    @post.update_attributes(state: 'canceled')
    redirect_to dashboard_path, notice: 'Post successfully canceled'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :scheduled_at, :state, :user_id, :facebook, :twitter, :facebook_page)
  end
end
