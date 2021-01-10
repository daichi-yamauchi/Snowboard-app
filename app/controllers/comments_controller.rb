class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.image.attach(params[:comment][:image])
    if @comment.save
      flash[:success] = 'コメントしました。'
      redirect_to @post
    else
      render 'posts/show'
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'コメントを削除しました。'
    redirect_to request.referer || root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content, :image)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end
