// import { Controller } from "stimulus";
// // import { fetchWithToken } from "../utils/fetch_with_token";
// // import { openServicePointPicker } from "../components/point_picker";


// export default class extends Controller {
// 	static targets = ["form", "line1", "city", "postal_code", "picker_button", "display_address", "next_btn"]

//   refresh() {
//   	if (this.line1 != "" && this.city != "" && this.postal_code != "") {
//     	this.display_addressTarget.innerHTML = `<br><p>Mon adresse actuelle : ${this.line1}</p>`;
//     }
//   }
 
//   get line1 () {
//   	return this.line1Target.value
//   }
  
//   get city () {
//   	return this.cityTarget.value
//   }

//   get postal_code () {
//   	return this.postal_codeTarget.value
//   }
// }