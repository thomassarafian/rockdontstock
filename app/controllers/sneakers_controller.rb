class SneakersController < ApplicationController
	before_action :set_sneaker, only: [:show, :edit, :update, :destroy]

	def index
		@sneakers = Sneaker.all
	end
	
	def show
	end
	
	def new
		@sneaker = Sneaker.new
	end
	
	def create
		sneaker = Sneaker.create(sneaker_params)
		redirect_to sneakers_path
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
	end

end
