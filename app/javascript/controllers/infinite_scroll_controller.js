import Rails from '@rails/ujs';
import { Controller } from "stimulus"
import { useIntersection } from 'stimulus-use'



export default class extends Controller {
  static targets = [ "entries", "pagination" ]

  connect() {
    useIntersection(this, {
      rootMargin: "10px",
    });
  }
  appear() {
    this.loadMore(this.nextUrl);
  }
  get nextUrl() {
    // let next_page = this.paginationTarget.querySelector("a[rel='next']")
    // if (next_page == null) { return }
    // let url = next_page.href;
    // return url
    return this.data.get("nextUrl");
  }


  // appear() {
  //   console.log("WE ARE HERE");
  //   // let next_page = this.paginationTarget.querySelector("a[rel='next']")
  //   // if (next_page == null) { return }
  //   // let url = next_page.href;
  //   this.loadMore(url);
  // }

  // static targets = [ "cursor" ]

  scroll() {
  //   let sneakerElements = document.querySelectorAll('#sneaker-card-search');
  //   let lastId = sneakerElements[sneakerElements.length - 1];
    // console.log(`scrollY => ${scrollY}`);
  //   let next_page = this.paginationTarget.querySelector("a[rel='next']")
  //   if (next_page == null) { return }
  //   let url = next_page.href;

  //   // let popup_search = document.querySelector('#records_table');
  //   // let test = popup_search.clientHeight
  //   // console.log(test);
  //   // console.log(`windowInnerHeight: ${popup_search.innerHeight}`)
    
  //   // console.log(`Window.scrollY => ${window.scrollY}`);
  //   // console.log(`lastId.clientHeight => ${lastId.clientHeight}`);

  //   if (window.scrollY < lastId.clientHeight) {// && window.scrollY > 20) { //-169
  //     console.log("LOAD MORE DATA !")
  //     // this.loadMore(url)
    // }
  }
  // displayMessage() {
  //   let next_page = this.paginationTarget.querySelector("a[rel='next']")
  //   if (next_page == null) { return }
  //   let url = next_page.href;
  //   this.loadMore(url)
  // }
  
  // scroll() {
  //   let next_page = this.paginationTarget.querySelector("a[rel='next']")
  //   if (next_page == null) { return }
  //   let url = next_page.href;
    
  //   // console.log(url);
  //   let popupSearch = document.querySelector('.list-sneakers-cards');
  //   let height = popupSearch.clientHeight;
  //   console.log(height);
  //   // console.log(document.body.clientHeight);
  //   let new_height = 0
  //   if (window.scrollY > height) {
  //     // this.loadMore(url)
  //     // console.log("height -> " + height);
  //     // console.log("new height -> " + new_height);
  //     // return
  //   }
  loadMore(url) {
    Rails.ajax({
      type: "GET",
      url: url,
      dataType: "text",
      success: (_data, _status, xhr) => {
        this.element.outerHTML = xhr.response;
        // console.log('GOOOOOOOOOOOOOOOOO');
        // this.entriesTarget.insertAdjacentHTML('beforeend', data)
        // this.paginationTarget.innerHTML = data.pagination
        // return 0;
        // return 
      }
    })
  }
}
