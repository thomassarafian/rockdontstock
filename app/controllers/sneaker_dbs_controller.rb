class SneakerDbsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @sneaker_dbs = policy_scope(SneakerDb)
  end

  def show
    @sneaker_db = SneakerDb.find(params[:id])
    authorize @sneaker_db
  end
end
