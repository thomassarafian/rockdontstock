class Forest::GuidesController < ForestLiana::SmartActionsController
  def upload_file
    guide_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first
    guide = Guide.find(guide_id)

    attrs = params.dig('data', 'attributes', 'values')
    file = attrs['File']
    puts "*"*100, file
    guide.file.attach({
      io: File.open(file),
      filename: "guide.pdf",
      content_type: "application/pdf"
    })

    render json: { success: 'Guide uploadé avec succès.' }
  end
end