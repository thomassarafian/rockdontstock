function createStripeTokenEditUser() {
  const editUserForm = document.querySelector('#edit_user_form');
  if (editUserForm) {
    const stripe = Stripe('pk_live_51IcAgiE0gVjPTo06ziMfiQyCjUBf55UxtqKRguncXYvXEMsyv2q4e1IHus9q1ZWhhfWfOP0uoiMNzMEZJDtOuGmS00ZDsAYrqA');
    document.querySelector('.edit-user-btn').addEventListener('click', (event) => {
      event.preventDefault();
      // let user_email = document.querySelector('#user_email');
      // let user_first_name = document.querySelector('#user_first_name').value;
      // let user_last_name = document.querySelector('#user_last_name').value;
      let user_phone = document.querySelector('#user_phone');
      
      let user_line1 = document.querySelector('#user_line1');
      let hide_user_line1 = document.querySelector('#hide_user_line1').value;
      let user_city = document.querySelector('#user_city').value;
      let user_postal_code = document.querySelector('#user_postal_code').value;

      let user_date_of_birth_input = document.querySelector('#user_date_of_birth');
      let user_date_of_birth = document.querySelector('#user_date_of_birth').value.split('-');
      let user_year = user_date_of_birth[0];
      let user_month = user_date_of_birth[1];
      let user_day = user_date_of_birth[2];
      let errorEditUser = 3;
      if (user_phone.value.length != 10) {
        user_phone.classList.add('is-invalid');
        document.querySelector('#edit_user_phone_error').innerHTML = "<small>Numéro de téléphone invalide</small>";
        errorEditUser--;
      } else {
        user_phone.classList.remove('is-invalid');
        user_phone.classList.add('is-valid');
        document.querySelector('#edit_user_phone_error').innerHTML = "";
      }
      if (!user_year || !user_month || !user_day) {
        user_date_of_birth_input.classList.add('is-invalid');
        document.querySelector('#edit_user_date_of_birth_error').innerHTML = "<small>Date de naissance invalide</small>";
        errorEditUser--;
      } else {
        user_date_of_birth_input.classList.remove('is-invalid');
        user_date_of_birth_input.classList.add('is-valid');
        document.querySelector('#edit_user_date_of_birth_error').innerHTML = "";
      }
      
      if (!user_line1.value) {
        user_line1.classList.add('is-invalid');
        document.querySelector('#edit_user_line1_error').innerHTML = "<small>Adresse invalide</small>";
        errorEditUser--;
      } else {
        user_line1.classList.remove('is-invalid');
        user_line1.classList.add('is-valid');
        document.querySelector('#edit_user_line1_error').innerHTML = "";
      }
      if (errorEditUser == 3) {
        editUserForm.addEventListener('click', handleForm);
      }
    });

    async function handleForm(event) {
      event.preventDefault();
      let user_email = document.querySelector('#user_email').value;
      let user_first_name = document.querySelector('#user_first_name').value;
      let user_last_name = document.querySelector('#user_last_name').value;
      let user_phone = document.querySelector('#user_phone').value;
      let hide_user_line1 = document.querySelector('#hide_user_line1').value;
      let user_city = document.querySelector('#user_city').value;
      let user_postal_code = document.querySelector('#user_postal_code').value;
      let user_date_of_birth = document.querySelector('#user_date_of_birth').value.split('-');
      let user_year = user_date_of_birth[0];
      let user_month = user_date_of_birth[1];
      let user_day = user_date_of_birth[2];
      // let errorEditUser = 5;

      

      // if (errorEditUser == 5) {   
        // console.log("victoyr!!");
        const accountResult = await stripe.createToken('account', {
          business_type: 'individual',
          individual: {
            email: user_email,
            first_name: user_first_name,
            last_name: user_last_name,
            phone: `+33${user_phone}`,
            address: {
              line1: hide_user_line1,
              city: user_city,
              postal_code: user_postal_code,
            },
            dob: {
              day: user_day,
              month: user_month,
              year: user_year,
            }
          },
          tos_shown_and_accepted: true,
        });
        const personResult = await stripe.createToken('person', {
          person: {
            email : user_email,
            first_name: user_first_name,
            last_name: user_last_name,
            phone: `+33${user_phone}`,
            address: {
              line1: hide_user_line1,
              city: user_city,
              postal_code: user_postal_code,
            },
            dob: {
              day: user_day,
              month: user_month,
              year: user_year,
            },
          },
        });
        if (accountResult.token && personResult.token) {
          document.querySelector('#stripe-token-account').value = accountResult.token.id;
          document.querySelector('#stripe-token-person').value = personResult.token.id;
          editUserForm.submit();
        }
      // } 
      // else {
        
      // }
    }
  }
}

export { createStripeTokenEditUser };