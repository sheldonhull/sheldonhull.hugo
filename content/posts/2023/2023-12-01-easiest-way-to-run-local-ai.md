---

date: 2023-12-01T12:57:42+0000
title: Easiest Way to Run Local Ai
slug: easiest-way-to-run-local-ai
tags:

- tech
- development
- microblog
- ai

# images: [/images/]
---

[Ollama](https://ollama.ai/) makes this really easy.
I've tried a few options to have local code generation tooling available, and this took the cake for wrapping up localized model running.

I've got 64gb of ram on my M2 Max Macbook, so I can just run `ollama run llama2:13b` and get a local model up and ready to use.

If you are like most of humanity and want less resources taken up, try just `ollama run llama2`.

Connect this to [Continue](https://continue.dev) and you've got a local coding assistant.
It's click and go to add the model to your continue extension.

My initial impressions were less polished that `gpt-4`, but to quickly iterate on some reasonable code generation or minor refactoring work it's great to have a local option that wont use any data.
I'm on the go right now and being able to work offline for periods of time is great, but frustrating once I've experienced the handy transformation and simple fixes an AI integrated into the editor provides.

I've got more docs on this topic if you search for ai or sample [chat]([[chat]]).
