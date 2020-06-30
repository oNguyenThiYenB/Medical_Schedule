class ArticlesController < ApplicationController
  before_action :load_article, only: %i(show edit update destroy)
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @articles = Article.by_created_at_desc.page(params[:page]).per Settings.new_page_size
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params
    ActiveRecord::Base.transaction do
      @article.save!
      @article.attach_article_thumbnail params
    end
    flash[:success] = t "create_article_success"
    redirect_to articles_path

  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_create_success"
    render :new 
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @article.update! article_params
      @article.attach_article_thumbnail params
    end
    flash[:success] = t "news_updated"
    redirect_to articles_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "update_failed"
    render :edit
  end

  def destroy
    if @article.destroy
      flash[:success] = t "article_deleted"
    else
      flash[:danger] = t "article_delete_failed"
    end
    redirect_to articles_path
  end

  private

  def load_article
    return if @article = Article.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to articles_path
  end

  def article_params
    params.require(:article).permit Article::ARTICLE_PARAMS
  end

  def set_search_new
    @search = Article.ransack params[:q]
  end
end
