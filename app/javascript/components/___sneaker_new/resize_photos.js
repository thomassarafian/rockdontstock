function fetchPhotos(opti_photos) {
  let data = new FormData($("form[id*='newSneakerForm']")[0]);
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
}

function resizePhotos () {
  let opti_photos = [];
  let file0 = document.getElementById('photo-input0').files[0];
  let fileImage0 = document.getElementById('photo-input0').style.backgroundImage.replace(/(url\(|\)|")/g, '');  
  
  let file1 = document.getElementById('photo-input1').files[0];
  let fileImage1 = document.getElementById('photo-input1').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  
  let file2 = document.getElementById('photo-input2').files[0];
  let fileImage2 = document.getElementById('photo-input2').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  
  let file3 = document.getElementById('photo-input3').files[0];
  let fileImage3 = document.getElementById('photo-input3').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  
  let file4 = document.getElementById('photo-input4').files[0];
  let fileImage4 = document.getElementById('photo-input4').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  
  let file5 = document.getElementById('photo-input5').files[0];
  let fileImage5 = document.getElementById('photo-input5').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  
  let file = [file0, file1, file2, file3, file4, file5];
  let fileImages = [fileImage0, fileImage1, fileImage2, fileImage3, fileImage4, fileImage5];
  
  let file6 = document.getElementById('photo-input6').files[0];
  let fileImage6 = document.getElementById('photo-input6').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  if (file6 && fileImage6) {
    file.push(file6);
    fileImages.push(fileImage6);
  }
  let file7 = document.getElementById('photo-input7').files[0];
  let fileImage7 = document.getElementById('photo-input7').style.backgroundImage.replace(/(url\(|\)|")/g, '');
  if (file7) {
    file.push(file7);
    fileImages.push(fileImage7);
  }

  setTimeout(function() {
  for (let i = 0; i < file.length; i++) {
      if (file[i].type.match('image/jpg') || file[i].type.match('image/jpeg') || file[i].type.match('image/png')) {
        // console.log('An image has been loaded');
        // Load the image
        var reader = new FileReader();
        // reader.onload = async function (readerEvent) {
          var image = new Image();
          image.src = fileImages[i]
          // image.onload =  function (imageEvent) {
            // Resize the image
            // console.log('image loaded !')
            var canvas = document.createElement('canvas'),
              max_size = 1000,
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
            // console.log('go trigger event');
            $.event.trigger({
                type: "resizeImg",
                blob: resizedImage,
                url: dataUrl
            });
          // }
          image.src = fileImages[i];
          // image.src = readerEvent.target.result;;
        // }
        reader.readAsDataURL(file[i]);
      }
  }
}, 7000);

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

  $(document).on("resizeImg", function (event) {
    event.preventDefault();
    // console.log("Uploaded the photo and pushed to opti photos ");
    // if (event.blob && event.url) {
      // console.log(event);
      opti_photos.push(event.blob);
    // }

    if (opti_photos.length == file.length) {
      fetchPhotos(opti_photos);
    }
  });
}

export { resizePhotos };
