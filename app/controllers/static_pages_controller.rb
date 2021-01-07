class StaticPagesController < ApplicationController
  def home
    @feed_items = if logged_in?
        current_user.feed.paginate(page: params[:page])
      else
        Post.feed.paginate(page: params[:page])
      end
  end

  def help; end
end
