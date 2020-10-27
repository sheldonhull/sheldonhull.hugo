package main

// https://www.algolia.com/doc/api-client/methods/indexing/

import (
	// "bytes"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/gernest/front"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"io/ioutil"
	"os"
	"path"
	"time"

	// "stdlog"
	"strings"
	// "github.com/algolia/algoliasearch-client-go/algolia/search"
	// . "github.com/algolia/algoliasearch-client-go/v3@v3.Y.Z"
)

//var zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

const contentDir string = "content/blog"
const jsonOut string = "algolia.json"

// type AlgoliaIndex []struct {
// 	Authors        interface{} `json:"authors"`
// 	Categories     interface{} `json:"categories"`
// 	Date           int64       `json:"date"`
// 	Description    string      `json:"description"`
// 	Dir            string      `json:"dir"`
// 	Expirydate     int64       `json:"expirydate"`
// 	Fuzzywordcount int64       `json:"fuzzywordcount"`
// 	Keywords       interface{} `json:"keywords"`
// 	Kind           string      `json:"kind"`
// 	Lang           string      `json:"lang"`
// 	Lastmod        int64       `json:"lastmod"`
// 	ObjectID       string      `json:"objectID"`
// 	Permalink      string      `json:"permalink"`
// 	Publishdate    string      `json:"publishdate"`
// 	Readingtime    int64       `json:"readingtime"`
// 	Relpermalink   string      `json:"relpermalink"`
// 	Section        string      `json:"section"`
// 	Summary        string      `json:"summary"`
// 	Tags           []string    `json:"tags"`
// 	Title          string      `json:"title"`
// 	Type           string      `json:"type"`
// 	URL            string      `json:"url"`
// 	Weight         int64       `json:"weight"`
// 	Wordcount      int64       `json:"wordcount"`
// }

type AlgoliaIndex struct {
	Authors        []string `json:"authors"`
	Categories     []string `json:"categories"`
	Date           string    `json:"date"`
	Description    string   `json:"description"`
	Dir            string   `json:"dir"`
	Expirydate     string    `json:"expirydate"`
	Fuzzywordcount int64    `json:"fuzzywordcount"`
	Keywords       []string `json:"keywords"`
	Kind           string   `json:"kind"`
	Lang           string   `json:"lang"`
	Lastmod        string    `json:"lastmod"`
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

func GetFrontMatter(txt string) (f map[string]interface{}) {

	m := front.NewMatter()
	m.Handle("---", front.YAMLHandler)
	f, body, err := m.Parse(strings.NewReader(txt))

	if err != nil {
		panic(err)
	}

	log.Debug().Msgf("The front matter is:\n%#v\n", f)
	for i, fm := range f {
		log.Debug().Msgf("i: %v v: %v", i, fm)
	}
	log.Debug().Msgf("The body is:\n%q\n", body)
	return f
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
	///var AlgItems = new([]AlgoliaIndex)
	var AlgItems = []AlgoliaIndex{}

	// Create sized to file count
	//AlgItems := make([]AlgoliaIndex, len(files))

	for i, f := range files {
		//basename := f.Name()

		log.Info().Msgf("i: %v f: %v", i, f.Name())
		filename := path.Join(contentDir, f.Name())
		b, err := ioutil.ReadFile(filename)
		if err != nil {
			log.Error().Msgf("Error reading file: %v", err)
		}
		fm := GetFrontMatter(string(b))
		item := AlgoliaIndex{}
		if v, ok := fm["title"].(string); ok {
			item.Title = v
		}
		if v, ok := fm["excerpt"].(string); ok {
			item.Summary = v
		}
		if v, ok := fm["date"].(string); ok {
			item.Date = v
		}
		if v, ok := fm["tags"].([]string); ok {
			item.Tags = v
		}
		log.Debug().Msgf("Front Matter: %v", fm)
		log.Debug().Msg("Returned front matter for: " + filename)
		AlgItems = append(AlgItems, item)
		log.Debug().Msgf("AltItems Count: %v", len(AlgItems))
	}

	log.Info().Msgf("Total Items in Struct AlgItems: %v", len(AlgItems))

	//var prettyJSON bytes.Buffer
	b, err := json.MarshalIndent(AlgItems, "", "\t")
	if err != nil {
		log.Error().Msgf("JSON parse error: %v", err)
		return
	}

	err = ioutil.WriteFile(jsonOut, b, 0644)
	if err != nil {
		log.Err(err)
	}

	// file, err := ioutil.ReadFile("public/algolia.json")
	// if err != nil {
	// 	fmt.Print(err)
	// }
	// data := AlgoliaIndex{}
	// err = json.Unmarshal([]byte(file), &data)
	// if err != nil {
	// 	fmt.Print(err)
	// }
	// fmt.Print(data)

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
