// STRIPE
// NOTE replaced by Stripe Checkout for now
// const stripe = Stripe("<%= ENV['STRIPE_PUBLIC_TEST'] %>");

// const options = {
//   clientSecret: '<%= @intent.client_secret %>',
//   appearance: {
//     theme: 'flat',
//     rules: {
//       '.Input:hover': {
//         outline: '1px solid rgba(100, 100, 100, 0.25)'
//       },
//     },
//     variables: {
//       colorPrimary: '#0E0E0E',
//       colorText: '#0E0E0E',
//       spacingUnit: '4px',
//       borderRadius: '0',
//       focusBoxShadow: '0 0 0 0.2rem rgba(100, 100, 100, 0.25)'
//     }
//   },
// };

// const elements = stripe.elements(options);
// const paymentElement = elements.create('payment');
// paymentElement.mount('#payment-element');

// const form = document.getElementById('payment-form');

// form.addEventListener('submit', async (e) => {
//   e.preventDefault();

//   const {error} = await stripe.confirmPayment({
//     elements,
//     confirmParams: {
//       return_url: "<%= payment_complete_url + "?sneaker_id=" + @sneaker.id.to_s %>",
//     },
//   });

//   if (error) {
//     const messageContainer = document.querySelector('#error-message');
//     messageContainer.textContent = error.message;
//   }
// })