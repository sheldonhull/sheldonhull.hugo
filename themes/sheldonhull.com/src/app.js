/* global algoliasearch instantsearch */

const searchClient = algoliasearch('04HSGXXQD5', 'a7ec2763a5d966a5b9f8d70b254bfb68');

const search = instantsearch({
  indexName: 'sheldonhull.com',
  searchClient,
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#searchbox',
  }),
  instantsearch.widgets.hits({
    container: '#hits',
    templates: {
      item: `
<article>
  <h1>{{#helpers.highlight}}{ "attribute": "title" }{{/helpers.highlight}}</h1>
</article>
`,
    },
  }),
  instantsearch.widgets.pagination({
    container: '#pagination',
  }),
]);

search.start();
