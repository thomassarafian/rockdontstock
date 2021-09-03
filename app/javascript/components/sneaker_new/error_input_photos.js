function errorInputPhotos() {
  let errorPhotoInput = 6;
  if (document.querySelector('.photo-input0').value === '') {
    document.querySelector('.photo-input0').style.border = "1px solid red";
    document.querySelector('#sneaker_photo0_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input0').style.border = "1px solid #1CDD87";
    document.querySelector('#sneaker_photo0_error').innerHTML = "";
    errorPhotoInput--;
  }
  if (document.querySelector('.photo-input1').value === '') {
    document.querySelector('.photo-input1').style.border = "1px solid red";
    document.querySelector('#sneaker_photo1_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input1').style.border = "1px solid #1CDD87";
    errorPhotoInput--;
  }
  if (document.querySelector('.photo-input2').value === '') {
    document.querySelector('.photo-input2').style.border = "1px solid red";
    document.querySelector('#sneaker_photo2_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input2').style.border = "1px solid #1CDD87";
    errorPhotoInput--;
  }
  if (document.querySelector('.photo-input3').value === '') {
    document.querySelector('.photo-input3').style.border = "1px solid red";
    document.querySelector('#sneaker_photo3_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input3').style.border = "1px solid #1CDD87";
    errorPhotoInput--;
  }
  if (document.querySelector('.photo-input4').value === '') {
    document.querySelector('.photo-input4').style.border = "1px solid red";
    document.querySelector('#sneaker_photo4_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input4').style.border = "1px solid #1CDD87";
    errorPhotoInput--;
  }
  if (document.querySelector('.photo-input5').value === '') {
    document.querySelector('.photo-input5').style.border = "1px solid red";
    document.querySelector('#sneaker_photo5_error').innerHTML = "<small>Photo obligatoire</small>"
  } else {
    document.querySelector('.photo-input5').style.border = "1px solid #1CDD87";
    errorPhotoInput--;
  }
  return (errorPhotoInput);
}

export { errorInputPhotos };