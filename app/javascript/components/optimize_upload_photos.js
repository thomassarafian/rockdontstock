function optimizeUploadPhotos() {
  let opti_photos = []
  window.uploadPhotos = function(url){
    var file = event.target.files[0];

    // Ensure it's an image
    if(file.type.match(/image.*/)) {
        console.log('An image has been loaded');

        // Load the image
        var reader = new FileReader();
        reader.onload = function (readerEvent) {
            var image = new Image();
            image.onload = function (imageEvent) {

                // Resize the image
                var canvas = document.createElement('canvas'),
                    max_size = 720,// TODO : pull max size from a site config
                    width = image.width,
                    height = image.height;
                if (width > height) {
                    if (width > max_size) {
                        height *= max_size / width;
                        width = max_size;
                    }
                } else {
                    if (height > max_size) {
                        width *= max_size / height;
                        height = max_size;
                    }
                }
                canvas.width = width;
                canvas.height = height;
                canvas.getContext('2d').drawImage(image, 0, 0, width, height);
                var dataUrl = canvas.toDataURL('image/jpeg');
                var resizedImage = dataURLToBlob(dataUrl);
                $.event.trigger({
                    type: "totoEoh",
                    blob: resizedImage,
                    url: dataUrl
                });
            }
            image.src = readerEvent.target.result;
        }
        reader.readAsDataURL(file);
    }
};

var dataURLToBlob = function(dataURL) {
  var BASE64_MARKER = ';base64,';
  if (dataURL.indexOf(BASE64_MARKER) == -1) {
      var parts = dataURL.split(',');
      var contentType = parts[0].split(':')[1];
      var raw = parts[1];
      return new Blob([raw], {type: contentType});
  }
  var parts = dataURL.split(BASE64_MARKER);
  var contentType = parts[0].split(':')[1];
  var raw = window.atob(parts[1]);
  var rawLength = raw.length;
  var uInt8Array = new Uint8Array(rawLength);
  for (var i = 0; i < rawLength; ++i) {
      uInt8Array[i] = raw.charCodeAt(i);
  }

  return new Blob([uInt8Array], {type: contentType});
}

  $(document).on("totoEoh", function (event) {
    console.log("Uploaded the photo and pushed to opti photos ");
    if (event.blob && event.url) {
        opti_photos.push(event.blob);
    }
  });
  if (document.querySelector('.snd-next-btn')) {
    document.querySelector('.snd-next-btn').addEventListener('click', (e) => {
      var data = new FormData($("form[id*='newSneakerForm']")[0]);
      console.log("On crée data !")
      data.append('sneaker[size]', document.getElementById('sneaker_size').value);
      data.append('sneaker[condition]', document.getElementById('sneaker_condition').value);
      data.append('sneaker[box]', document.getElementById('sneaker_box').value);
      data.append('sneaker[extras]', document.getElementById('sneaker_extras').value);
      data.append('sneaker[price]', document.getElementById('sneaker_price').value);
      opti_photos.forEach(elem => {
        data.append('sneaker[photos][]', elem);
      });
      fetch(document.getElementById('new_sneaker').action, {
        method: "POST",
        body: data,
      })
    });
  }

}
export { optimizeUploadPhotos };