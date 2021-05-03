// const stripe = Stripe(process.env.STRIPE_PUBLIC_TEST); 

// const myForm = document.querySelector('.simple_form.new_user');
// myForm.addEventListener('submit', handleForm);

// async function handleForm(event) {
//   event.preventDefault();
//   const accountResult = await stripe.createToken('account', {
//     business_type: 'individual',
//     individual: {
//       first_name: document.querySelector('#user_first_name').value,
//       last_name: document.querySelector('#user_last_name').value,
//       email: document.querySelector('#user_email').value,
//       phone: "+33606060606",
//       dob: {
//         day: document.querySelector('#user_date_of_birth_3i').value,
//         month: document.querySelector('#user_date_of_birth_2i').value,
//         year: document.querySelector('#user_date_of_birth_1i').value,
//       },
//       address: {
//         line1: document.querySelector('#user_line1').value,
//         city: document.querySelector('#user_city').value,
//         postal_code: document.querySelector('#user_postal_code').value,
//       },
//     },
//     tos_shown_and_accepted: true,
//   });

//   const personResult = await stripe.createToken('person', {
//     person: {
//       first_name: document.querySelector('#user_first_name').value,
//       last_name: document.querySelector('#user_last_name').value,
//       address: {
//         line1: document.querySelector('#user_line1').value,
//         city: document.querySelector('#user_city').value,
//         postal_code: document.querySelector('#user_postal_code').value,
//       },
//     },
//   });
  
//   if (accountResult.token && personResult.token) {
//     document.querySelector('#user_token_account').value = accountResult.token.id;
//     document.querySelector('#user_token_person').value = personResult.token.id;
//     myForm.submit();
//   }
// }