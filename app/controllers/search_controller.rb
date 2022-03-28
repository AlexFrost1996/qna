class SearchController < ApplicationController
  before_action :set_params

  ALL = 'all'

  def search
    @result = SearchService.new(@query, @scope, @page).call unless @query.blank?
    render partial: 'search/result'
  end

  private

  def set_params
    @scope = params[:scope] || ALL
    @query = params[:query].to_s
    @page = params[:page]
  end
end
