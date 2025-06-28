# chat


## Examples Where ChatGPT Failed

{{&lt; admonition type=&#34;example&#34; title=&#34;Help Me With Using Goldmark For Markdown Parsing&#34; open=false &gt;}}

This failed repeatedly.
The code examples were promising but invoked quite a few methods and approaches that were non-existent in the actual code base and had no corresponding code examples in the repo.
Goldmark doesn&#39;t have as many use examples compared to many projects, so I think the quality of the suggestions degraded with a broader question.

It _looked_ great, but with incorrect method signatures, it really suffered.

![example image](/images/notes/ray-so-export-developement-ai-chat-goldmark.png &#34;Goldmark Fail&#34;)

I think for this to succeed I&#39;m going to have it focus on a specific code block and not a function in its entirety.

{{&lt; /admonition &gt;}}

## Examples Where ChatGPT Has Been Amazing

👉 See [anonymous server](../go/http.md#anonymous-server)

{{&lt; admonition type=&#34;example&#34; title=&#34;Help Me Jump Start an API Server With TDD Support and Zerolog&#34; open=false &gt;}}

&gt; What&#39;s a good bootstrap template for golang rest api server?
&gt; I want to include TDD approach that abstracts the http server into a cmd file and allows me to mock http for tests.
&gt; Use zerolog for logging with context.

Key points I think it did well with:

1. It structured it reasonably.
2. It provided a jump start test file to do TDD with based on `httptest`.
3. It was intelligent enough to add `zerolog` url handling logging using my preferred package.

I could see how this could really help jump start intelligently templating out a project much better than just raw boilerplate.

Instead of having to maintain cookie-cutter style templates, you might see the future allowing being very specific and generating customized code along with infra to support quicker iteration on development.
Of course, everything should be vetted and scanned, but it&#39;s a pretty incredible experience worth using copilot/chatGPT to occasionally accelerate development.

ChatGPT&#39;s answer:

There are several good bootstrap templates available for Go REST API servers. One popular option is the Go kit template, which provides a clean architecture for building microservices in Go.
Another option is the Gin Gonic template, which is a lightweight and fast HTTP web framework.
For your specific requirements, I would recommend using the Gin Gonic template, which provides a simple and easy-to-use web framework. You can use the gin package to create an HTTP server and handle requests, and use the zerolog package to log requests and responses.

Here&#39;s an example of how you can structure your project using the Gin Gonic template and implement TDD:

4. Start by creating a new project using the Gin Gonic template: `go get github.com/gin-gonic/gin`
5. Create a new cmd directory in your project root and create a main.go file inside it:
6. This file sets up a basic HTTP server using the `api.NewServer` function, which we&#39;ll define in the next step.
   It also initializes a logger using the `logging.NewLogger` function.
7. Create a new api directory and create a `server.go` file inside it.
   This file defines a Server struct that holds a reference to our logger.
   We&#39;ll use this struct to handle HTTP requests in the ServeHTTP method.
8. Now you can implement your TDD approach by writing tests and mocking the HTTP server using the `httptest` package:
9. This test creates a new instance of our Server and mocks an HTTP request using the `httptest` package.
   It then calls the `ServeHTTP` method and checks that the response status code is `200` OK.
10. Finally, you can use the zerolog package to log requests and responses in the ServeHTTP method.

=== &#34;cmd/main.go&#34;

    ```go title=&#34;cmd/main.go&#34;
    package main

    import (
        &#34;net/http&#34;
        &#34;os&#34;
        &#34;your_project/api&#34;
        &#34;your_project/logging&#34;
    )

    func main() {
      logger := logging.NewLogger()
      defer logger.Sync()

      // Initialize the HTTP server
      server := api.NewServer(logger)

      // Start the server
      port := os.Getenv(&#34;PORT&#34;)
      if port == &#34;&#34; {
          port = &#34;8080&#34;
      }

      logger.Info().Msgf(&#34;Starting server on port %s...&#34;, port)
      if err := http.ListenAndServe(&#34;:&#34;&#43;port, server); err != nil {
          logger.Fatal().Err(err).Msg(&#34;Failed to start server&#34;)
      }
    }
    ```

=== &#34;api/server.go&#34;

    ```go title=&#34;api/server.go&#34;
    package api

    import (
        &#34;net/http&#34;
        &#34;your_project/logging&#34;
    )

    type Server struct {
        logger *logging.Logger
    }

    func NewServer(logger *logging.Logger) *Server {
        return &amp;Server{logger: logger}
    }

    func (s *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
        // Handle the request
    }

    func (s *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
        s.logger.Info().
            Str(&#34;method&#34;, r.Method).
            Str(&#34;path&#34;, r.URL.Path).
    }
    ```

=== &#34;api/server_test.go&#34;

    ```go title=&#34;api/server_test.go&#34;
    package api_test

    import (
        &#34;net/http/httptest&#34;
        &#34;testing&#34;
        &#34;your_project/api&#34;
        &#34;your_project/logging&#34;
    )

    func TestServer_ServeHTTP(t *testing.T) {
        logger := logging.NewLogger()
        defer logger.Sync()

        server := api.NewServer(logger)

        req := httptest.NewRequest(&#34;GET&#34;, &#34;/&#34;, nil)
        w := httptest.NewRecorder()

        server.ServeHTTP(w, req)

        resp := w.Result()
        if resp.StatusCode != http.StatusOK {
            t.Errorf(&#34;unexpected status code: %d&#34;, resp.StatusCode)
        }
    }
    ```

{{&lt; /admonition &gt;}}

