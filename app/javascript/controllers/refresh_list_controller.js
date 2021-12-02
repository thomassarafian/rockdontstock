import { Controller } from "stimulus"
// import { getPhotosModal } from "../components/get_photos_modal.js"

export default class extends Controller {
  static targets = [ "form", "list", "searchInput"]
  
  update() {
    const url = `${this.formTarget.action}?query=${this.searchInputTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.listTarget.innerHTML = data;
      // getPhotosModal();
    })
  }
}
