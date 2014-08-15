class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
  	@server = Server.find(params[:server_id])
  	@comment = @server.comments.create(comment_params)
  	redirect_to @server
  end

  def destroy
  	@comment = Comment.find(params[:comment_id])
  	@comment.destroy
  	redirect_to servers_path
  end

  private
  def comment_params
    params.require(:comment).permit(:user, :text)
  end
end
