class StaticPagesController < ApplicationController
  def home
    @feed_items = Post.feed.paginate(page: params[:page])
    @h1_title = '投稿一覧'

    # フィード表示
    # @feed_items = if logged_in?
    #     @h1_title = '投稿フィード'
    #     current_user.feed.paginate(page: params[:page])
    #   else
    #     @h1_title = '投稿一覧'
    #     Post.feed.paginate(page: params[:page])
    #   end
  end

  def help; end
end
