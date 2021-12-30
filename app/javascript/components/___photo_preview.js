const previewImageOnFileSelect = () => {
  const input0 = document.getElementById('photo-input0');
  const input1 = document.getElementById('photo-input1');
  const input2 = document.getElementById('photo-input2');
  const input3 = document.getElementById('photo-input3');
  const input4 = document.getElementById('photo-input4');
  const input5 = document.getElementById('photo-input5');
  const input6 = document.getElementById('photo-input6');
  const input7 = document.getElementById('photo-input7');
  if (input0) {
    input0.addEventListener('change', () => {
      displayPreview0(input0);
    })
  }
  if (input1) {
    input1.addEventListener('change', () => {
      displayPreview1(input1);
    })
  }
  if (input2) {
    input2.addEventListener('change', () => {
      displayPreview2(input2);
    })
  }
  if (input3) {
    input3.addEventListener('change', () => {
      displayPreview3(input3);
    })
  }
  if (input4) {
    input4.addEventListener('change', () => {
      displayPreview4(input4);
    })
  }
  if (input5) {
    input5.addEventListener('change', () => {
      displayPreview5(input5);
    })
  }
  if (input6) {
    input6.addEventListener('change', () => {
      displayPreview6(input6);
    })
  }
  if (input7) {
    input7.addEventListener('change', () => {
      displayPreview7(input7);
    })
  }
}

const displayPreview0 = (input) => {
  if (input.files && input.files[0]) {
    // console.log(input.files[0])
    const reader = new FileReader();
    // console.log(reader)
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview0').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    // console.log(reader)
    // document.getElementById('photo-preview0').classList.remove('hidden');
  }
}
const displayPreview1 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
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
      event.preventDefault();
      document.getElementById('photo-preview2').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview2').classList.remove('hidden');
  }
}
const displayPreview3 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview3').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview3').classList.remove('hidden');
  }
}
const displayPreview4 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview4').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview4').classList.remove('hidden');
  }
}
const displayPreview5 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview5').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview5').classList.remove('hidden');
  }
}
const displayPreview6 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview6').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview6').classList.remove('hidden');
  }
}

const displayPreview7 = (input) => {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = (event) => {
      event.preventDefault();
      document.getElementById('photo-preview7').src = event.currentTarget.result;
    }
    reader.readAsDataURL(input.files[0])
    document.getElementById('photo-preview7').classList.remove('hidden');
  }
}

previewImageOnFileSelect();

export { previewImageOnFileSelect };
