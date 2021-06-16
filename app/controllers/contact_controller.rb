class ContactController < ApplicationController

  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @contact = Contact.new
    authorize @contact
  end
  
  
  def create
    @contact = Contact.new(contact_params)
    authorize @contact

    @contact.name = params[:contact][:name]
    @contact.email = params[:contact][:email]
    @contact.object = params[:contact][:object]
    @contact.message = params[:contact][:message]
    
    # raise
    # variable = Mailjet::Send.create(messages: [{
    #   'From'=> {
    #     'Email'=> "sarafianthomas@gmail.com",
    #     'Name'=> @contact.name
    #   },
    #   'To'=> [
    #     {
    #       'Email'=> 'thomassarafian@gmail.com',
    #       'Name'=> 'Thomas'
    #     }
    #   ],
    #   'TemplateID'=> 2963699,
    #   'TemplateLanguage'=> true,
    #   'Subject'=> "Email provenant de #{@contact.email}",
    #   'Variables'=> {
    #     "email" => @contact.email,
    #     "object" => @contact.object,
    #     "name" => @contact.name,
    #     "message" => @contact.message
    #   }
    # }])
    
    #   variable = Mailjet::Send.create(messages: [{
    #   'From'=> {
    #       'Email'=> 'sarafianthomas@gmail.com',
    #       'Name'=> "Contact"
    #   },
    #   'To'=> [
    #       {
    #           'Email'=> "thomassarafian@gmail.com",
    #           'Name'=> 'Thomas'
    #       }
    #   ],
    #   'Subject'=> "Email provenant de #{@contact.email}",
    #   'HTMLPart'=> "
    #   <h4>Nom : #{@contact.name} | Email : #{@contact.email}</h4>
    #   <h5>Message : </h5><p>#{@contact.message}</p>"
    # }])
    
    # p variable.attributes[:messages]
    
    redirect_to root_path, notice: "Ton email a bien été envoyé !"

    # render html: @contact.errors

  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :object)
  end

end