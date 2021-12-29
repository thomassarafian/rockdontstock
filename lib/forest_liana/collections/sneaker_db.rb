class Forest::SneakerDb
  include ForestLiana::Collection

  collection :SneakerDb

  action 'Upload Legal Docs', type: 'single', fields: [{
    field: 'Certificate of Incorporation',
    description: 'The legal document relating to the formation of a company or corporation.',
    type: 'File',
    is_required: true
  }]
end