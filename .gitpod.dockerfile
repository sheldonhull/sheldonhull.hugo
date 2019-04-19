FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.
RUN apt-get update && apt-get install -y \
        ... \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*apt-get install hugo
RUN apt-get install hugo
USER gitpod
# Apply user-specific settings
ENV HUGO_ENABLEGITINFO=true
#ENV HUGO_BASEURL=
ENV HUGO_MINIFY=true
ENV HUGO_DESTINATION=_site

# Give back control
USER root