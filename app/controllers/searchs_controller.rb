class SearchsController < ApplicationController
  def index
    @pagy, @sneaker_dbs = pagy(policy_scope(SneakerDb).order(release_date: :desc))

    if params[:query].present?
      @sneaker_dbs = @sneaker_dbs.search_by_name_and_category(params[:query])
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'list.html', locals: { sneaker_dbs: @sneaker_dbs } }
    end

  end
end
