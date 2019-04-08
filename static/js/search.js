function loadIndexJson(e) {
  var r = new XMLHttpRequest();
  r.overrideMimeType("application/json"),
  r.open("GET", "/index.json", !0),
  (r.onreadystatechange = function () {
    4 == r.readyState && e(
      "200" == r.status
      ? JSON.parse(r.responseText)
      : null);
  }),
  r.send(null);
}

function addToSearchIndex(e, r) {
  return function (n) {
    n
      ? n.forEach(function (n) {
        e.add(n),
        (r[n.ref] = n.title);
      })
      : (e.error = !0);
  };
}

function registerSearchHandler(e, r, n, o, t, c) {
  Array.prototype.slice.call(document.querySelectorAll(n)).forEach(function (n) {
    n.onclick = function (n) {
      n.preventDefault(),
      showSearchPage(e, r, o, t, c);
    };
  });
}

function showSearchPage(e, r, n, o, t) {
  (document.querySelector(n).style.display = "block"),
  e.error
    ? renderSearchError(t)
    : (document.querySelector(o).focus(), (document.querySelector(o).oninput = function (n) {
      var o = n.target.value;
      if ("" === o)
        renderSearchResults(r, t, null);
      else {
        var c = e.search(o);
        renderSearchResults(r, t, c);
      }
    }), (document.querySelector("#search-close").onclick = function (e) {
      e.preventDefault(),
      hideSearchPage(n, o, t);
    }), (document.onkeyup = function (e) {
      isKeyEscapeKeyPress(e) && (e.preventDefault(), hideSearchPage(n, o, t));
    }));
}

function isKeyEscapeKeyPress(e) {
  return "key" in e
    ? "Escape" == e.key || "Esc" == e.key
    : 27 == e.keyCode;
}

function hideSearchPage(e, r, n) {
  (document.querySelector(e).style.display = "none"),
  (document.querySelector(r).oninput = null),
  (document.querySelector(r).value = ""),
  renderSearchResults(null, n, null),
  (document.onkeyup = null);
}

function renderSearchError(e) {
  document.querySelector(e).innerHTML = '<p class="index-error">Sorry, there was a problem loading search. Please try reloading the page.</p>';
}

function renderSearchResults(e, r, n) {
  if (null == n)
    return void(document.querySelector(r).innerHTML = "");
  if (0 === n.length)
    return void(document.querySelector(r).innerHTML = '<p class="no-results">Nothing found for that query.</p>');
  var o = "<ul>";
  n.forEach(function (r) {
    o += '<li><a href="' + r.ref + '">' + e[r.ref] + "</a></li>";
  }),
  (o += "</ul>"),
  (document.querySelector(r).innerHTML = o);
}
var searchIndex = lunr(function () {
    this.field("title", {boost: 10}),
    this.field("tags", {boost: 5}),
    this.field("content"),
    this.ref("ref");
  }),
  searchTitles = {};
registerSearchHandler(searchIndex, searchTitles, ".search-trigger", "#search-overlay", "#search-input", "#search-results"),
loadIndexJson(addToSearchIndex(searchIndex, searchTitles));
