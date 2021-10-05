let placesAutocomplete = places({
  appId: process.env.ALGOLIA_APP_ID,
  apiKey: process.env.ALGOLIA_API_KEY,
  container: document.querySelector('#user_line1'),
  language: 'fr', 
  countries: ['fr', 'be'],
  type: 'address'
});
    
placesAutocomplete.on('change', function(e) {
  $('input[type=hidden]#user_city').val(e.suggestion.city);
  $('input[type=hidden]#user_postal_code').val(e.suggestion.postcode);
  $('input[type=hidden]#hide_user_line1').val(e.suggestion.name);
});
