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

_Why a brag page?_

I'm a big fan of the #LearnInPublic approach, and this page is a way to share a bit more about me than a traditional resume.
It's a bit more personal, and I hope it helps you get a better sense of who I am and what I'm about.

## Recruiter?

If you are recruiter, then this might be useful: [[recruiters|Recruiters]]

## Touching Base

- Add a comment to this page to say hi!
- Or [↗ Ask me Anything](https://github.com/sheldonhull/sheldonhull.hugo/discussions/new?category=ama)
- [Email Me](mailtol:touching.base@mail.sheldonhull.com)

## What Makes Me Worth Considering?

- 💯 Emotional Intelligence & Soft Skills are critical to success.
- As an individual contributor, I understand the importance of influence-based leadership.
- A sense of ownership and drive to deliver, from "cradle to grave" mentality.
- Adaptability, willingness to learn and change.
  - Repeating the same `n` years of experience over and over is something to be avoided.
  - I'm on the right side of the scale when it comes to embracing change and continual iteration to improve.

### What Environment I'm A Good Fit For

- A culture that:
  - Balances autonomy with collaboration, and shipping frequently while caring about reliability.
  - Assumes the best of it's team members.
- Pairing up with strong engineers, as I'd rather be around folks smarter than me to grow.
I'm not a fan of lone wolf.
A strong engineering team of "good developers" will out perform the so called "10x" developer and be better for the company both logistically and culturally.
- Generalist experience valued, while allowing for expertise and deeper knowledge.
- Remote-First environments that value asynchronous communication and strong writing abilities.
  - I'm a big fan of Gitlabs Handbook First approach, and have advocated for and done documentation as code, architectural decision records, and other written forms of decision making in most of my career.
  - You'll find I'm exceedingly strong at codifying knowledge, which I believe is a priority for effectively scaling knowledge beyond a single person on a team.
- Go! I'm a Gopher, and have been investing in excellence and quality in Go for the last season in my career.
I care about delivery value quickly, while I also care about the "craft" of well-designed and maintainable code.

### What Type Of Work I'm Looking For

- Roles that provide technical challenges beyond basics.
I had a SME focus on database engineering earlier in my career, and moved to a generalist focus.
I'd like to dive deeper into areas such as distributed systems, application scaling & resliency, and automation.
- A role where I can impact and ship.
- Linux as the primary OS for production, not Windows.[^1]

> [!example] How I Tend To Think Through Systems-
> Someone might look at deploying a webservice and spin up an EC2 linux webserver and call it done.
>
> What would go through my head:
>
> - Can I host this using a managed service such as ECS Fargate to avoid the operational toil of managing my own instance?
> - Can I benefit from a service like this with autoscaling to ensure a failed task can automatically recover or allocate work to a new node?
> - Did the web service add the instrumentation libraries for opentracing or the appropriate library?
> - Are structured logs being used to ensure automatic parsing by the logging provider?
> - Is the service being deployed via a CICD provider instead of manually?
> - Are unit tests being run on developer machines with hooks and also by CI system?
> - Are integration tests being run prior to deployment?
> - Are service level objectives defined and tracked if required to ensure service isn't over-engineered, but also allocated appropriate time for new work if problems occur that would impact customer satisfaction?
> - Is the core infrastructure defined via code?
> - Is the application configured to pull its configuration from environment variables or cloud configuration provider rather than requiring manual changes?

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
<div class="column"><h2>Very Familiar</h2></div>
<div class="column"><h2>Exposure/Have Used</h2></div>
<div class="column"><h2>Things I'd Love to Work More On</h2></div>
<div class="row">
  <div class="column">
  Azure & AWS<br>
  Go<br>
  Linux<br>
  Infra As Code (pulumi, terraform, etc)<br>
  Kubernetes/Docker<br>
  GitHub/Actions/CI/Azure Pipelines<br>
  Technical Docs<br>
  CI/CD/Automation (Dagger, Mage/Go, Pwsh, Bash) <br>
  Observability (Datadog, Sumologic, etc)<br>
  SQL (Dev, Design & Operations)<br>
  PowerShell (CrossPlatform), .NET Framework<br>
  </div>
  <div class="column">
  C#/.NET<br>
  Serverless<br>
  Python<br>
  </div>
  <div class="column">
  Go<br>
  Linux<br>
  Serverless<br>
  Microservices<br>
  Distributed Systems & Data<br>
  Developer Tooling<br>
  Containerization<br>
  </div>
</div>

## Professional Profile

### Roles

> [!info] Current // Staff Software Engineer+
> April 2024 - Current Delinea Staff Software Engineer - Developer Experience Team
>
> ⚡ Recieved stellar ratings & recognization from management, resulting in a promotion to Staff Engineer.<br>
> ⚡ Joined the Developer Experience Team, a small team focused on solving developer pain points and improving the developer experience as the company continued to grow in both staffing, and platform complexity.<br>
> ⚡ This role has a larger scope impact for work, including presentations for engineering on various topics.<br>
> ⚡ Began with effort to consolidate and improve the scattered docs into a solid devex site, improve onboarding and guidance for supply chain security tooling, and other initiatives to improve the developer experience.<br>
>
> #### Public Artifacts
>
> This role didn't have the work in public GitHub repos, unlike prior teams, so not able to provide much examples, other than blog posts.

> [!info] 2021-2024 Senior Developer-
> March 2021 - April 2024 Delinea Senior Software Engineer (AWS/Go)
>
> ⚡ Built Helm and Pulumi stack for Kubernetes to provide continuous deployment, resulting in < 15 mins from PR merge to app live in Kubernetes.<br>
> ⚡ Wrote Go task automation for team automating developer tooling setup (1 command to bootstrap), automatic updates of dependencies, security checks, configuration, go builds, container publishing and more.<br>
> ⚡ Improved SLDC applying DevOps practices towards trunk based development and infra-as-code.<br>
> ⚡ Did the majority of monorepo migration work and tooling to support single repository workflow for Angular & Go developers to simplify collaboration and development work.<br>
> ⚡ Supported PR Reviews and oversight of code from offshore team programming primarily in Go.<br>
> ⚡ Go: added structured logging, APM integration to support observability, and codified health monitors and synthethic checks with Pulumi Datadog SDK<br>
> ⚡ AWS Architecture redesign for ECS Fargate container driven support
> of Go services, as well as supporting Docker configuration.<br>
> ⚡ Go & Task tooling to support developer workflow improvements for pre-commit, building, and other tooling.<br>
> ⚡ Investigative work for Kubernetes and usage of microservices using Dapr.<br>
>
> _Things I Used_
>
> Go, AWS/Azure, Pulumi, Kubernetes, Terraform, Terragrunt, Bash, Kubernetes, Dapr (Distributed Application Runtime) for Microservices. Datadog
>
> _Public Artifacts_
>
> Work under NDA.
> Public related blog posts on general technology topics where posted on blog as well as some general studies on applying Go with TDD and algorithm studies are listed here.
>
> [Magetools](https://github.com/sheldonhull/magetools)<br>
> [100DaysOfCode for Go](https://www.sheldonhull.com/tags/100daysofcode/)<br/>
> [Learn Go With Tests - Applied](https://github.com/sheldonhull/learn-go-with-tests-applied)<br>

> [!info] 2014 - 2021 Senior Developer-
> 2014 - 2021 Altus Group Senior Developer (Database & Dev Operations)
>
> ### Some Highlights
>
> Senior Individual Contributor with cross-team impact functioning as Database/Site Reliability Engineer
>
> Started with focus on SQL Server development, architecture, and performance tuning.
> Migrated to Development operations team during tenure and operated on development through operations.
> Heavy focus on production reliability for data tier.
> Additional focus on automation for non-release tasks, such as Terraform deployments, AWS SSM management, automated runbook creation and more.
> Functioned in part as Site Reliability Engineer with mixed cross-functional impact.
>
> ⚡ Part of transformation of on-premise to Cloud based
> product<br>
> ⚡ Designed AWS Lambda serverless solution for providing KPI insight<br>
> ⚡ Improved velocity of infrastructure deployments by using Terraform
> Cloud, deployed a PaaS based AWS RDS product.<br>
> ⚡ Built very detailed runbook and documentation library supporting detailed insight on databases, team processes, incident response, and more. Inspired by GitLab's concept of "handbook first", I promoted collaborative codification of knowledge among my team<br>
> ⚡ Designed and built the primary systems management and configuration used to rapidly bootstrap hundreds of instances and allow quickly pushing updates out.
> solutions.<br>
> ⚡ Built robust AMI pipelines combining Azure Pipelines & Packer, including automated tests, matrix builds, and detailed documentation.<br>
> ⚡ Promoted stronger code based pull request driven workflows with
> "Gitops" focus, code reviews, and mentoring of other junior team
> members.<br>
> ⚡ Database Performance tuning, architectural design, and development.
> ⚡ Initial observability tooling advocate.
>
> #### Things I Used
>
> MSSQL Server, PowerShell, AWS, AWS SDK, Terraform, Lambda, S3,
> Athena, Chatops w/Slack, ECS, Docker, Datadog, Grafana, InfluxDB,
> Telegraf. Python, C#, Excel when I absolutely no other choice, ...and a lot
> more.
>
> #### Public Artifacts
>
> Product related work under NDA
>
> Blog posts on various general concepts related to Databases, DevOps, PowerShell, AWS, and technology
>
> [Implementation Guide](https://d34bfwpm2i2eri.cloudfront.net)
> This was a major effort in migrating content from an outdated large word doc to static generated website with analytics. Load testing, sizing guides, and more were improved. All docs for SQL Server and load test summaries were due to my efforts. CI driven via markdown file updates made this a quick process to keep things up to date. 👍

> [!info] 2011-2014 SQL Server Developer-
> 2011-2014 Selene Finance SQL Developer
>
> Initially rehired for Asset Analyst work, was recruited into development team after learning SQL.
> Continued with full SQL Server development
>
> ⚡ Relational database design performance, development, and
> production support<br>
> ⚡ Performed work on business analyst, qa, and developer for the work assigned.

> [!info] Other Boring Stuff-
> In case you are bored, I've done this as well:
>
> Freddie Mac: Loss Mitigation during mortgage crisis<br>
> Litton Loan Servicing: Loss Mitigation during mortgage crisis<br>
> Greentree Servicing: Mortgage Collections <br>
> Synergetic Communications: Mortgage Collections<br>
> Vanderbilt Mortgage: Mortgage Collections<br>
> Worked at a private school teaching<br>
> Worked at a Library & Migrated an entire small military base library from one building the other. The darn dewy decimal system is what I blame for my eyes now. :grin:<br>
>
> I'm really glad I'm not working in the mortgage industry & collections oriented roles anymore.
>
> It did teach me to handle high stress situations and do pretty decent at negotation and grow stronger in my communication skills, so there's some positive to that part of the journey! :wink:

### Trivia

First Programming Language: vba :laughing:<br>
Dark Or Light: join the dark side<br>
Preferred OS: any. Right now using macOS for development<br>
Terminal: Warp & zsh

### Projects

I'm a big believer in #LearnInPublic approach, and have written for years on my blog on a variety of topics, demonstrating my ability to learn new technology and investment in continued excellence in my craft.
This should help demonstrate my strengths in written communication.

**A few highlights:**

- [Brag - A page with more detail and links than the resume](https://www.sheldonhull.com/brag?ref=bragpage)
- [Go - My Go references docs with tips/templates/practices](https://www.sheldonhull.com/docs/go?ref=bragpage) which I've updated periodically.
- [Go Articles - **A variety of posts (over 104 at time of resume)**](https://www.sheldonhull.com/tags/golang?ref=bragpage)
- [Using Azure DevOps for Private Go Modules - **featured by Azure DevOps Blog**](https://www.sheldonhull.com/using-azure-devops-for-private-go-modules?ref=bragpage)

Open Source Contributions:

While the majority of my work is NDA, I try to contribute when possible upstream as well as publish when possible.

A few projects on GitHub:

- [DelineaXPM](https://github.com/DelineaXPM): I setup the majority of the DevOps Secrets Vault automation, revamped all the public facing repos with Go based automation for testing, development, and templatized CI/CD.
- [sheldonhull - landing page (updated with Github Actions)](https://github.com/sheldonhull)
- [az-pr](https://github.com/sheldonhull/az-pr) for experimentation on a TUI based PR creation tool for Azure DevOps.
- [My blog, documented setup and used as a knowledge base](https://github.com/sheldonhull/sheldonhull.hugo)
- [Magetools - Go based task library for common tasks. I use this instead of Makefiles, as it leverages Mage and the cross-platform power of Go for automation.](https://github.com/sheldonhull/magetools)

I also contribute back to various projects I use when possible: [PR's I've Authored on GitHub](https://github.com/search?q=type%3Apr+author%3Asheldonhull&type=Issues)
_As always, any posts on this site are not a reflection of my past or present employer._

[^1]: I have nothing against Windows, it's great, but I've chosen to pivot away from Windows Server in my career and focus on Linux.
