function createStripeTokenDocument() {
  const verificationDocForm = document.querySelector('.my-form-verification-doc');
  if (verificationDocForm) {
    console.log('ok');
    const stripe = Stripe('pk_live_51IcAgiE0gVjPTo06ziMfiQyCjUBf55UxtqKRguncXYvXEMsyv2q4e1IHus9q1ZWhhfWfOP0uoiMNzMEZJDtOuGmS00ZDsAYrqA');
    document.querySelector('.btn-send-documents').addEventListener('click', (event) => {
      event.preventDefault();
      
      let file_front = document.querySelector('#file-front');
      let file_back = document.querySelector('#file-back');
      let file_home = document.querySelector('#file-home');
      

      if (file_front.files && file_back.files && file_home.files) {
        console.log('handleForm event!');
        verificationDocForm.addEventListener('click', handleForm);
      }
    });

    async function handleForm(event) {
      event.preventDefault();
      let file_front_val = document.querySelector('#file-front').files[0];
      let file_back_val = document.querySelector('#file-back').files[0];
      let file_home_val = document.querySelector('#file-home').files[0];
      
      const accountResult = await stripe.createToken('account', {
        business_type: 'individual',
        individual: {
          verification: {
            document: {
              front: 'file_front_val',
              back: 'file_back_val',
            },
            additional_document: {
              front: 'file_home_val'
            }
          }, 
        },
        tos_shown_and_accepted: true,
      });
        // const personResult = await stripe.createToken('person', {
        //   person: {
        //     email : user_email,
        //     first_name: user_first_name,
        //     last_name: user_last_name,
        //     phone: `+33${user_phone}`,
        //     address: {
        //       line1: hide_user_line1,
        //       city: user_city,
        //       postal_code: user_postal_code,
        //     },
        //     dob: {
        //       day: user_day,
        //       month: user_month,
        //       year: user_year,
        //     },
        //   },
        // });
        if (accountResult.token) { //&& personResult.token) {
          document.querySelector('#stripe-token-account').value = accountResult.token.id;
          console.log('submit!')
          // document.querySelector('#stripe-token-person').value = personResult.token.id;
          verificationDocForm.submit();
        }
      // } 
      // else {
        
      // }
    }
  }
}

export { createStripeTokenDocument };