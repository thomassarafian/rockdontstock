const previewImageOnFileSelect = () => {
  // we select the photo input
  const input0 = document.getElementById('photo-input0');
  const input1 = document.getElementById('photo-input1');
  const input2 = document.getElementById('photo-input2');
  if (input0) {
    // we add a listener to know when a new picture is uploaded
    input0.addEventListener('change', () => {
      // we call the displayPreview function (who retrieve the image url and display it)
      displayPreview0(input0);
    })
  }
  if (input1) {
    // we add a listener to know when a new picture is uploaded
    input1.addEventListener('change', () => {
      // we call the displayPreview function (who retrieve the image url and display it)
      displayPreview1(input1);
    })
  }
  if (input2) {
    // we add a listener to know when a new picture is uploaded
    input2.addEventListener('change', () => {
      // we call the displayPreview function (who retrieve the image url and display it)
      displayPreview2(input2);
    })
  }
}

const displayPreview0 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      document.getElementById('photo-preview0').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview0').classList.remove('hidden');
  }
}
const displayPreview1 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      document.getElementById('photo-preview1').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview1').classList.remove('hidden');
  }
}

const displayPreview2 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      document.getElementById('photo-preview2').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview2').classList.remove('hidden');
  }
}
previewImageOnFileSelect();

export { previewImageOnFileSelect };
