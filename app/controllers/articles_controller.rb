class ArticlesController < ApplicationController
  before_action :load_article, only: :show
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @articles = Article.page(params[:page]).per Settings.new_page_size
  end

  def show; end

  def new
    @article = Article.new
  end

  private

  def load_article
    return if @article = Article.find_by(id: params[:id])

    flash[:danger] = t "not_found"
    redirect_to articles_path
  end
end
