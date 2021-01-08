class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def show
    @post = Post.find(params[:id])
    # redirect_to root_url and return if @post.nil?
    # @posts = @user.posts.paginate(page: params[:page])
    @comments = @post.comments.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = '投稿しました！'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_back(fallback_location: root_url)
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_type_id, :content, :image)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
