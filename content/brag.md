---

permalink: "/brag/"
layout: wide
title: "Sheldon Hull // Developer"
slug: "brag"
summary: professional summary & accomplishments
comments: false
robots: noindex
toc:
  enabled: false
---

Why a brag page?

It's a way to show keep track of some key accomplishments I've achieved, almost like "levels-ups".

While I'm starting this as more like a resume style format, I plan on keeping this updated as I go.

Thanks for stopping by and letting me brag a little!

## Recruiter?

If you are recruiter, then this might be useful: [Recruiters]({{< relref "recruiters.md" >}} "recruiters")

## Touching Base

- Add a comment to this page to say hi!
- Or [↗ Ask me Anything](https://github.com/sheldonhull/sheldonhull.hugo/discussions/new?category=ama)

## Page Metrics

Check out these google analytic metrics if you want to see a pretty chart.
Who doesn't love pretty graphs.

{{< fa-icon solid  chart-line >}} [Metrics]({{< relref "metrics" >}})

<div>
<i class="fas fa-chart-bar"></i>
<a href="https://webmentions.sheldonhull.com/" target="_blank">Webmention Analytics</a>
</div>

## What Makes Me Worth Considering?

### What makes a good engineer?

- 💯 Emotional Intelligence & Soft Skills
- A sense of ownership and drive to deliver, from "cradle to grave" mentality.
- Adaptability, willingness to learn and change.
  - I'm a big advocate on continual learning, which hopefully my blog shows!
  - Repeating the same `n` years of experience over and over is something to be avoided.
  - I tend to embrace change and want to continue to improve.

### What I'm a Good Fit For

- Pairing up with strong engineers.
I'm not a fan of lone wolf.
A strong engineering team of "good developers" will out perform the so called "10x" developer and be better for the company both logistically and culturally.
- Generalist experience valued, while allowing for expertise and deeper knowledge.
- Remote-First environments that value asynchronous communication and strong writing abilities.
  - I'm a big fan of Gitlabs Handbook First approach, and have advocated for and done documentation as code, architectural decision records, and other written forms of decision making in most of my career.
- Go! I'm a Gopher, and have been investing in excellence and quality in Go for the last season in my career.
I care about delivery value quickly, while I also care about the "craft" of well-designed and maintainable code.

{{< admonition type="Example" title="How I Tend To Think Through Systems" open=false >}}

Someone might look at deploying a webservice and spin up an EC2 linux webserver and call it done.

What would go through my head:

- Can I host this using a managed service such as ECS Fargate to avoid the operational toil of managing my own instance?
- Can I benefit from a service like this with autoscaling to ensure a failed task can automatically recover or allocate work to a new node?
- Did the web service add the instrumentation libraries for opentracing or the appropriate library?
- Are structured logs being used to ensure automatic parsing by the logging provider?
- Is the service being deployed via a CICD provider instead of manually?
- Are unit tests being run on developer machines with hooks and also by CI system?
- Are integration tests being run prior to deployment?
- Are service level objectives defined and tracked if required to ensure service isn't over-engineered, but also allocated appropriate time for new work if problems occur that would impact customer satisfaction?
- Is the core infrastructure defined via code?
- Is the application configured to pull its configuration from environment variables or cloud configuration provider rather than requiring manual changes?

{{< /admonition >}}

## Skill Highlight

<style>
.column {
  float: left;
  width: 33.33%;
}

/*Clear floats after the columns*/
.row:after {
  content: "";
  display: table;
  clear: both;
}
h2 {
  font-size: 1.5em;
}
</style>
<div class="row">
<div class="column"><h2>Primary Technologies</h2></div>
<div class="column"><h2>Exposure/Have Used</h2></div>
<div class="column"><h2>Things I'd Love to Work More On</h2></div>
<div class="row">
  <div class="column">
  {{< fa-icon solid  angle-right >}} Go<br>
  {{< fa-icon solid  angle-right >}} Containerization/Docker/Kubernetes<br>
  {{< fa-icon solid  angle-right >}} AWS<br>
  {{< fa-icon solid  angle-right >}} PowerShell (CrossPlatform), .NET Framework<br>
    {{< fa-icon solid  angle-right >}} Infrastructure As Code<br>
  {{< fa-icon solid  angle-right >}} GitHub/Actions/CI/Azure Pipelines<br>
  {{< fa-icon solid  angle-right >}} Technical Docs<br>
  {{< fa-icon solid  angle-right >}} CI/CD/Automation<br>
  {{< fa-icon solid  angle-right >}} Observability<br>
  {{< fa-icon solid  angle-right >}} SQL (Dev, Design & Operations)<br>
  {{< fa-icon solid  angle-right >}} Windows<br>
  </div>
  <div class="column">
  {{< fa-icon solid  angle-right >}} Azure<br>
    {{< fa-icon solid  angle-right >}} C#/.NET<br>
  {{< fa-icon solid  angle-right >}} Serverless<br>
  {{< fa-icon solid  angle-right >}} Python<br>
  </div>
  <div class="column">
  {{< fa-icon solid  angle-right >}} Go<br>
  {{< fa-icon solid  angle-right >}} Linux<br>
  {{< fa-icon solid  angle-right >}} Serverless<br>
  {{< fa-icon solid  angle-right >}} Microservices<br>
  {{< fa-icon solid  angle-right >}} Distributed Systems & Data<br>
  {{< fa-icon solid  angle-right >}} Developer Tooling<br>
  {{< fa-icon solid  angle-right >}} Containerization<br>
  </div>
</div>

## Professional Profile

{{< admonition type="info" title="Current // Senior Developer" open=false >}}

{{< fa-icon solid  calendar-alt >}} March 2021 - Current {{< fa-icon solid grip-lines-vertical >}} {{< fa-icon regular lightbulb >}} Thycotic {{< fa-icon solid grip-lines-vertical >}} Senior Software Engineer (AWS/Go)

⚡ Built Helm and Pulumi stack for Kubernetes to provide continuous deployment, resulting in < 15 mins from PR merge to app live in Kubernetes.<br>
⚡ Wrote Go task automation for team automating developer tooling setup (1 command to bootstrap), automatic updates of dependencies, security checks, configuration, go builds, container publishing and more.<br>
⚡ Improved SLDC applying DevOps practices towards trunk based development and infra-as-code.<br>
⚡ Did the majority of monorepo migration work and tooling to support single repository workflow for Angular & Go developers to simplify collaboration and development work.<br>
⚡ Supported PR Reviews and oversight of code from offshore team programming primarily in Go.<br>
⚡ Go: added structured logging, APM integration to support observability, and codified health monitors and synthethic checks with Pulumi Datadog SDK<br>
⚡ AWS Architecture redesign for ECS Fargate container driven support
of Go services, as well as supporting Docker configuration.<br>
⚡ Go & Task tooling to support developer workflow improvements for pre-commit, building, and other tooling.<br>
⚡ Investigative work for Kubernetes and usage of microservices using Dapr.<br>

*Things I Used*

Go, AWS/Azure, Pulumi, Kubernetes, Terraform, Terragrunt, Bash, Kubernetes, Dapr (Distributed Application Runtime) for Microservices. Datadog

*Public Artifacts*

Work under NDA.
Public related blog posts on general technology topics where posted on blog as well as some general studies on applying Go with TDD and algorithm studies are listed here.

{{< fa-icon solid  code-branch >}} [Magetools](https://github.com/sheldonhull/magetools)<br>
{{< fa-icon solid  code-branch >}} [100DaysOfCode for Go](https://www.sheldonhull.com/tags/100daysofcode/)<br/>
{{< fa-icon solid  code-branch >}} [Learn Go With Tests - Applied](https://github.com/sheldonhull/learn-go-with-tests-applied)<br>

{{< /admonition >}}

{{< admonition type="info" title="2014 - 2021 Senior Developer" open=false >}}

{{< fa-icon solid  calendar-alt >}} 2014 - 2021 {{< fa-icon solid grip-lines-vertical >}} {{< fa-icon regular lightbulb >}} Altus Group {{< fa-icon solid grip-lines-vertical >}} Senior Developer (Database & Dev Operations)

### Some Highlights

{{< fa-icon solid  info-circle >}} Senior Individual Contributor with cross-team impact functioning as Database/Site Reliability Engineer

{{< fa-icon solid  info-circle >}} Started with focus on SQL Server development, architecture, and performance tuning.
Migrated to Development operations team during tenure and operated on development through operations.
Heavy focus on production reliability for data tier.
Additional focus on automation for non-release tasks, such as Terraform deployments, AWS SSM management, automated runbook creation and more.
Functioned in part as Site Reliability Engineer with mixed cross-functional impact.

⚡ Part of transformation of on-premise to Cloud based
product<br>
⚡ Designed AWS Lambda serverless solution for providing KPI insight<br>
⚡ Improved velocity of infrastructure deployments by using Terraform
Cloud, deployed a PaaS based AWS RDS product.<br>
⚡ Built very detailed runbook and documentation library supporting detailed insight on databases, team processes, incident response, and more. Inspired by GitLab's concept of "handbook first", I promoted collaborative codification of knowledge among my team<br>
⚡ Designed and built the primary systems management and configuration used to rapidly bootstrap hundreds of instances and allow quickly pushing updates out.
solutions.<br>
⚡ Built robust AMI pipelines combining Azure Pipelines & Packer, including automated tests, matrix builds, and detailed documentation.<br>
⚡ Promoted stronger code based pull request driven workflows with
"Gitops" focus, code reviews, and mentoring of other junior team
members.<br>
⚡ Database Performance tuning, architectural design, and development.
⚡ Initial observability tooling advocate.

*Things I Used*

MSSQL Server, PowerShell, AWS, AWS SDK, Terraform, Lambda, S3,
Athena, Chatops w/Slack, ECS, Docker, Datadog, Grafana, InfluxDB,
Telegraf. Python, C#, Excel when I absolutely no other choice, ...and a lot
more.

*Public Artifacts*

{{< fa-icon solid  user-secret >}} Product related work under NDA

{{< fa-icon solid  rss >}} Blog posts on various general concepts related to Databases, DevOps, PowerShell, AWS, and technology

{{< fa-icon solid  file-alt >}} [Implementation Guide](https://d34bfwpm2i2eri.cloudfront.net)
This was a major effort in migrating content from an outdated large word doc to static generated website with analytics. Load testing, sizing guides, and more were improved. All docs for SQL Server and load test summaries were due to my efforts. CI driven via markdown file updates made this a quick process to keep things up to date. 👍

{{< /admonition >}}

{{< admonition type="info" title="2011-2014 SQL Server Developer" open=false >}}

{{< fa-icon solid  calendar-alt >}} 2011-2014 {{< fa-icon solid grip-lines-vertical >}} {{< fa-icon regular lightbulb >}} Selene Finance {{< fa-icon solid grip-lines-vertical >}} SQL Developer

{{< fa-icon solid  info-circle >}} Initially rehired for Asset Analyst work, was recruited into development team after learning SQL.
Continued with full SQL Server development

⚡ Relational database design performance, development, and
production support<br>
⚡ Performed work on business analyst, qa, and developer for the work assigned.
{{< /admonition >}}

{{< admonition type="info" title="Other Boring Stuff" open=false >}}

In case you are bored, I've done this as well:

{{< fa-icon solid  info-circle >}} Freddie Mac: Loss Mitigation during mortgage crisis<br>
{{< fa-icon solid  info-circle >}} Litton Loan Servicing: Loss Mitigation during mortgage crisis<br>
{{< fa-icon solid  info-circle >}} Greentree Servicing: Mortgage Collections <br>
{{< fa-icon solid  info-circle >}} Synergetic Communications: Mortgage Collections<br>
{{< fa-icon solid  info-circle >}} Vanderbilt Mortgage: Mortgage Collections<br>
{{< fa-icon solid  info-circle >}} Worked at a private school teaching<br>
{{< fa-icon solid  info-circle >}} Worked at a Library & Migrated an entire small military base library from one building the other. The darn dewy decimal system is what I blame for my eyes now. :grin:<br>

I'm really glad I'm not working in the mortgage industry & collections oriented roles anymore.

It did teach me to handle high stress situations and do pretty decent at negotation and grow stronger in my communication skills, so there's some positive to that part of the journey! :wink:

{{< /admonition >}}

### Trivia

{{< fa-icon solid  info-circle >}} First Programming Language: vba :laughing:<br>
{{< fa-icon solid  info-circle >}} Dark Or Light: join the dark side<br>
{{< fa-icon solid  info-circle >}} Preferred OS: any. Right now using macOS for development, and working in Docker containers when possible<br>
{{< fa-icon solid  info-circle >}} Terminal: Iterm2 & *I :heart: pwsh*

### Projects

I'm a big believer in #LearnInPublic approach, and have written for years on my blog on a variety of topics, demonstrating my ability to learn new technology and investment in continued excellence in my craft. This should help demonstrate my strengths in written communication.

**A few highlights:**

- [Brag - A page with more detail and links than the resume](https://www.sheldonhull.com/brag?ref=bragpage)
- [Go - My Go references docs with tips/templates/practices](https://www.sheldonhull.com/docs/go?ref=bragpage)
- [Go Articles - **A variety of posts (over 104 at time of resume)**](https://www.sheldonhull.com/tags/golang?ref=bragpage)
- [Using Azure DevOps for Private Go Modules - **featured by Azure DevOps Blog**](https://www.sheldonhull.com/using-azure-devops-for-private-go-modules?ref=bragpage)

Open Source Contributions:

While the majority of my work is NDA, I try to contribute when possible upstream as well as publish when possible.

A few projects on GitHub:

- [sheldonhull - landing page (updated with Github Actions)](https://github.com/sheldonhull)
- [My blog, documented setup and used as a knowledge base](https://github.com/sheldonhull/sheldonhull.hugo)
- [Go Semantic Linebreaks - A simple CLI for line normalization, planning to use Goldmark for structured text parsing when time permits](https://github.com/sheldonhull/go-semantic-linebreaks)
- [Magetools - Go based task library for common tasks. I use this instead of Makefiles, as it leverages Mage and the cross-platform power of Go for automation.](https://github.com/sheldonhull/magetools)
- [CI-Configuration Files: Common lint/tooling configuration to minimize setup of new projects.](https://github.com/sheldonhull/ci-configuration-files)

I also contribute back to various projects I use when possible: [PR's I've Authored on GitHub](https://github.com/search?q=type%3Apr+author%3Asheldonhull&type=Issues)
*As always, any posts on this site are not a reflection of my past or present employer.*
