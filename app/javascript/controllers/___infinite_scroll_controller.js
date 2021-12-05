// import Rails from '@rails/ujs';
// import { Controller } from "stimulus"
// import { useIntersection } from 'stimulus-use'

// export default class extends Controller {
//   static targets = [ "entries", "pagination" ]

//   connect() {
//     console.log('ok');
//     useIntersection(this, {
//       rootMargin: "150px",
//     });
//   }
//   appear() {
//     this.loadMore(this.nextUrl);
//   }
//   get nextUrl() {
//     return this.data.get("nextUrl");
//   }

//   loadMore(url) {
//     Rails.ajax({
//       type: "GET",
//       url: url,
//       dataType: "text",
//       success: (_data, _status, xhr) => {
//         this.element.outerHTML = xhr.response;
//       }
//     })
//   }
// }
