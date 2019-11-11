// The first key the Application ID, the second is the Search-Only Key
// Both are safe to be in source control ;)

// const search = instantsearch({
//     appId: '04HSGXXQD5',
//     apiKey: 'a7ec2763a5d966a5b9f8d70b254bfb68',
//     indexName: 'sheldonhull',
//     urlSync: true
//   });
const options = {
    appId: '04HSGXXQD5',
    apiKey: 'a7ec2763a5d966a5b9f8d70b254bfb68',
    indexName: 'sheldonhull',
    hitsPerPage: 10,
    routing: true
}
// const algolia = algoliasearch(options);
// const algoliaIndex = algolia.initIndex("sheldonhull");

const search = instantsearch(options);
