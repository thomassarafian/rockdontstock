
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


// import "../../assets/stylesheets/application.scss";

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('dotenv').config()

import "bootstrap";
import "flickity"
import "./fullscreen.js"
import "controllers"
import "./pagy.js.erb"

// import { sneakerNew } from "components/sneaker_new.js"
// import { pointPicker } from "components/point_picker.js"
// import { editSneakerPhotos } from "components/edit_sneaker_photos.js"
// import { getPhotosModal } from "components/get_photos_modal.js"
import { previewImageOnFileSelect } from "components/photo_preview.js"
import { uploadIds } from "components/upload_ids.js"
import { ibanValidator } from "components/iban_validator.js"
import { createStripeTokenEditUser } from "components/create_stripe_token_edit_user.js"

document.addEventListener('turbolinks:load', () => {
  previewImageOnFileSelect();
  uploadIds();
  ibanValidator();
  createStripeTokenEditUser();
  // sneakerNew();
  // pointPicker();
  // editSneakerPhotos();
  // optimizeUploadPhotos()
  // getPhotosModal();
});







