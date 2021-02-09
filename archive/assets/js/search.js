// // document.addEventListener("DOMContentLoaded", function (event) {
// // const search = instantsearch({
// //     indexName: '{{ $.Site.Params.search.algolia.index_name }}',
// //     searchClient: algoliasearch(
// //         '{{ $.Site.Params.search.algolia.app_id }}',
// //         '{{ $.Site.Params.search.algolia.api_key }}'),
// //     poweredBy: '{{ $.Site.Params.search.algolia.show_logo }}',
// //     urlSync: true,
// //     stalledSearchDelay: 500

// // });

// const search = instantsearch({
//     indexName: 'sheldonhull',
//     searchClient: algoliasearch(
//         '04HSGXXQD5',
//         'a7ec2763a5d966a5b9f8d70b254bfb68'),
//     poweredBy: true,
//     urlSync: true,
//     stalledSearchDelay: 500

// });

// // const MySearchBox = connectSearchBox(({ onFocus, onBlur, currentRefinement, refine }) => {
// //     return (

// //         <input
// //             type="text"
// //             id="searchbox"
// //             autocomplete="off"
// //             placeholder="Search"
// //             class="search-input"
// //             value={currentRefinement}
// //             onFocus={() => onFocus()}
// //             onBlur={() => onBlur()}
// //             onChange={e => {
// //                 refine(e.target.value);
// //             }}
// //         />
// //     );
// // });


// // // 1. Create a render function
// // const renderSearchBox = (renderOptions, isFirstRender) => {
// //     // Rendering logic
// // };

// // // 2. Create the custom widget
// // const customSearchBox = instantsearch.connectors.connectSearchBox(
// //     renderSearchBox
// // );

// // // 3. Instantiate
// // search.addWidgets([
// //     customSearchBox({
// //         // instance params
// //     })
// // ]);

// search.addWidget(
//     instantsearch.widgets.searchBox({
//         container: '.search-searchbar',
//         placeholder: 'Type To Search',
//         autofocus: true,
//         searchAsYouType: true,
//         showReset: true,
//         showLoadingIndicator: true,
//         cssClasses: {
//             item: 'search-input',
//         },
//     })
// );
// const makeHits = instantsearch.connectors.connectHits(
//     function renderHits({ hits }, isFirstRendering) {
//         hits.forEach(hit => {
//             console.log(hit);
//         });
//     }
// );
// // search.addWidget(
// //     instantsearch.widgets.pagination({
// //         container: '#pagination',
// //         maxPages: 20,
// //         // default is to scroll to 'body', here we disable this behavior
// //         // scrollTo: false
// //     })
// // );

// search.addWidget(
//     instantsearch.widgets.hits({
//         container: '#hits',
//         templates: {
//             item: `
//                 <h2>
//                     {{#helpers.highlight}}{ "attribute": "name" }{{/helpers.highlight}}
//                 </h2>
//                 <p>{{ description }}</p>
//                 `,
//         },
//         transformData: {
//             item: function (data) {
//                 data.lastmod_date = new Date(data.lastmod * 1000).toISOString().slice(0, 10)
//                 // https://caniuse.com/#search=MAP
//                 const tags = data.tags.map(function (value) {
//                     return value.toLowerCase().replace(' ', '-')
//                 })
//                 data.tags_text = tags.join(', ')
//                 return data
//             }
//         }
//     })
// );

// search.start();
// search.addWidgets([makeHits()]);
// // })
