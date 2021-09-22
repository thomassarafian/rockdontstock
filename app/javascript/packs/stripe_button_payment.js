// const paymentButton = document.getElementById('pay');
// if (paymentButton != undefined)
// {
//   paymentButton.addEventListener('click', () => {
//     var stripe = Stripe(process.env.STRIPE_PUBLIC_TEST, {
//     });
//     stripe.redirectToCheckout({
//       sessionId: '<%= @order.checkout_session_id %>'
//     });
//   });
// }