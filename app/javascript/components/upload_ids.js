function uploadIds() {
  const myForm = document.querySelector('.my-form-verification-doc');
  if (myForm) {
    myForm.addEventListener('submit', handleFormTest);
  }

  function handleFormTest(event) {
    console.log('handleFormTest() -> event!!');
    event.preventDefault();
    
    var dataFront = new FormData();
    var dataBack = new FormData();
    var dataHome = new FormData();
    dataFront.append('file', $('#file-front')[0].files[0]);
    dataFront.append('purpose', 'identity_document');
    
    dataBack.append('file', $('#file-back')[0].files[0]);
    dataBack.append('purpose', 'identity_document');

    dataHome.append('file', $('#file-home')[0].files[0]);
    dataHome.append('purpose', 'identity_document');

    $.ajax({
      url: 'https://uploads.stripe.com/v1/files',
      data: dataFront,
      headers: {
        'Authorization': 'Bearer ' + publishableKey,
      },
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
    }).done(function(data) {
      console.log('data->');
      console.log(data);
      document.querySelector('#file-front-hid').value = data.id;
      $.ajax({
        url: 'https://uploads.stripe.com/v1/files',
        data: dataBack,
        headers: {
          'Authorization': 'Bearer ' + publishableKey,
        },
        cache: false,
        contentType: false,
        processData: false,
        type: 'POST',
      }).done(function(data) {
        console.log('data->');
        console.log(data); 
        document.querySelector('#file-back-hid').value = data.id;
        $.ajax({
          url: 'https://uploads.stripe.com/v1/files',
          data: dataHome,
          headers: {
            'Authorization': 'Bearer ' + publishableKey,
          },
          cache: false,
          contentType: false,
          processData: false,
          type: 'POST',
        }).done(async function(data) {
            console.log('data->');
            console.log(data);
            document.querySelector('#file-home-hid').value = data.id;
            if (document.querySelector('#file-home-hid').value && document.querySelector('#file-back-hid').value 
              && document.querySelector('#file-front-hid').value) {
              console.log(document.querySelector('#file-home-hid').value);
              console.log(document.querySelector('#file-front-hid').value);
              console.log(document.querySelector('#file-back-hid').value);

              const accountResult = await stripe.createToken('account', {
                business_type: 'individual',
                individual: {
                  verification: {
                    document: {
                      front: document.querySelector('#file-front-hid').value,
                      back: document.querySelector('#file-back-hid').value
                    },
                    additional_document: {
                      front: document.querySelector('#file-home-hid').value
                    }
                  }, 
                },
                tos_shown_and_accepted: true,
              });
              if (accountResult.token) {
                document.querySelector('#stripe-token-account').value = accountResult.token.id;
                console.log('submit!')
                myForm.submit();
              }
            }     
          });
        });
      });  
      
  };
};
export { uploadIds }