function pointPicker() {

  // function toggleDeliveryName(deliveryName1) {
  //   document.querySelector(`.delivery-name-${deliveryName1}`).classList.forEach(function(element) { 
  //     if (element == "delivery-cliked") {
  //       document.querySelector(`.delivery-name-${deliveryName1}`).classList.toggle('delivery-cliked');
  //       // if (deliveryName1 == 'mondial-relay') {
  //       //   document.querySelector(".point-picker").classList.remove('toggle-hidden');
  //       // } else if (deliveryName1 == 'colissimo') {
  //       //   document.querySelector(".adress_form").classList.remove('toggle-hidden');
  //       // }
  //     }
  //   });
  // }

  // function checkToggleHidden(deliveryName) {
  //   if (document.querySelector(`.delivery-name-${deliveryName}`).classList[1] == 'delivery-cliked') {
  //      document.querySelector('.adress_form').classList.add('toggle-hidden'); 
  //   } else if (document.querySelector(`.delivery-name-${deliveryName}`).classList[1] != 'delivery-cliked') {
  //      document.querySelector('.adress_form').classList.remove('toggle-hidden'); 
  //   } 
  // }


  const mondialRelay = document.querySelector('.mondial-relay');
  if (mondialRelay) {
    document.querySelector('.delivery-name-mondial-relay').classList.add('delivery-cliked');
    document.querySelector('.adress_form').classList.add('toggle-hidden');
    document.querySelector('.mondial-relay').style.pointerEvents = "none";
    
    document.querySelector('.payment-address-btn-mondial-relay').classList.add('toggle-hidden');

    document.querySelector('.payment-address-btn-mondial-relay').addEventListener('click', (event) => {
      event.stopImmediatePropagation();
      document.querySelector('.point-picker').classList.add('toggle-hidden');
      document.querySelector('#select_point_picker').addEventListener('click', (event) => {
        event.stopImmediatePropagation();
        openServicePointPicker("fr", "fr-fr");
        // let recapPaymentBtn = document.querySelector('.recap-payment-btn');
        document.querySelector('.recap-payment-mondial-relay-btn').style.display = "flex";
      });
    })
    
    document.querySelector('.mondial-relay').addEventListener('click', (event) => {
      event.stopImmediatePropagation();    
      
      clearDataForMondialRelay(); //retirer le background-noir de colissimo 

      document.querySelector('.mondial-relay').style.pointerEvents = "none";
      document.querySelector('.delivery-name-mondial-relay').classList.add('delivery-cliked');
      document.querySelector('.payment-address-btn-mondial-relay').classList.add('toggle-hidden');
      
      // if (document.querySelector('.point-picker-result')) {
        document.querySelector('.point-picker').classList.add('toggle-hidden');
      // }
      if (document.querySelector('.point-picker-result').textContent != '') {
        document.querySelector('.recap-payment-colissimo-btn').style.display = "flex";
      }
      // document.querySelector('.delivery-name-mondial-relay').classList.add('delivery-cliked');

      // document.querySelector('.adress_form').classList.toggle('toggle-hidden'); 
      
      document.querySelector('.payment-address-btn-mondial-relay').addEventListener('click', (event) => {
        event.stopImmediatePropagation();
        document.querySelector('.point-picker').classList.add('toggle-hidden');
        document.querySelector('#select_point_picker').addEventListener('click', (event) => {
          event.stopImmediatePropagation();
          openServicePointPicker("fr", "fr-fr");
          // let recapPaymentBtn = document.querySelector('.recap-payment-btn');
          if (document.querySelector('.point-picker-result').textContent != '') {
            document.querySelector('.recap-payment-mondial-relay-btn').style.display = "flex";
          }
        });
      })

    });
  }
  function clearDataForMondialRelay() {
    let deliveryColissimo = document.querySelector('.delivery-name-colissimo');
    document.querySelector('.colissimo').style.pointerEvents = "auto";
    //Retirer le background-noir
    if (deliveryColissimo.classList[1] == "delivery-cliked") { 
      deliveryColissimo.classList.remove('delivery-cliked');
    }
    document.querySelector('.payment-address-btn-colissimo').classList.remove('toggle-hidden');
    document.querySelector('.recap-payment-colissimo-btn').style.display = "none";
    // if (document.querySelector('point-picker').style.display == "none") { 
    // }

  }

  function clearDataForColissimo() {
    let deliveryMondialRelay = document.querySelector('.delivery-name-mondial-relay');
    let pointPicker = document.querySelector('.point-picker');
    document.querySelector('.mondial-relay').style.pointerEvents = "auto";
    
    //Retirer le background-noir
    if (deliveryMondialRelay.classList[1] == "delivery-cliked") { 
      deliveryMondialRelay.classList.remove('delivery-cliked');
    }

    //Retirer le point picker 
    if (pointPicker.classList[1] == "toggle-hidden") {
      pointPicker.classList.remove('toggle-hidden');
    }
    document.querySelector('.payment-address-btn-mondial-relay').classList.remove('toggle-hidden');
    document.querySelector('.recap-payment-mondial-relay-btn').style.display = "none";
    // if (document.querySelector('.adress_form').classList[1] != "toggle-hidden") {
    //   document.querySelector('.adress_form').classList.add('toggle-hidden'); 
    // } else if (document.querySelector('.delivery-name-colissimo').classList[1] != "delivery-cliked") {
    //   document.querySelector('.adress_form').classList.remove('toggle-hidden'); 
    // }
    // if (document.querySelector('.adress_form').classList.toggle('toggle-hidden')) {}
    // document.querySelector('.adress_form').classList.toggle('toggle-hidden');
  }



  const colissimo = document.querySelector('.colissimo');
  if (colissimo) {
    document.querySelector('.colissimo').addEventListener('click', (event) => {
      event.stopImmediatePropagation();
      clearDataForColissimo();
      document.querySelector('.payment-address-btn-colissimo').classList.add('toggle-hidden');
      document.querySelector('.colissimo').style.pointerEvents = "none";
      if (document.querySelector('.delivery-name-colissimo').classList[1] != "delivery-cliked") {
        document.querySelector('.delivery-name-colissimo').classList.add('delivery-cliked');
      }
      
      document.querySelector('.payment-address-btn-colissimo').addEventListener('click', (event) => {
        event.stopImmediatePropagation();
        // if (document.querySelector('.recap-payment-btn') == undefined) {
          // let recapPaymentBtn = document.querySelector('.recap-payment-btn');
          document.querySelector('.recap-payment-colissimo-btn').style.display = "flex";
          // let recapPaymentBtn = '<button type="button" class="recap-payment-btn btn btn-dark">Récapitulatif</button>';
          // document.querySelector('.payment-display-address').insertAdjacentHTML('afterEnd', recapPaymentBtn);
        // }
      });
    });
  }
  

  let pointPickerResult = document.querySelector('.point-picker-result');

  function openServicePointPicker(country, language, postalCode, carriers, servicePointId, postNumber) {

    /**
     * @typedef ConfigurationHash
     * @type {object}
     * @property {string} apiKey - required; replace it below with your API key
     * @property {string} country - required; ISO-2 code of the country you want to display the map (i.e.: NL, BE, DE, FR)
     * @property {?string} postalCode  - not required but recommended
     * @property {?string} language  - not required. Defaults to "en-us"
     * @property {?string} carriers - comma-separated list of carriers you can filter service points
     * @property {?string|?number} servicePointId - set a preselected service point to be shown upon displaying the map
     * @property {?string} postNumber - set a pre-defined post number to fill its corresponding field upon displaying the map
     */

    /**
     * @type {ConfigurationHash}
     */
    var config = {
      apiKey: process.env.SENDCLOUD_API_KEY,
      country: "fr",
      // postalCode: postalCodeField.value,
      language: "fr-fr",
      carriers: "mondial_relay"
      // servicePointId: servicePointId,
      // postNumber: postNumber
    };

    sendcloud.servicePoints.open(

    /* first arg: config object */
    config,
    /**
     * Second argument handles the selection of a service point. It receives two arguments:
     *
     * @param {object} servicePointObject
     * @param {string} postNumber Used as `to_post_number` field in the Parcel creation API
     */
    function (servicePointObject, postNumber) {
      var result = JSON.stringify(servicePointObject, null, 2);
      result = JSON.parse(result);
      document.querySelector('#user_picker_data').value = JSON.stringify(servicePointObject, null, 2);
      if (document.querySelector('#user_picker_data').value != "none")
      {
        document.forms[2].submit();
      }
      const data_picker = `<br><p class="point-picker-result">Votre point relais : ${result.name} - ${result.house_number} ${result.street}, ${result.postal_code} ${result.city}</p>`;
      pointPickerResult.innerHTML = data_picker;
      // if (document.querySelector('.recap-payment-btn') == undefined) {
        // console.log('ok');
        // let recapPaymentBtn = '<button type="button" class="recap-payment-btn btn btn-dark">Récapitulatif</button>';
        // pointPickerResult.insertAdjacentHTML('afterEnd', '<button type="button" class="recap-payment-btn btn btn-dark">Récapitulatif</button>');
      // }

      // resultElem.style.display = 'block';
      // if (document.querySelector("#result").textContent != "") {
      //   document.querySelector("#current_user_result").style.display = "none";
      //   if (document.querySelector("#pay_rails") == undefined)
      //   document.querySelector("#pay_js").style.display = "block";
      // }
    },
    /**
     * third arg: failure callback function
     * this is also called with ["Closed"] when the SPP window is closed.
     */
    function (errors) {
      errors.forEach(function (error) {
        console.log('Failure callback, reason: ' + error);
      });
    });
  }
  // openServicePointPicker();
}

export { pointPicker };
