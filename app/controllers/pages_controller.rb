class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter]
	def home
  end
  def about
  end
  def newsletter
    newsletter_params
    if params['user']['email'].present? && params['user']['first_name'].present?
      SubscribeToNewsletterService.new(params['user']).home_page_signup
    end
  end
  def newsletter_params
    params.permit(:user, :commit, :first_name, :email)
  end
end
