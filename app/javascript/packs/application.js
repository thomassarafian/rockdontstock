import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

require('dotenv').config()

import "bootstrap"

var Flickity = require('flickity');
require("./flickity-fullscreen.js");
require("./flickity-imagesloaded.js");
window.Flickity = Flickity

// import Swiper, { Navigation, Pagination } from 'swiper';
// import 'swiper/swiper-bundle.min.css';
// Swiper.use([Navigation, Pagination]);
// window.Swiper = Swiper;

import "controllers";
import "./pagy.js.erb";

// import { uploadIds } from "components/upload_ids.js"
// import { ibanValidator } from "components/iban_validator.js"
// import { createStripeTokenEditUser } from "components/create_stripe_token_edit_user.js"

// document.addEventListener('turbolinks:load', () => {
//   uploadIds();
//   ibanValidator();
//   createStripeTokenEditUser();
// });