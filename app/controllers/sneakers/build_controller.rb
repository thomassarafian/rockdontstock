class Sneakers::BuildController < ApplicationController
  include Wicked::Wizard

  steps :add_sneaker_db, :add_infos, :add_photos, :add_recap

  def show
    @sneaker = Sneaker.find(params[:sneaker_id])
    render_wizard
  end

  def update
    @sneaker = Sneaker.find(params[:sneaker_id])
    status = (step == steps.last ? "active" : step.to_s)

    if @sneaker.update(sneaker_params)
      @sneaker.update(status: status)
      
      if step == steps.last
        flash[:notice] = "Ton annonce a bien été envoyée !"
        redirect_to success_sneaker_build_index_path(@sneaker)
      else
        render json: {} and return if request.xhr?
        render_wizard @sneaker
      end
    else
      error_msg = @sneaker.errors.full_messages.join(', ')
      flash[:alert] = error_msg
      render json: {error: error_msg}, status: 422 and return if request.xhr?
      redirect_to request.referrer
    end
  end

  def success
    @sneaker = Sneaker.find(params[:sneaker_id])
  end

  private

	def sneaker_params
		params.require(:sneaker).permit(:sneaker_db_id, :size, :price, :condition, :box, :extras, sneaker_db_attributes: [:name], photos: [])
	end

end