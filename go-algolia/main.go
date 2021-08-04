package main

// https://www.algolia.com/doc/api-client/methods/indexing/

import (
	// "bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	// "path"
	"time"
	// "stdlog"
	"strings"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	// "github.com/algolia/algoliasearch-client-go/algolia/search"
	// . "github.com/algolia/algoliasearch-client-go/v3@v3.Y.Z"
)

// var zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

const (
	contentDir string = "content/blog"
	jsonOut    string = "algolia.json"
)

type AlgoliaIndex struct {
	Authors        []string `json:"authors"`
	Categories     []string `json:"categories"`
	Date           string   `json:"date"`
	Description    string   `json:"description"`
	Dir            string   `json:"dir"`
	Expirydate     string   `json:"expirydate"`
	Fuzzywordcount int64    `json:"fuzzywordcount"`
	Keywords       []string `json:"keywords"`
	Kind           string   `json:"kind"`
	Lang           string   `json:"lang"`
	Lastmod        string   `json:"lastmod"`
	ObjectID       string   `json:"objectID"`
	Permalink      string   `json:"permalink"`
	Publishdate    string   `json:"publishdate"`
	Readingtime    int64    `json:"readingtime"`
	Relpermalink   string   `json:"relpermalink"`
	Section        string   `json:"section"`
	Summary        string   `json:"summary"`
	Tags           []string `json:"tags"`
	Title          string   `json:"title"`
	Type           string   `json:"type"`
	URL            string   `json:"url"`
	Weight         int64    `json:"weight"`
	Wordcount      int64    `json:"wordcount"`
}

func InitLogger() {
	output := zerolog.ConsoleWriter{Out: os.Stdout, TimeFormat: time.RFC3339}
	output.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("| %-6s|", i))
	}
	output.FormatMessage = func(i interface{}) string {
		return fmt.Sprintf("***%s****", i)
	}
	output.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf("%s:", i)
	}
	output.FormatFieldValue = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("%s", i))
	}
}

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
	debug := flag.Bool("debug", false, "sets log level to debug")
	flag.Parse()

	// Default level for this example is info, unless debug flag is present
	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	if *debug {
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	}
	// var AlgItems = []AlgoliaIndex{}

	file, err := ioutil.ReadFile("public/algolia.json")
	if err != nil {
		fmt.Print(err)
	}
	// Create sized to file count
	data := AlgoliaIndex{}
	err = json.Unmarshal([]byte(file), &data)
	if err != nil {
		fmt.Print(err)
	}
	log.Info().Msgf("%v", data)
}

// func UpdateAlgolia() {

// 	type AlgoliaIndex []struct {
// 		Authors        interface{} `json:"authors"`
// 		Categories     interface{} `json:"categories"`
// 		Date           int64       `json:"date"`
// 		Description    string      `json:"description"`
// 		Dir            string      `json:"dir"`
// 		Expirydate     int64       `json:"expirydate"`
// 		Fuzzywordcount int64       `json:"fuzzywordcount"`
// 		Keywords       interface{} `json:"keywords"`
// 		Kind           string      `json:"kind"`
// 		Lang           string      `json:"lang"`
// 		Lastmod        int64       `json:"lastmod"`
// 		ObjectID       string      `json:"objectID"`
// 		Permalink      string      `json:"permalink"`
// 		Publishdate    string      `json:"publishdate"`
// 		Readingtime    int64       `json:"readingtime"`
// 		Relpermalink   string      `json:"relpermalink"`
// 		Section        string      `json:"section"`
// 		Summary        string      `json:"summary"`
// 		Tags           []string    `json:"tags"`
// 		Title          string      `json:"title"`
// 		Type           string      `json:"type"`
// 		URL            string      `json:"url"`
// 		Weight         int64       `json:"weight"`
// 		Wordcount      int64       `json:"wordcount"`
// 	}
// 	fmt.Print("Doing this now")

// 	file, err := ioutil.ReadFile("public/algolia.json")
// 	if err != nil {
// 		fmt.Print(err)
// 	}
// 	data := AlgoliaIndex{}
// 	err = json.Unmarshal([]byte(file), &data)
// 	if err != nil {
// 		fmt.Print(err)
// 	}
// 	fmt.Print(data)

// 	client := search.NewClient(os.GetEnv("ALGOLIA_APP_ID"), os.GetEnv("ALGOLIA_ADMIN_KEY"))
// 	index := client.InitIndex(os.GetEnv("ALGOLIA_INDEX_NAME"))
// 	fmt.Print(index)
// 	res, err := index.SaveObjects(contacts)
// 	if err != nil {
// 		fmt.Print(err)
// 	}
// }
