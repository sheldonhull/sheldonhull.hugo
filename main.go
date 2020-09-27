package main

// https://www.algolia.com/doc/api-client/methods/indexing/

import (
	// "encoding/json"
	"fmt"
	"github.com/gernest/front"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"io/ioutil"
	"os"
	"time"

	// "stdlog"
	"strings"
	// "github.com/algolia/algoliasearch-client-go/algolia/search"
	// . "github.com/algolia/algoliasearch-client-go/v3@v3.Y.Z"
)

//var zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

const contentDir string = "content/blog"

func GetFrontMatter(txt string) {
	m := front.NewMatter()
	m.Handle("+++", front.JSONHandler)
	f, body, err := m.Parse(strings.NewReader(txt))
	if err != nil {
		panic(err)
	}

	log.Info().Msgf("The front matter is:\n%#v\n", f)
	log.Info().Msgf("The body is:\n%q\n", body)
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

	// log := zerolog.New(os.Stdout).With().
	// 	Str("foo", "bar").
	// 	Logger()

	// stdlog.SetFlags(0)
	// stdlog.SetOutput(log)
	// stdlog.Print("hello world")

	// InitLogger()
	//log := zerolog.New(output).With().Timestamp().Logger()

	files, err := ioutil.ReadDir(contentDir)
	if err != nil {
		log.Error().Msgf("Failed to read files: %v", err)
	}
	log.Info().Msgf("Total Files Returned: %v", len(files))

	for i, f := range files {
		log.Info().Msgf("i: %v f: %v", i, f.Name())


	}

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
