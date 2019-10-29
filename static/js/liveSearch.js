// The first key the Application ID, the second is the Search-Only Key
// Both are safe to be in source control ;)

// const search = instantsearch({
//     appId: '04HSGXXQD5',
//     apiKey: 'a7ec2763a5d966a5b9f8d70b254bfb68',
//     indexName: 'sheldonhull',
//     urlSync: true
//   });

const algolia = algoliasearch("04HSGXXQD5", "a7ec2763a5d966a5b9f8d70b254bfb68");
const algoliaIndex = algolia.initIndex("sheldonhull");


algoliaIndex.setSettings({
  removeWordsIfNoResults: 'none',
  highlightPreTag: '<em class="search-highlight">',
  snippetEllipsisText: '…',
  attributesToHighlight: [
    'title',
    'content'
  ]
});

var $results
var downcount = 0;
var selectedSearchLink = '#';
var url_string = window.location.href;
var urlParam = url_string.indexOf("?search");
var search_url = new URL(url_string);
var url_query = search_url.searchParams.get("search");

// show search overlay on load if search params in URL
if (urlParam >= 0) {
  $('#search').val(url_query).focus();
  $('.search-icon').addClass('active');
  $('#search-overlay').addClass('active');
}

// adds listener on the input field
function initUI() {

  $results = $("#results");

  var ctrlDown = false,
  ctrlKey = 17,
  cmdKey = 91,
  vKey = 86,
  cKey = 67,
  escKey = 27,
  downArrow = 40,
  upArrow = 38,
  enterKey = 13;

  $(document).keydown(function(e) {
    if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = true;
  }).keyup(function(e) {
    if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = false;

    if ($('.page input:focus, .footer input:focus, .page textarea:focus, .footer textarea:focus, .page select:focus, .footer select:focus').length === 0) {
      $results.empty();

      var downSelected    = false;
      var clearSelected   = false;

      if ($('#search-overlay').hasClass('active')) {
        if (e.keyCode === escKey) {        // esc key clicked
          $('#search-overlay').removeClass('active');
        }
        if (e.keyCode === downArrow) { // down arrow clicked
          downSelected = true;
        }
        if (e.keyCode !== downArrow && e.keyCode !== upArrow) {
          clearSelected = true;
        }
        if (e.keyCode === enterKey && $('#results li.selected')) {
          window.location.href = selectedSearchLink;
        }
      }

      var query = $('#search').val();

      if (query.length > 0) {
        $('#clear-search').addClass('active');
      } else {
        $('#clear-search').removeClass('active');
      }

      if (query.length < 1) {
        return;
      }

      search(query, downSelected, clearSelected);
    }
  });
}

function search(query, downSelected, clearSelected) {
  return algoliaIndex.search(query, function(err, content) {
    renderResults(content.hits, query, downSelected, clearSelected);
  });
}

function renderResults(results, query, downSelected, clearSelected) {
  if (results && !results.length) {
    $results.append("<p class='no-results'>Unfortunately, we can't find '" + query + "' - perhaps <a class='text-link' target='_blank' href='https://google.com'>The Internet</a> has what you're looking for?</p>");
    return;
  }

  var pages = [],
      blog = [];

  // sort results into 3 categories
  var sectionsInPages = ["", "products", "values", "contact"];
  var sectionsInArticles = ["post"];

  if (results !== undefined) {
    results.forEach(function(result) {
      // if (result.section === ['', 'press', 'pricing', 'support', 'tags'] || result.section === (result.title).toLowerCase() || result.title === 'Site of the Week') {
      if (sectionsInPages.indexOf(result.section) > -1 || result.section === (result.title).toLowerCase()) {
        pages.push(result);
      } else if (sectionsInArticles.indexOf(result.section) > -1) {
        blog.push(result);
      }
    });

    if (pages.length) {
      $results.append("<ul class='pages-results search-column'><li class='section-label'>Pages</li></ul>");
    }
    pages.slice(0, 7).forEach(function(result) {
      var $result = $("<li>");
      $result.append($("<a>", {
        href: result.href,
        text: decodeHtml(result.title)
      }));
      $('.pages-results').append($result);
    });

    if (blog.length) {
      $results.append("<ul class='blog-results search-column'><li class='section-label'>Articles</li></ul>");
    }
    blog.slice(0, 7).forEach(function(result) {
      var $result = $("<li>");
      $result.append(createLink(result));
      $('.blog-results').append($result);
    });

    if (clearSelected) {
      downcount = 0;
    }

    if (downSelected) {

      if (downcount > 0 ) {
        $('#results li:not(.section-label)').eq(downcount).addClass('selected');
      } else {
        $('#results li:not(.section-label)').first().addClass('selected');
      }
      selectedSearchLink = $('#results li:not(.section-label).selected a').attr('href');

      if ($('#results li:not(.section-label)').last().hasClass('selected') || downcount < 0) {
        downcount = 0;
      } else {
        downcount++;
      }
    }

    function decodeHtml(html) {
      var txt = document.createElement("textarea");
      txt.innerHTML = html;
      return txt.value;
    }
    function createLink(html) {
      var a = document.createElement("a");
      a.innerHTML = html._snippetResult.content.value;
      a.href = html.href;
      return a;
    }
  }
}

$(document).ready(function() {
  initUI();
});

$('#clear-search').click(function() {
  $('#search').val('').focus();
  $(this).removeClass('active');
  $('.search-column').remove();
});

$('.search-button').click(function() {
  $('.search-icon').toggleClass('active');
  $('#search-overlay').toggleClass('active');

  if ($('#search-overlay').hasClass('active')) {
    window.scrollTo(0, 0);
    $('#search').focus();
  }

  if ($('.landing.page').length) {
    if ($('#search-overlay').hasClass('active')) {
      $('#header').removeClass('centered');
    } else {
      $('#header').addClass('centered');
    }
  }
});