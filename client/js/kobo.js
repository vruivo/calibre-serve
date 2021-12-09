/*
  JS file written with a old Javascript version to support older/limited devices.
  
  According with some tests the Javascript version present in Kobo devices web browser is really old
  (no support for fetch, Array.forEach, string template literals, ... )

  Hence this file written in an 'old-fashion'
*/

document.write("Load successfull!");

function search() {
  document.querySelector('#root').innerHTML='search';
  const searchtype = document.querySelector('#type').value;
  if (searchtype === 'book') {
    getBooks(document.querySelector('#searchbox').value);
  }
  if (searchtype === 'tag') {
    getTags(document.querySelector('#searchbox').value);
  }
}

function getBooks(book_title) {
  document.querySelector('#root').innerHTML='get books';
  // fetch(`api/Calibre Library/books/${book_title}`)
  // .then(data => { return data.json() })
  // .then(appendBookSearchResults);
  makeRequest('api/Calibre Library/books/' + book_title, appendBookSearchResults)
}

function appendBookSearchResults(books) {
  document.querySelector('#root').innerHTML='append results';
  for (var x=0; x<books.length; x++){
    // document.querySelector('#root').insertAdjacentHTML('beforeend', '<div>'+books[x].book_title+'</div>');
    document.querySelector('#root').insertAdjacentHTML('beforeend','<div style="border-bottom-style: solid; padding: 20px 0px 20px 10px;border-width: thin;" onclick=divclick(this) data-bookid="'+ books[x].book_id +'">' +
    '<div>'+ books[x].book_title +'</div>' +
    '</div>'
    );
  }
}

function makeRequest(url, callback) {
  const httpRequest = new XMLHttpRequest();
  
  function responseParser() {
    if (httpRequest.readyState === XMLHttpRequest.DONE) {
      if (httpRequest.status === 200) {
        var response = JSON.parse(httpRequest.responseText);
        callback(response);
      } /*else {
        alert('There was a problem with the request.');
      }*/
    }
  }
  
  httpRequest.onreadystatechange = responseParser;
  httpRequest.open('GET', url);
  httpRequest.send();
}

function divclick(element) {
  window.location.href='Calibre%20Library/book/'+ element.getAttribute('data-bookid');
}
