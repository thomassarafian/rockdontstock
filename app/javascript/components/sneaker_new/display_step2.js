function displayStep2 () {
  let photoPreview = []
  for (let i = 0; i < 8; i++) {
    photoPreview[i] = document.getElementById(`photo-preview${i}`);
  }
  // console.log(photoPreview);
  
  let photoInput = []
  for (let i = 0; i < 8; i++) {
    photoPreview[i].addEventListener('load', (event) => {
      event.preventDefault();
      photoInput[i] = document.querySelector(`.photo-input${i}`);
      photoInput[i].style.backgroundImage = `url(${photoPreview[i].src})`;
      photoInput[i].disabled = true;
      photoInput[i].style.border = "1px solid #1CDD87";
      if (i != 6 && i != 7) {
        document.querySelector(`#sneaker_photo${i}_error`).innerHTML = "";
      }
    });
  }
  return (photoPreview);
}

export { displayStep2 };