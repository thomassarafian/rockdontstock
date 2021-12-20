// // import { getPhotosModal } from '../components/get_photos_modal.js';
// import Rails from '@rails/ujs';
// import { Controller } from "stimulus";

// export default class extends Controller {
//   static targets = ["filter", "thelist"];

//   filter() {
//     const url = `${window.location.pathname}?${this.params}`;
//     Turbolinks.clearCache();
//     this.after_filter(url)
//   }

//   after_filter(url) {
//     Rails.ajax({
//       type: "GET",
//       url: url,
//       dataType: "text",
//       success: (_data, _status, xhr) => {
//         this.thelistTarget.outerHTML = xhr.response;
//         // getPhotosModal();
//       }
//     })
//   }

//   get params() {
//     return this.filterTargets.map((t) => `${t.name}=${t.value}`).join("&");
//   }
// }
