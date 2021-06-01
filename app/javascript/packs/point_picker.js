var resultElem = document.getElementById('result'),
    postResultElem = document.getElementById('postResult'),
    postalCodeField = document.getElementById('user_postal_code'),
    select_point_picker = document.getElementById('select_point_picker')


// select_point_picker.addEventListener('click', function () {
//   openServicePointPicker("fr", "fr-fr");
// });

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
      document.forms[1].submit();
    }
    const data_picker = `<p>Votre point relais : ${result.name} - ${result.house_number} ${result.street}, ${result.postal_code} ${result.city}</p>`;
    resultElem.innerHTML = data_picker;
    resultElem.style.display = 'block';
    if (document.querySelector("#result").textContent != "") {
      document.querySelector("#current_user_result").style.display = "none";
      if (document.querySelector("#pay_rails") == undefined)
      document.querySelector("#pay_js").style.display = "block";
    }
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

export { openServicePointPicker };
