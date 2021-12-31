class Forest::Guide
  include ForestLiana::Collection

  collection :Guide
  
  action 'Upload file', type: 'single', fields: [{
    field: 'File',
    type: 'File',
    is_required: true
  }]

end