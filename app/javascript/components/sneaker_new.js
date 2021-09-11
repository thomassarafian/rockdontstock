import { errorInputPhotos } from "components/sneaker_new/error_input_photos.js";
import { resizePhotos } from "components/sneaker_new/resize_photos.js";
import { displayStep2 } from "components/sneaker_new/display_step2.js";
import { displayStep3 } from "components/sneaker_new/display_step3.js";

function sneakerNew() {
  let newSneakerForm = document.querySelector('.new-sneaker-form');
  if (newSneakerForm) {
    document.querySelector('.snd-next-btn').style.display = "none"
    document.querySelector('.submit-new-sneaker').style.display = "none"
    document.querySelector('.photos-input').style.display = "none"
    document.querySelector('.summary-new-sneaker').style.display = "none"
    const sneakerSize = document.getElementById('sneaker_size');
    const sneakerCondition = document.getElementById('sneaker_condition');
    const sneakerBox = document.getElementById('sneaker_box');
    const sneakerExtras = document.getElementById('sneaker_extras');
    const sneakerPrice = document.getElementById('sneaker_price');

    function setErrorFor(input, message) {
      const formControl = input;
      formControl.classList.add("is-invalid");
      const inputError = document.querySelector(`#${input.id}_error`);
      inputError.style.visibility = "visible";
      inputError.innerHTML = `<small>${message}</small>`;
    }
    function setSuccessFor(input) {
      const formControl = input;
      formControl.classList.remove("is-invalid");
      formControl.classList.add("is-valid");
      const inputError = document.querySelector(`#${input.id}_error`);
      input.parentElement.style.margin = "0px";
      inputError.style.visibility = "hidden";
    }
    
    function newSneakerCheckInputs() {
      const sneakerSizeValue = sneakerSize.value;
      const sneakerConditionValue = sneakerCondition.value;
      const sneakerBoxValue = sneakerBox.value;
      const sneakerExtrasValue = sneakerExtras.value;
      const sneakerPriceValue = sneakerPrice.value;
      if (sneakerSizeValue === '') {
        setErrorFor(sneakerSize, "Indique la taille de ta paire");
        return -1;
      } else {
        setSuccessFor(sneakerSize);
      }
      if (sneakerConditionValue === '') {
        setErrorFor(sneakerCondition, "Mets une note / 10 sur la condition de ta paire");
        return -1;
      } else {
        setSuccessFor(sneakerCondition);
      }
      if (sneakerBoxValue === '') {
        setErrorFor(sneakerBox, "Indique quel box tu as");
        return -1;
      } else {
        setSuccessFor(sneakerBox);
      }
      if (sneakerExtrasValue.length > 40) {
        setErrorFor(sneakerExtras, "Ne dépasse pas 40 charactères");
        return -1;
      } else {
        setSuccessFor(sneakerExtras);
      }
      if (sneakerPriceValue === '')  {
        setErrorFor(sneakerPrice, "Indique le prix auquel tu veux vendre ta paire");
        return -1;
      } else if (sneakerPriceValue.match(/[^0-9,]/g)) {
        console.log("okkkkkk!!")
        setErrorFor(sneakerPrice, "Le prix ne doit contenir que des chiffres et/ou une virgule. Ex: 199,99 ou 199");
        return -1;
      } else if (checkAfterComma(sneakerPriceValue)) {
        setErrorFor(sneakerPrice, "Le prix ne doit pas avoir plus de 2 chiffres après la virgule");
        return -1;
      } else if (parseFloat(sneakerPriceValue) > 240042 || parseFloat(sneakerPriceValue) < 10)  {
        setErrorFor(sneakerPrice, "Le prix ne peux pas être inférieur à 10€ ou trop élevé");
        return -1;
      } else {
        setSuccessFor(sneakerPrice);
      }
    }

    function checkAfterComma(sneakerPriceValue) {
      let k = 0;
      for (let i = 0; i <= sneakerPriceValue.length; i++) {
        if (sneakerPriceValue[i] == ',') {
          for (let j = i + 1; sneakerPriceValue[j]; j++) {
            k++;
            if (k > 2) {
              return true;
            }
          }
        }
      }
      return false;
    }

    document.getElementById('nextBtn').addEventListener('click', (event) => {
      event.preventDefault();
      if (newSneakerCheckInputs() == - 1) {}
      else {
        let photosInput = document.querySelector('.photos-input');
        let infoInput =  document.querySelector('.info-input');
        let submitSneaker = document.querySelector('.submit-new-sneaker');
        let nextBtn = document.querySelector('.next-btn');    
        photosInput.style.display = "flex";
        submitSneaker.style.display = "block";
        infoInput.style.display = "none";
        nextBtn.style.display = "none";
        document.querySelector(".search-sneaker-model-title").scrollIntoView();
        let photoPreview = [];
        photoPreview = displayStep2();

        let sndNextBtn = document.querySelector('.snd-next-btn');
        sndNextBtn.style.display = "block";
        sndNextBtn.addEventListener('click', (event) => {
          event.preventDefault();
          if (errorInputPhotos() > 0) {
            return -1;
          } else {
            photosInput.style.display = "none";
            sndNextBtn.style.display = "none";
            resizePhotos();
            displayStep3(photoPreview);
            };
          });

        }; 
      });
  }
}

export { sneakerNew }