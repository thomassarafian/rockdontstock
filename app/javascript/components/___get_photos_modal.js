function getPhotosModal() {
  let sneakerCardImg = $(".sneaker-card_img").each(function( index ) {});
  for (let i = 0; i < sneakerCardImg.length; i++) {
    sneakerCardImg[i].addEventListener('click', (event) => {
      event.preventDefault();
      if (sneakerCardImg[i].dataset.target) {
        let sneaker_id_card = sneakerCardImg[i].dataset.target.split('-')[3];
        let sneaker_data_target = sneakerCardImg[i].dataset.target.replace('#modal','carousel');
        $(".carousel-inner").load(`modal_bootstrap?sneaker_id=${sneaker_id_card}&sneaker_target=${sneaker_data_target} #spox-game`, function(response, status, xhr) {
        });
      }
    })
  }
}

export { getPhotosModal };