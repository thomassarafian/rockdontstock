class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about]
	def home
    @sneaker_db = SneakerDb.pluck(:name, :img_url).sort
  end
  def about
  end

end
