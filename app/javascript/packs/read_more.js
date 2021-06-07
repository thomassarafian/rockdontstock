let read_more_link = document.getElementById("read_more_link");


read_more_link.addEventListener('click', function () {
  read_more()
});

function read_more() {
  let dots = document.getElementById("dots");
  let moreText = document.getElementById("more");
  let linkText = document.getElementById("read_more_link");

  if (dots.style.display === "none") {
    dots.style.display = "inline";
    linkText.innerHTML = "Lire la suite"; 
    moreText.style.display = "none";
  } else {
    dots.style.display = "none";
    linkText.innerHTML = "Lire moins"; 
    moreText.style.display = "inline";
  }
}