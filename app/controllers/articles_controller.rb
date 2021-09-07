class ArticlesController < ApplicationController
  def show
    #@ to make it available to html page. It's called instance variable
    @article = Article.find(params[:id])
  end
end
