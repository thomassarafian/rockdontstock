class SearchsController < ApplicationController
  def index
    @sneaker_dbs = policy_scope(SneakerDb).order(release_date: :desc)

    if params[:query].present?
      # puts "->>>>>>>>>" + @sneaker_dbs.to_s
      @sneaker_dbs = @sneaker_dbs.where('name ILIKE ?', "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'list.html', locals: { sneaker_dbs: @sneaker_dbs } }
    end

  end
end
