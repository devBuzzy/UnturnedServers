class ArticlesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  def index
    @articles = Article.desc(:created_at)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create(article_params)
    @article.user = current_user
    if @article.save
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  private
  def article_params
    params.require(:article).permit(:text, :title)
  end
end
