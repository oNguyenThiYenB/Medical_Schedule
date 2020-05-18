class CommentsController < ApplicationController
  before_action :load_commentable, except: :new
  before_action :load_comment, only: %i(edit update destroy)
  load_and_authorize_resource

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new content: params[:content]
    @comment.patient = current_user
    if @comment.save
      @doctor = @commentable
      respond_to :js
    else
      render :new
    end
  end

  def edit
    respond_to :js
  end

  def update
    if @comment.update content: params[:doctor][:content]
      respond_to :js
    else
      flash[:danger] = t "edit_falsed"
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      respond_to :js
    else
      flash[:danger] = t "delete_comment_failed"
      redirect_to @commentable
    end
  end

  private

  def load_comment
    return if @comment = Comment.find_by(id: params[:id])

    flash[:danger] = t "comment_not_found"
    redirect_to doctor_path
  end

  def load_commentable
    return if @commentable = Doctor.find_by(id: params[:doctor_id])

    flash[:danger] = t "not_found"
    redirect_to doctors_path
  end
end
