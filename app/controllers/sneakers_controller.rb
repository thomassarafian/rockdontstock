class SneakersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show]
	before_action :set_sneaker, only: [:show, :edit, :update, :destroy]

	def index
		@sneakers = policy_scope(Sneaker)
	end
	
	def show
	end
	
	def new
		@sneaker = Sneaker.new
		authorize @sneaker
	end
	
	def create
		@sneaker = current_user.sneakers.new(sneaker_params)
		authorize @sneaker
		if @sneaker.save
			redirect_to @sneaker, notice: 'Ta paire a bien été ajouté'
		end
	end

	def edit
	end
	
	def update
		@sneaker.update(sneaker_params)
		redirect_to sneaker_path(@sneaker)
	end

	def destroy
		@sneaker.destroy
		redirect_to sneakers_path
	end

	private

	def sneaker_params
		params.require(:sneaker).permit(:name, :size, :price, :condition, :serial_number, :box, :extras)
	end

	def set_sneaker
		@sneaker = Sneaker.find(params[:id])
		authorize @sneaker
	end
end
