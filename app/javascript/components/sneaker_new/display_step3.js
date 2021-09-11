function launchTimerForFinalSneakerNewButton() {
    let i = 11;
    document.getElementById('finishSneakerNewWaitMessage').style.display = "block";
    document.getElementById('waitTimer10s').textContent = i;
    i--;
    setInterval( function () {
      if (i >= 0) {
        document.getElementById('waitTimer10s').textContent = i;
        i--;
      }
    },1000);
    setTimeout(function() {
      document.getElementById('finishSneakerNewBtn').removeAttribute("disabled");
      document.getElementById('finishSneakerNewWaitMessage').style.display = "none";
    }, 11000);
  }  

function displayStep3 (photoPreview) {
  launchTimerForFinalSneakerNewButton();
  document.querySelector(".search-sneaker-model-title").scrollIntoView();
  let photosInput = document.querySelector('.photos-input');
  let summaryNewSneaker = document.querySelector('.summary-new-sneaker');
  // photosInput.style.display = "none";
  if (window.innerWidth >= 768) {
    summaryNewSneaker.style.display = "grid";
  } else {
    summaryNewSneaker.style.display = "block";
  }
  // sndNextBtn.style.display = "none";
  document.querySelector('.submit-new-sneaker').style.display = "block"
  document.querySelector('.search-sneaker-model-title').innerText = "Récapitulatif de ton annonce";
  for (let i = 0; i < 6; i++) {
    document.querySelector(`.carousel-sneaker-photo${i}`).innerHTML = `<img src="${photoPreview[i].src}" class="sneaker-show-photos">`;  
  }
  
  if (document.querySelector('.photo-input7').style.backgroundImage != "") {
    let carouselSneakerPhoto7 = document.createElement("div");
    carouselSneakerPhoto7.classList = "carousel-item carousel-sneaker-photo7"
    carouselSneakerPhoto7.innerHTML = `<img src="${photoPreview[7].src}" class="sneaker-show-photos">`;
    insertAfter(document.querySelector('.carousel-sneaker-photo5'), carouselSneakerPhoto7);
  }
  if ( document.querySelector('.photo-input6').style.backgroundImage != "") {
    let carouselSneakerPhoto6 = document.createElement("div");
    carouselSneakerPhoto6.classList = "carousel-item carousel-sneaker-photo6"
    carouselSneakerPhoto6.innerHTML = `<img src="${photoPreview[6].src}" class="sneaker-show-photos">`;
    insertAfter(document.querySelector('.carousel-sneaker-photo5'), carouselSneakerPhoto6);
  }

  function insertAfter(referenceNode, newNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
  }          

  document.querySelector('.summary-size').innerHTML = `<p>Taille : ${sneaker_size.value}</p>`;
  document.querySelector('.summary-cond').innerHTML = `<p>Condition : ${sneaker_condition.value} / 10</p>`;
  document.querySelector('.summary-extras').innerHTML = `<p>Description : ${sneaker_extras.value}</p>`;
  document.querySelector('.summary-box').innerHTML = `<p>Box : ${sneaker_box.value}</p>`;
  document.querySelector('.summary-price-seller').innerHTML = `<p class="summary-price-sneaker">Prix demandé : 
  <span id="summary-price-seller">${sneaker_price.value}€</span></p>`;
  let summaryPriceCheck = ((parseFloat(sneaker_price.value.replace(/,/g, ".")) *0.12)/2).toFixed(2);
  document.querySelector('.summary-price-check').innerHTML = `<p class="summary-price-sneaker">Frais d’authentification :
  <span id="summary-price-check">${summaryPriceCheck}€</span></p>`;
  let summaryPriceTotal = parseFloat( 
    // ((parseFloat(sneaker_price.value.replace(/,/g, ".")) *0.12)/2) + 
    parseFloat(sneaker_price.value.replace(/,/g, ".") ) - 4.99 ).toFixed(2);
  document.querySelector('.summary-price-total').innerHTML = `<strong><p class="summary-price-sneaker">TOTAL : 
  <span id="summary-price-total">${summaryPriceTotal}€</span></p></strong>`
}

export { displayStep3 };