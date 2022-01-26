import Rails from '@rails/ujs';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';

Rails.start();
window.Rails = Rails;
ActiveStorage.start();
require('dotenv').config();

var Flickity = require('flickity');
window.Flickity = Flickity;
Flickity.prototype._touchActionValue = 'pan-y pinch-zoom';
require('./flickity-fullscreen.js');
require('./flickity-imagesloaded.js');

var clamp = require('clamp-js');
window.clamp = clamp;

import 'bootstrap';
import 'controllers';
import './pagy.js.erb';
var bodyScrollLock = require('body-scroll-lock');
var enableBodyScroll = bodyScrollLock.enableBodyScroll;
var disableBodyScroll = bodyScrollLock.disableBodyScroll;
window.enableBodyScroll = enableBodyScroll;
window.disableBodyScroll = disableBodyScroll;

// import { uploadIds } from "components/upload_ids.js"
// import { ibanValidator } from "components/iban_validator.js"
// import { createStripeTokenEditUser } from "components/create_stripe_token_edit_user.js"

// document.addEventListener('turbolinks:load', () => {
//   uploadIds();
//   ibanValidator();
//   createStripeTokenEditUser();
// });
