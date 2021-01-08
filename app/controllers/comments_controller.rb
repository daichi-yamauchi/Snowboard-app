class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'コメントしました。'
      redirect_to @post
    else
      render 'posts/show'
    end
  end

  def destroy; end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
