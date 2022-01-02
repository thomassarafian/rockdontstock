class Forest::GuidesController < ForestLiana::SmartActionsController

  def upload_file
    guide_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first
    guide = Guide.find(guide_id)
    
    payload = params.dig('data', 'attributes', 'values')
    file = payload['File']
    uri = URI::Data.new(file)

    Tempfile.create(binmode: true) do |tmp|
      tmp.write(uri.data)
      guide.file.attach(
        io: tmp,
        filename: 'guide.pdf',
        content_type: 'application/pdf',
      )
    end
    
    render json: { success: 'Guide uploadé avec succès.' }
  end

end