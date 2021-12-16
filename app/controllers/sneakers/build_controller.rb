class Sneakers::BuildController < ApplicationController
  include Wicked::Wizard

  skip_after_action :verify_policy_scoped, only: [:index]

  steps :add_sneaker_db, :add_infos, :add_photos

  def show
    @sneaker = Sneaker.find(params[:sneaker_id])
    authorize @sneaker
    render_wizard
  end

  def update
    @sneaker = Sneaker.find(params[:sneaker_id])
    authorize @sneaker
    sneaker_params[:sneaker][:status] = step.to_s
    sneaker_params[:sneaker][:status] = "active" if step == steps.last
    @sneaker.update(sneaker_params)
    render_wizard @sneaker
  end

  def create
    @sneaker = Sneaker.create
    authorize @sneaker
    redirect_to wizard_path(steps.first, sneaker_id: @sneaker.id)
  end

  private

  def filtering_params(params)
		params.slice(:price, :condition, :size, :category)
	end

	def sneaker_params
		params.require(:sneaker).permit(:sneaker_db_id, :size, :price, :condition, :box, :extras, photos: [])
	end

end