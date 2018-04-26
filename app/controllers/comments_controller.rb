class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]
  respond_to :html, :js
  load_and_authorize_resource

  def create
    klass_name = request.fullpath.split('/')[1]=='questions' ? 'Question' : 'Answer'
    commentable_object = (Object.const_get klass_name).find(params["#{klass_name.downcase}_id"])
    @comment = commentable_object.comments.build(comment_params)
    @comment.user = current_user
    respond_with(@comment.save)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    channel_name = @comment.commentable_type=='Question' ? 'questions': "question_#{@comment.commentable.question_id}"
    ActionCable.server.broadcast(
        channel_name,
        {
            id: @comment.commentable_id,
            author_id: @comment.user_id,
            comments: Comment.where(commentable_id: @comment.commentable_id, commentable_type: @comment.commentable_type).pluck(:body)
        }
    )
  end

end
