require "ostruct"

class PagesController < ApplicationController
<<<<<<< Updated upstream
  def home
=======
  def index
    @articles = ArticleCache.all.order(published_at: :desc).limit(3)
>>>>>>> Stashed changes
  end
end
