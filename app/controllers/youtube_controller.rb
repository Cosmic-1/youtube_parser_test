class YoutubeController < ApplicationController
  def index; end

  def search
    @search_results = YoutubeParserService.search(params[:query], page_token: params[:page_token])
  end
end
