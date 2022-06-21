class ContactController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(contact_params)

    @contact.name = params[:contact][:name]
    @contact.email = params[:contact][:email]
    @contact.object = params[:contact][:object]
    @contact.message = params[:contact][:message]
    
    if @contact.name == "" || @contact.email == "" || @contact.object == "" || @contact.message == ""
      redirect_to new_contact_path, alert: "Il faut remplir tous les champs"
    else
      variable = Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "nils@rockdontstock.com",
          'Name'=> @contact.name
        },
        'To'=> [
          {
            'Email'=> 'hello@rockdontstock.com',
            'Name'=> "Rock Don't Stock"
          }
        ],
        'TemplateID'=> 2963699,
        'TemplateLanguage'=> true,
        'Subject'=> "Email provenant de #{@contact.email}",
        'Variables'=> {
          "email" => @contact.email,
          "object" => @contact.object,
          "name" => @contact.name,
          "message" => @contact.message
        }
      }])
      redirect_to root_path, notice: "Ton email a bien été envoyé !"
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :object)
  end

end