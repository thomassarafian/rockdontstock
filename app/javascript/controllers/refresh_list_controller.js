import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form", "list", "searchInput", "new_sneaker_form", "searchModel"]
  
  initialize() {
    // this.hide_form()
    // console.log(this.new_sneaker_formTarget)
    // if (this.new_sneaker_formTarget) {
      // this.new_sneaker_formTarget.classList.add('gaga');
    // }

    // console.log(this.newSneakerFormTarget)
  }

  // hide_form() {
  //   this.new_sneaker_formTarget.classList.add('gaga');
  // }

  update() {
    const url = `${this.formTarget.action}?query=${this.searchInputTarget.value}`
    fetch(url, { headers: { 'Accept': 'text/plain' } })
    .then(response => response.text())
    .then((data) => {
      this.listTarget.outerHTML = data;
    })
  }
  
  greet() {
    this.new_sneaker_formTarget.classList.remove('toggle-hide')
    this.searchModelTarget.classList.add('toggle-hide')
    

    // this.newSneakerFormTarget.classList.add('gaga');
    // console.log(this.data.get("sneaker"))
    // this.searchModelTarget.style.display = "none"

    // this.newSneakerFormTarget.style.display = "block";
  }
  
}
