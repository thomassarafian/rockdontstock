const stripe = Stripe(process.env.STRIPE_PUBLIC_TEST); 

const myForm = document.querySelector('.simple_form.new_user');
myForm.addEventListener('submit', handleForm);

async function handleForm(event) {
  event.preventDefault();
  const accountResult = await stripe.createToken('account', {
    business_type: 'individual',
    individual: {
      first_name: "Damien",//document.querySelector('.user_first_name').value,
      last_name: "Nicolas",
      email: "thomassarafian@gmail.com",
      phone: "+33606079811",
      dob: {
        day: 12,
        month: 10,
        year: 1997,
      },
      address: {
        line1: "11 rue Hotel de Ville", //document.querySelector('.inp-company-street-address1').value,
        city: "Lyon",//document.querySelector('.inp-company-city').value,
        postal_code: "69001",//document.querySelector('.inp-company-zip').value,
        // state: document.querySelector('.inp-company-state').value,
      },
    },
    tos_shown_and_accepted: true,
  });

  const personResult = await stripe.createToken('person', {
    person: {
      first_name: "Damien", //document.querySelector('.user_first_name').value,
      last_name: "Nicolas", //document.querySelector('.user_last_name').value,
      address: {
        line1:  "11 rue Hotel de Ville",//document.querySelector('.inp-person-street-address1').value,
        city: "Lyon",//document.querySelector('.inp-person-city').value,
        postal_code: "69001",//document.querySelector('.inp-person-zip').value,
        // state: document.querySelector('.inp-person-state').value,
      },
    },
  });
  
  if (accountResult.token && personResult.token) {
    document.querySelector('#user_token_account').value = accountResult.token.id;
    document.querySelector('#user_token_person').value = personResult.token.id;
    myForm.submit();
  }
}