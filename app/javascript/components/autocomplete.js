import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

const autocompleteSearch = function() {
  const sneakerDb = JSON.parse(document.getElementById('search-data').dataset.sneakerDb)

  
  const searchInput = document.getElementById('q');

  if (sneakerDb && searchInput) {
    new autocomplete({
      selector: searchInput,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          const choices = sneakerDb;
          const matches = [];
          for (let i = 0; i < choices.length; i++)
              if (~choices[i][0].toLowerCase().indexOf(term)) matches.push(choices[i][0]);
          suggest(matches);
      },
      renderItem: function (item, search){
        const choices = sneakerDb;
        // console.log(item);
        // console.log(choices);
        // console.log(choices[item]);
        search = search.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
        var re = new RegExp("(" + search.split(' ').join('|') + ")", "gi");
        for (let i = 0; i < choices.length; i++) {
          return '<div class="design-search-bar autocomplete-suggestion" data-val="' + item + '">' + '<img class="search-img"style="width:50px;" src=' + choices[i][1] +  '>' +item.replace(re, "<b>$1</b>") + '</div>';
        }
      },
      // renderItem: function (item, search){
      //   // search = search.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
      //   // var re = new RegExp("(" + search.split(' ').join('|') + ")", "gi");
      //   return '<div class="autocomplete-suggestion"> <img style="width:50px;" src="https://images.unsplash.com/photo-1593642532400-2682810df593?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80">' + item + '</div>';
      // },
    });
  }
};


  autocompleteSearch();

export { autocompleteSearch };
