class Sneakers::BuildController < ApplicationController
  include Wicked::Wizard

  before_action :set_sneaker

  steps :sneaker_db, :infos, :photos, :recap

  def show
    render_wizard
  end

  def following_step
    # guard
    render_wizard @sneaker if !@sneaker.last_completed_step

    last_step = wizard_steps.index(@sneaker.last_completed_step.to_sym)
    following_step = wizard_steps[last_step + 1]
    jump_to(following_step)
    render_wizard @sneaker
  end

  # XHR (PUT)
  def upload_photos
    photos = sneaker_params[:photos]

    # guard
    if !photos.present? || photos.length < 6
      render json: { message: "Il manque des photos !" }, status: 422
      return
    end

    if @sneaker.update(photos: photos)

      # always keep status up to the very last completed step
      @sneaker.update(status: "photos") if !@sneaker.active? && past_step?(@sneaker.last_completed_step)

      render json: {}, status: 200
    else
      error_msg = @sneaker.errors.full_messages.join(', ')
      flash[:alert] = error_msg
      redirect_to request.referrer
    end
  end

  def update
    if @sneaker.update(sneaker_params)
      status = (step == steps.last ? "active" : "#{step.to_s}_ok")

      # always keep status up to the very last completed step
      check_past_step_if_defined = @sneaker.last_completed_step ? past_step?(@sneaker.last_completed_step) : true
      if !@sneaker.active? && check_past_step_if_defined
        @sneaker.update(status: status)
      end

      if step == steps.last
        flash[:notice] = "Ton annonce a bien été envoyée !"
        redirect_to success_sneaker_build_index_path(@sneaker)
      else
        jump_to(:recap) if params[:referer]&.match?('recap')
        render_wizard @sneaker
      end
    else
      error_msg = @sneaker.errors.full_messages.join(', ')
      flash.now[:alert] = error_msg
      redirect_to request.referrer
    end
  end

  def success; end

  private

  def set_sneaker
    @sneaker = Sneaker.find(params[:sneaker_id])
  end

	def sneaker_params
		params.require(:sneaker).permit(:sneaker_db_id, :size, :price, :condition, :box, :extras, sneaker_db_attributes: [:name], photos: [])
	end

end