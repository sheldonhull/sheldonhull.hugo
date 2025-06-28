# Easiest Way to Run Local Ai


[Ollama](https://ollama.ai/) makes this really easy.
I&#39;ve tried a few options to have local code generation tooling available, and this took the cake for wrapping up localized model running.

I&#39;ve got 64gb of ram on my M2 Max Macbook, so I can just run `ollama run llama2:13b` and get a local model up and ready to use.

If you are like most of humanity and want less resources taken up, try just `ollama run llama2`.

Connect this to [Continue](https://continue.dev) and you&#39;ve got a local coding assistant.
It&#39;s click and go to add the model to your continue extension.

My initial impressions were less polished that `gpt-4`, but to quickly iterate on some reasonable code generation or minor refactoring work it&#39;s great to have a local option that wont use any data.
I&#39;m on the go right now and being able to work offline for periods of time is great, but frustrating once I&#39;ve experienced the handy transformation and simple fixes an AI integrated into the editor provides.

I&#39;ve got more docs on this topic if you search for ai or sample [chat]({{&lt; relref &#34;chat.md&#34; &gt;}}).

