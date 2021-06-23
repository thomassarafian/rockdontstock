class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about]
	def home
    @sneaker_dbs = policy_scope(SneakerDb).order(release_date: :desc)

    if params[:query].present?
      @sneaker_dbs = @sneaker_dbs.search_by_name_and_category(params[:query])
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/list.html', locals: { sneaker_dbs: @sneaker_dbs } }
    end



  end
  def about
  end

end
