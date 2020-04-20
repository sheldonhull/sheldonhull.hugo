package main

// https://www.algolia.com/doc/api-client/methods/indexing/

import (
	"encoding/json"
	"fmt"
	"io/ioutil"

	"github.com/algolia/algoliasearch-client-go/algolia/search"
	// . "github.com/algolia/algoliasearch-client-go/v3@v3.Y.Z"
)

func main() {

	type AlgoliaIndex []struct {
		Authors        interface{} `json:"authors"`
		Categories     interface{} `json:"categories"`
		Date           int64       `json:"date"`
		Description    string      `json:"description"`
		Dir            string      `json:"dir"`
		Expirydate     int64       `json:"expirydate"`
		Fuzzywordcount int64       `json:"fuzzywordcount"`
		Keywords       interface{} `json:"keywords"`
		Kind           string      `json:"kind"`
		Lang           string      `json:"lang"`
		Lastmod        int64       `json:"lastmod"`
		ObjectID       string      `json:"objectID"`
		Permalink      string      `json:"permalink"`
		Publishdate    string      `json:"publishdate"`
		Readingtime    int64       `json:"readingtime"`
		Relpermalink   string      `json:"relpermalink"`
		Section        string      `json:"section"`
		Summary        string      `json:"summary"`
		Tags           []string    `json:"tags"`
		Title          string      `json:"title"`
		Type           string      `json:"type"`
		URL            string      `json:"url"`
		Weight         int64       `json:"weight"`
		Wordcount      int64       `json:"wordcount"`
	}
	fmt.Print("Doing this now")

	file, err := ioutil.ReadFile("public/algolia.json")
	if err != nil {
		fmt.Print(err)
	}
	data := AlgoliaIndex{}
	err = json.Unmarshal([]byte(file), &data)
	if err != nil {
		fmt.Print(err)
	}
	fmt.Print(data)

	client := search.NewClient(os.GetEnv("ALGOLIA_APP_ID"), os.GetEnv("ALGOLIA_ADMIN_KEY"))
	index := client.InitIndex(os.GetEnv("ALGOLIA_INDEX_NAME"))
	fmt.Print(index)
	res, err := index.SaveObjects(contacts)
	if err != nil {
		fmt.Print(err)
	}
}
