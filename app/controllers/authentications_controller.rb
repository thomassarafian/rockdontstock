class AuthenticationsController < ApplicationController

  def show
		@lc = Authentication.find(params[:id])
    respond_to do |format|
      format.pdf { render pdf: "Récapitulatif de commande", encoding: "UTF-8" }
    end
  end

end
