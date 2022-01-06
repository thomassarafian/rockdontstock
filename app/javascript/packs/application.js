import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start()


var Flickity = require('flickity');
require("./flickity-fullscreen.js");
require("./flickity-imagesloaded.js");
require('dotenv').config()

window.Flickity = Flickity
window.Rails = Rails

import "bootstrap"
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