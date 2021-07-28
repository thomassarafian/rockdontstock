import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "list", "searchInput", "newSneakerForm", "sneakers"]

  update() {
    const url = `${this.formTarget.action}?query=${this.searchInputTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.listTarget.outerHTML = data;
    })
  }

  greet() {
    console.log(this.sneakersTarget)
    this.listTarget.style.display = "none";
    this.formTarget.style.display = "none";
    this.newSneakerFormTarget.style.display = "block";
  }
}
