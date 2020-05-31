class ArticlesController < ApplicationController\
  # before_action :article_params, only: %i(create update)
  before_action :load_article, only: :show
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @articles = Article.page(params[:page]).per Settings.new_page_size
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params
    ActiveRecord::Base.transaction do
      byebug
      @article.save!
      # @article.attach_article_image params
    end
    flash[:success] = t "create_article_success"
    redirect_to articles_path
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "not_create_success"
    render :new
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
end
