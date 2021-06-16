function smellsLikeIban(str){
 return /^([A-Z]{2}[ \-]?[0-9]{2})(?=(?:[ \-]?[A-Z0-9]){9,30}$)((?:[ \-]?[A-Z0-9]{3,5}){2,7})([ \-]?[A-Z0-9]{1,3})?$/.test(str);
}

function validateIbanChecksum(iban) {       
  const ibanStripped = iban.replace(/[^A-Z0-9]+/gi,'') //keep numbers and letters only
                           .toUpperCase(); //calculation expects upper-case
  const m = ibanStripped.match(/^([A-Z]{2})([0-9]{2})([A-Z0-9]{9,30})$/);
  if(!m) return false;
  
  const numbericed = (m[3] + m[1] + m[2]).replace(/[A-Z]/g,function(ch){
                        //replace upper-case characters by numbers 10 to 35
                        return (ch.charCodeAt(0)-55); 
                    });
  const mod97 = numbericed.match(/\d{1,7}/g)
                          .reduce(function(total, curr){ return Number(total + curr)%97},'');

  return (mod97 === 1);
};

const button = document.querySelector('#btn-submit');
const errorElement = document.getElementById("iban-error");

const ibanForm = document.getElementById('user_iban');

button.addEventListener('click', (event) => {
  let message = [];
  user_iban = document.getElementById('user_iban').value;
  if (user_iban != "")
  {
    if (smellsLikeIban(user_iban) == false || validateIbanChecksum(user_iban) == false)
      message.push("L'IBAN n'est pas valide");
    else if (smellsLikeIban(user_iban) == true && validateIbanChecksum(user_iban) == true)
      message.push("L'IBAN est valide !");
    if (message == "L'IBAN n'est pas valide")
    {
      event.preventDefault();
      errorElement.innerText = message.join(', ');
      errorElement.style.color = "red";
      ibanForm.style.border = "solid 0.1em";
      ibanForm.style.borderColor = "red";
      ibanForm.style.boxShadow = "inset 0px 0px 40px 40px #ffb2b2";

    }
    else if (message == "L'IBAN est valide !")
    {
      errorElement.innerText = message.join(', ');
      errorElement.style.color = "green";
      ibanForm.style.border = "solid 0.1em";
      ibanForm.style.borderColor = "green";
      ibanForm.style.boxShadow = "inset 0px 0px 40px 40px #ffffff";
    }
  }
});

