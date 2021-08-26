function editSneakerPhotos () {
  if (document.querySelector('.sneaker-edit')) {
    let editPhotoPreview0 = document.getElementById('photo-preview0');
    let editPhotoPreview1 = document.getElementById('photo-preview1');
    let editPhotoPreview2 = document.getElementById('photo-preview2');
    let editPhotoPreview3 = document.getElementById('photo-preview3');
    let editPhotoPreview4 = document.getElementById('photo-preview4');
    let editPhotoPreview5 = document.getElementById('photo-preview5');
    let editPhotoPreview6 = document.getElementById('photo-preview6');
    let editPhotoPreview7 = document.getElementById('photo-preview7');
    let editPhotoPreview = 0;
    if (editPhotoPreview0 && editPhotoPreview1 && editPhotoPreview2 && editPhotoPreview3 && editPhotoPreview4 && editPhotoPreview5 && editPhotoPreview6 && editPhotoPreview7) {
      editPhotoPreview0.addEventListener('load', (event) => {
        let photoInput0 = document.querySelector('.edit-photo-input0');
        console.log("here")
        console.log(photoInput0)
        photoInput0.style.backgroundImage = `url(${editPhotoPreview0.src})`;
        editPhotoPreview++;
        if (editPhotoPreview == 1) {
          let editSneakerBtn = document.querySelector('.edit-sneaker-btn');
          editSneakerBtn.style.display = "block";
        }
      })
      editPhotoPreview1.addEventListener('load', (event) => {
        let photoInput1 = document.querySelector('.edit-photo-input1');
        photoInput1.style.backgroundImage = `url(${editPhotoPreview1.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview2.addEventListener('load', (event) => {
        let photoInput2 = document.querySelector('.edit-photo-input2');
        photoInput2.style.backgroundImage = `url(${editPhotoPreview2.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview3.addEventListener('load', (event) => {
        let photoInput3 = document.querySelector('.edit-photo-input3');
        photoInput3.style.backgroundImage = `url(${editPhotoPreview3.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview4.addEventListener('load', (event) => {
        let photoInput4 = document.querySelector('.edit-photo-input4');
        photoInput4.style.backgroundImage = `url(${editPhotoPreview4.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview5.addEventListener('load', (event) => {
        let photoInput5 = document.querySelector('.edit-photo-input5');
        photoInput5.style.backgroundImage = `url(${editPhotoPreview5.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview6.addEventListener('load', (event) => {
        let photoInput6 = document.querySelector('.edit-photo-input6');
        photoInput6.style.backgroundImage = `url(${editPhotoPreview6.src})`;
        editPhotoPreview++;
      })
      editPhotoPreview7.addEventListener('load', (event) => {
        let photoInput7 = document.querySelector('.edit-photo-input7');
        photoInput7.style.backgroundImage = `url(${editPhotoPreview7.src})`;
        editPhotoPreview++;
        // if (editPhotoPreview == 9) {
        //   sndNextBtn.style.display = "block";
        //   sndNextBtn.addEventListener('click', (event) => {
        //     photosInput.style.display = "none";
        //     summaryNewSneaker.style.display = "block";
        //   });
        // }
      })
    }
  }
}
export { editSneakerPhotos };