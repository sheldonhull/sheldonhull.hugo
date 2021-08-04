// Testing this via: go run main.go -debug -directory "/Users/sheldonhull/git/sheldonhull/sheldonhull.hugo/content/docs/powershell.md"

package main

import (
	"bytes"
	// "path/filepath"
	// "context"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
	"time"

	// "github.com/prometheus/common/log"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/text"
	// "github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer/html"
	"mvdan.cc/xurls"
)

const (
	// exitFail is the exit code if the program
	// fails.
	exitFail = 1
)

var directory string

func main() {
	if err := run(os.Args, os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		os.Exit(exitFail)
	}
}

// Run handles the arguments being passed in from main, and allows us to run tests against the loading of the code much more easily than embedding all the startup logic in main().
// This is based on Matt Ryers post: https://pace.dev/blog/2020/02/12/why-you-shouldnt-use-func-main-in-golang-by-mat-ryer.html
func run(args []string, stdout io.Writer) error {
	if len(args) == 0 {
		return errors.New("no arguments")
	}
	for _, value := range args[1:] {
		fmt.Fprintf(stdout, "Running with flag: %s\n", value)
	}
	InitLogger()
	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	debug := flag.Bool("debug", false, "sets log level to debug")
	// directory = flag.String("directory", "", "[Required] directory of markdown files to parse")
	flag.StringVar(&directory, "directory", "", "[Required] directory of markdown files to parse")
	// flag.String("directory","","[Required] directory of markdown files to parse")
	flag.Parse()
	if *debug {
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	}
	// ctx := context.Background()
	GetFile()
	return nil
}

// InitLogger sets up the logger magic
// By default this is only configured to do pretty console output.
// JSON structured logs are also possible, but not in my default template layout at this time.
func InitLogger() {
	output := zerolog.ConsoleWriter{Out: os.Stdout, TimeFormat: time.RFC3339}
	log.Logger = log.With().Caller().Logger().Output(zerolog.ConsoleWriter{Out: os.Stderr})

	output.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("| %-6s|", i))
	}
	output.FormatMessage = func(i interface{}) string {
		return fmt.Sprintf("%s", i)
	}
	output.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf("%s:", i)
	}
	output.FormatFieldValue = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("%s", i))
	}
	log.Info().Msg("logger initialized")
}

func GetFile() error {
	r, err := ioutil.ReadFile(directory)
	if err != nil {
		log.Error().Err(err).
			Str("directory", directory).
			Msg("failed to read file")
		return err
	}
	// ctx := parser.Context{}

	markdown := goldmark.New(
		goldmark.WithRendererOptions(
			html.WithXHTML(),
			html.WithUnsafe(),
		),
		goldmark.WithExtensions(
			extension.NewLinkify(
				extension.WithLinkifyAllowedProtocols([][]byte{
					[]byte("http:"),
					[]byte("https:"),
				}),
				extension.WithLinkifyURLRegexp(
					xurls.Strict,
				),
			),
		),
	)
	var buf bytes.Buffer
	if err := markdown.Convert(r, &buf); err != nil {
		log.Panic().Err(err).Msg("failed in conversion")
		panic(err)
		return err
	}

	log.Info().Msg("finished convert without error")

	files, err := ioutil.ReadDir(".")
	if err != nil {
		log.Panic().Err(err).Msg("failed to read directory")
	}

	// // Footnote Stuff
	// for _, path := range files {
	// 	source := readAll(path)
	// 	prefix := getPrefix(path)

	// 	markdown := goldmark.New(
	// 		goldmark.WithExtensions(
	// 			NewFootnote(
	// 				WithFootnoteIDPrefix([]byte(path)),
	// 			),
	// 		),
	// 	)
	// 	var b bytes.Buffer
	// 	err := markdown.Convert(source, &b)
	// 	if err != nil {
	// 		t.Error(err.Error())
	// 	}
	// }
	// markdown = goldmark.New(
	// 	goldmark.WithExtensions(
	// 		NewFootnote(
	// 			WithFootnoteIDPrefixFunction(func(n gast.Node) []byte {
	// 				v, ok := n.OwnerDocument().Meta()["footnote-prefix"]
	// 				if ok {
	// 					return util.StringToReadOnlyBytes(v.(string))
	// 				}
	// 				return nil
	// 			}),
	// 		),
	// 	),
	// )

	for _, path := range files {
		source := ioutil.Read(path)
		var b bytes.Buffer

		doc := markdown.Parser().Parse(text.NewReader(source))
		doc.Meta()["footnote-prefix"] = getPrefix(path)
		err := markdown.Renderer().Render(&b, source, doc)
	}

	// md := goldmark.New(
	// 	goldmark.WithExtensions(extension.GFM),
	// 	goldmark.WithParserOptions(
	// 		parser.WithAutoHeadingID(),
	// 	),
	// 	goldmark.WithRendererOptions(
	// 		html.WithHardWraps(),
	// 		html.WithXHTML(),
	// 	),
	// )
	// var buf bytes.Buffer
	// if err := md.Convert(r, &buf); err != nil {
	// 	panic(err)
	// 	return err
	// }
	return nil
}
