import Rails from '@rails/ujs';
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "sneakerModel"]

  get_sneaker_id() {
    let id = this.data.get("sneaker")
    this.get_sneaker(id)
  }

  get_sneaker(id) {
    fetch(`/sneaker_dbs/${id}/`, { headers: { 'Accept': 'application/json' } })
    .then(response => response.json())
    .then((data) => {
      console.log(data)
      // this.sneakerModelTarget.outerHTML = data;
    })
  }
}
// 