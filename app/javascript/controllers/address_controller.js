import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
	static targets = ["form", "line1", "city", "postal_code"]

  refresh() {
  	let id = event.target.form.dataset.id;
	  fetchWithToken(`/me/${id}`, {
	    method: "PATCH",
	    headers: {
	      "Accept": "application/json",
	      "Content-Type": "application/json"
	    },
	    body: JSON.stringify({ 
	    	user: { 
	    		line1: this.line1,
	    		city: this.city,
	    		postal_code: this.postal_code,
	    	}
	    })
	  }).then(response => response.json())
	    .then((data) => {
	      console.log(data)
	    });

  	if (this.line1 != "" && this.city != "" && this.postal_code != "") {
    	this.formTarget.innerText = `Mon adresse actuelle : ${this.line1} ${this.city} ${this.postal_code}`;
    }
  }
  
  get line1 () {
  	return this.line1Target.value
  }
  
  get city () {
  	return this.cityTarget.value
  }

  get postal_code () {
  	return this.postal_codeTarget.value
  }
}