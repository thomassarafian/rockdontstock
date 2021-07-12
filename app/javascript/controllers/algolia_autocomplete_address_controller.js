import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "address" ]

  updatee() {  
    console.log("ok")
    let placesAutocomplete = places({
      appId: process.env.ALGOLIA_APP_ID,
      apiKey: process.env.ALGOLIA_API_KEY,
      container: document.querySelector('#user_line1'),
      language: 'fr', 
      countries: ['fr'],
      type: 'address'
    });
    
    // placesAutocomplete.on('change', function(e) {
    //   console.log(e.suggestion);
    //   console.log(`Ville: ${e.suggestion.city}`);
    //   console.log(`Code postal : ${e.suggestion.postcode}`);
    //   console.log(`Adresse line1 : ${e.suggestion.name}`);
    // });

    // fetch(`/me/${id}/`, {
    //   method: "PATCH",
    //   headers: {
    //     "Accept": "application/json",
    //     "Content-Type": "application/json"
    //   },
    //   body: JSON.stringify({ 
    //     user: { 
    //       line1: this.line1,
    //       city: this.city,
    //       postal_code: this.postal_code,
    //     }
    //   })
    // }).then(response => response.json())
    //   .then((data) => {
    //   });


  }
}
