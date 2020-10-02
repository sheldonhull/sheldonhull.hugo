---
date: 2020-10-02T14:23:31-05:00
title: Ways to Improve Codespaces Local Docker Experience
slug: ways-to-improve-codespaces-local-docker-experience
tags:
    - tech
    - development
    - microblog
    - docker
    - codespaces
    - visual-studio-code
---

I've been enjoying Codespaces local development workflow with Docker containers.

I'm using macOS and on Docker experimental release.
Here are some ideas to get started on improving the development experience.

- Clone the repository in the virtual volume (supported by the extension) to eliminate the binding between host and container.
This would entail working exclusively inside the container.
- Increased Docker allowed ram to 8GB from the default of 2GB.

Any other ideas? Add a comment (powered by GitHub issues, so it's just a GitHub issue in the backend)
