// const search = instantsearch({
// indexName: 'sheldonhull',
// searchClient: algoliasearch(
// '04HSGXXQD5',
// 'a7ec2763a5d966a5b9f8d70b254bfb68'),
// poweredBy: true,

// stalledSearchDelay: 500

// });
const searchClient = algoliasearch('04HSGXXQD5', 'a7ec2763a5d966a5b9f8d70b254bfb68');

const search = instantsearch({
    indexName: 'sheldonhull.com',
    searchClient,
    searchFunction(helper) {
        const container = document.querySelector('#hits');
        container.style.display = helper.state.query === '' ? 'none' : '';
        container.classList.add('no-results')
        helper.search();
    }
    , attributesToHighlight: [
        'attribute',
        '*' // returns all attributes in the index not just searchable attributes
    ], attributesToSnippet: [
        'attribute','title','tags','summary'
    ]
});

search.addWidget(
    instantsearch.widgets.hits({
        container: '#hits',
        templates: {
            item: `
        <a href="{{url}}">
        <li>
          <img src="{{image}}" align="left" alt="{{name}}" />
          <span class="hit-title">
            {{#helpers.highlight}}{ "attribute": "title" }{{/helpers.highlight}}
          </span>
          <span class="hit-description">{{summary}}
            {{#helpers.highlight}}{ "attribute": "summary" }{{/helpers.highlight}}
          </span>
          <span class="hit-tags">{{tags}}</span>
        </li>
        </a>
      `,
        },

    })


);

search.addWidgets([
    instantsearch.widgets.searchBox({
        container: document.querySelector('#searchbox'),
        autofocus: true
   })
])

search.addWidgets([
    instantsearch.widgets.hits({
        container: document.querySelector('#hits'),
        templates: {
            empty: '<div>No results have been found for {{ query }}</div>.',
            item: `
                        <article>
                        <p>Name: {{#helpers.highlight}}{ "attribute": "name", "highlightedTagName": "mark" }{{/helpers.highlight}}</p>
                        <p>Description: {{#helpers.snippet}}{ "attribute": "description", "highlightedTagName": "mark" }{{/helpers.snippet}}</p>
                        </article>
                    `
            , item(hit) {
                return `
          <article>
            <p>Name: ${instantsearch.highlight({ attribute: 'name', highlightedTagName: 'mark', hit })}</p>
            <p>Name: ${instantsearch.snippet({ attribute: 'name', highlightedTagName: 'mark', hit })}</p>
          </article>
        `;
            }
        }
    })
]);

search.start();
