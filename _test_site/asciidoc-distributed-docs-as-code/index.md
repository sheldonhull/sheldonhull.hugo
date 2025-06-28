# Asciidoc Distributed Docs as Code


## The Problem

- I want to keep my code and my documentation in the same place.
- I want to separate the presentation layer from my documentation content.
- I want to be flexible to publish documentation to a variety of endpoints and formats as processes evolve, without my content being impacted.
- I want to write a solid runbook for things that can&#39;t be fully automated, but still include scripts and other code in their native format.

Documentation is such an important part of a developer&#39;s life. I think we often take it for granted, and it&#39;s an afterthought in many projects.
However, as I consider my work, I know that I&#39;m not reinventing the wheel very often 😀.
Most of what I do is built on the back of others&#39; work.
When I use tooling, I&#39;m reading the documentation and using it as my basis to get work done.
When I use my notes and blog posts as a reference, I&#39;m using my informal version of knowledge gathering.

*INVEST* in documenting your work as you go, for the person behind you.
You don&#39;t find time to do it, you make time to do it while you work, as a first class citizen of your work, not an after-thought.
Think of all the times you&#39;ve had to dig for answers and save someone else that experience.

&gt; You code and document not as much for yourself, but for the person that comes behind you.

## Asciidoctor

I&#39;ve found a happy solution in the Asciidoctor documentation format over markdown.
You can go google this for more expanded understanding, but I&#39;ve decided that other than for basic notes and blog posts which are very simplistic, I now choose Asciidoctor.

Why use Asciidoc format over markdown comes down to the needs of technical documentation.

Here are some key reasons why I&#39;ve found Asciidoc format to be worth learning:

- I can reference code files with a simple `include::file[]` statement, while markdown would require me to embed my code directly as a code block.
- I can generate a table from a csv file, further helping me automate a refresh of the underlying data that is rendered to a table display
- I can create tables much more cleanly and with control than in markdown, even allowing nested tables for complicated process documentation.
- Automatic admonition callouts without extensions using simple statements like `IMPORTANT: foo`

## Presentation

Since the common documentation system used where I am at is Confluence, I decided to leverage the incredible confluence-publisher project that made this entire process a breeze.
Check the repo and the linked documentation out here: [Confluence Publisher](http://bit.ly/2Soy1ML)

In the future, if I didn&#39;t use confluence, I&#39;d explore rendering as a static website through Hugo (that&#39;s what this site is generated from) or revisit Antora and maybe merge my content into the format required by Atora programmatically.

## Use Docker

Since Asciidoc is written in Ruby, use docker and you won&#39;t have to deal with dependency nightmares, especially on Windows.

```powershell
$RepoDirectoryName = &#39;taco-ops-docs&#39;
echo &#34;🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮&#34;
echo &#34;Running confluence publisher 🌮&#34;
echo &#34;📃 Publishing $RepoDirectoryName repo contents&#34;

docker run --rm -v $BUILD_SOURCESDIRECTORY/$RepoDirectoryName/docs:/var/asciidoc-root-folder -e ROOT_CONFLUENCE_URL=$ROOT_CONFLUENCE_URL \
-e SKIP_SSL_VERIFICATION=false \
-e USERNAME=$USERNAME \
-e PASSWORD=$PASSWORD \
-e SPACE_KEY=$SPACE_KEY \
-e ANCESTOR_ID=$ANCESTOR_ID \
-e PUBLISHING_STRATEGY=$PUBLISHING_STRATEGY \
confluencepublisher/confluence-publisher:0.0.0-SNAPSHOT
echo &#34;📃 Publishing $RepoDirectoryName repo contents finished&#34;
```

Yes... I know. I get bored reading log messages when debugging so my new year premise was to add some emoji for variety.
Don&#39;t judge. 😁

## Distributed Docs Structure

So the above approach is fantastic for a single repo.
I wanted to take it to a different level by solving this problem for distributed documentation.
By distributed I meant that instead of containing all the documentation in a single &#34;wiki&#34; style repo, I wanted to grab documentation from the repositories I choose and render it.
This would allow the documentation related to being contained in the repository it is related to.

For instance, what if I wanted to render the documentation in the following structure:

```text

** General Documentation**
taco-ops-runbook
---&gt; building-tacos
--------&gt; topic.adoc
---&gt; eating-tacos
--------&gt; topic.adoc
---&gt; taco-policies
--------&gt; topic.adoc
---&gt; taco-as-code
--------&gt; topic.adoc

** Repo Oriented Documentation**
github-repos
---&gt; taco-migration
--------&gt; category-1
------------&gt; topic.adoc
------------&gt; topic.adoc
--------&gt; category-2
------------&gt; topic.adoc
------------&gt; topic.adoc
---&gt; taco-monitoring
--------&gt; category-1
------------&gt; topic.adoc
------------&gt; topic.adoc
--------&gt; category-2
------------&gt; topic.adoc
------------&gt; topic.adoc

```

The only current solution found was [Antora](http://bit.ly/2SO0ZoC).
Antora is very promising and great for more disciplined documentation approaches by software development teams.
The limitation I faced was complexity and rigidity in structure.
For Antora to generate a beautiful documentation site, you have to ensure the documentation is structured in a much more complex format.
For example, the docs might be under `docs/modules/ROOT/pages/doc.adoc` and have a `nav.adoc` file as well.
While this promises a solid solution, retrofitting or expecting adoption might be tricky if your team has never even done markdown.

## Azure DevOps Pipeline

I ended using an Azure DevOps pipeline (YAML of course 🤘) that provides a nice easy way to get this done.

First, for proper linking, you should follow the directions Azure DevOps gives on the creation of a [Github Service Connection](http://bit.ly/2UNWWel) which uses OAUTH.
This will ensure your setup isn&#39;t brittle and using your access token.

{{&lt; gist sheldonhull  &#34;053cb176d5c2847a4e323f01207acb82&#34; &gt;}}

## Things to Know

* Ensure you use the format shown here for documentation to render in confluence correctly. You need to have the names match in the doc/folder for it to know to render the child pages.

```text
** Repo Oriented Documentation**
taco-ops-repo
README.adoc  -- optional, but I always include for landing page, and point to the docs folder using link:./docs/myrepo.adoc
---&gt; [docs]
------&gt; [resources]  -- optional, but keeps the scripts organized and consistent, or any images
------&gt; process.adoc
------&gt; another-process.adoc
---&gt; taco-ops-repo.adoc
```

* Include your scripts by using `include::./resources/_myscript.ps1[]`. You may have to test that relative path issue if doing multiple repos.
* Ensure your non-asciidoc contents are prefaced with an underscore in the title name. I don&#39;t like this, but it&#39;s a requirement from confluence-publisher. This ensures it won&#39;t try to render as a page.
* Anything in the target directory (ancestor) gets purged in the process. I recommend a dedicated confluence space you create just for this to minimize risk and disable manual edits.

{{&lt; admonition type=&#34;info&#34; title=&#34;Docker Commands in Microsoft-Hosted Agent&#34; &gt;}}
I didn&#39;t expect docker commands to work in Azure DevOps agent, thinking nested virtualization would not work and all. However, it works beautifully. Consider using Azure DevOps yaml pipelines for running your docker commands and you take one step towards better build processes.
{{&lt; /admonition &gt;}}

