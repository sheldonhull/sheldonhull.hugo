# Sheldon Hull // Developer


_Why a brag page?_

I&#39;m a big fan of the #LearnInPublic approach, and this page is a way to share a bit more about me than a traditional resume.
It&#39;s a bit more personal, and I hope it helps you get a better sense of who I am and what I&#39;m about.

## Recruiter?

If you are recruiter, then this might be useful: [Recruiters]({{&lt; relref &#34;recruiters.md&#34; &gt;}} &#34;recruiters&#34;)

## Touching Base

- Add a comment to this page to say hi!
- Or [↗ Ask me Anything](https://github.com/sheldonhull/sheldonhull.hugo/discussions/new?category=ama)
- [Email Me](mailtol:touching.base@mail.sheldonhull.com)

## What Makes Me Worth Considering?

- 💯 Emotional Intelligence &amp; Soft Skills are critical to success.
- As an individual contributor, I understand the importance of influence-based leadership.
- A sense of ownership and drive to deliver, from &#34;cradle to grave&#34; mentality.
- Adaptability, willingness to learn and change.
  - Repeating the same `n` years of experience over and over is something to be avoided.
  - I&#39;m on the right side of the scale when it comes to embracing change and continual iteration to improve.

### What Environment I&#39;m A Good Fit For

- A culture that:
  - Balances autonomy with collaboration, and shipping frequently while caring about reliability.
  - Assumes the best of it&#39;s team members.
- Pairing up with strong engineers, as I&#39;d rather be around folks smarter than me to grow.
I&#39;m not a fan of lone wolf.
A strong engineering team of &#34;good developers&#34; will out perform the so called &#34;10x&#34; developer and be better for the company both logistically and culturally.
- Generalist experience valued, while allowing for expertise and deeper knowledge.
- Remote-First environments that value asynchronous communication and strong writing abilities.
  - I&#39;m a big fan of Gitlabs Handbook First approach, and have advocated for and done documentation as code, architectural decision records, and other written forms of decision making in most of my career.
  - You&#39;ll find I&#39;m exceedingly strong at codifying knowledge, which I believe is a priority for effectively scaling knowledge beyond a single person on a team.
- Go! I&#39;m a Gopher, and have been investing in excellence and quality in Go for the last season in my career.
I care about delivery value quickly, while I also care about the &#34;craft&#34; of well-designed and maintainable code.

### What Type Of Work I&#39;m Looking For

- Roles that provide technical challenges beyond basics.
I had a SME focus on database engineering earlier in my career, and moved to a generalist focus.
I&#39;d like to dive deeper into areas such as distributed systems, application scaling &amp; resliency, and automation.
- A role where I can impact and ship.
- Linux as the primary OS for production, not Windows.[^1]

{{&lt; admonition type=&#34;Example&#34; title=&#34;How I Tend To Think Through Systems&#34; open=false &gt;}}

Someone might look at deploying a webservice and spin up an EC2 linux webserver and call it done.

What would go through my head:

- Can I host this using a managed service such as ECS Fargate to avoid the operational toil of managing my own instance?
- Can I benefit from a service like this with autoscaling to ensure a failed task can automatically recover or allocate work to a new node?
- Did the web service add the instrumentation libraries for opentracing or the appropriate library?
- Are structured logs being used to ensure automatic parsing by the logging provider?
- Is the service being deployed via a CICD provider instead of manually?
- Are unit tests being run on developer machines with hooks and also by CI system?
- Are integration tests being run prior to deployment?
- Are service level objectives defined and tracked if required to ensure service isn&#39;t over-engineered, but also allocated appropriate time for new work if problems occur that would impact customer satisfaction?
- Is the core infrastructure defined via code?
- Is the application configured to pull its configuration from environment variables or cloud configuration provider rather than requiring manual changes?

{{&lt; /admonition &gt;}}

## Skill Highlight

&lt;style&gt;
.column {
  float: left;
  width: 33.33%;
}

/*Clear floats after the columns*/
.row:after {
  content: &#34;&#34;;
  display: table;
  clear: both;
}
h2 {
  font-size: 1.5em;
}
&lt;/style&gt;
&lt;div class=&#34;row&#34;&gt;
&lt;div class=&#34;column&#34;&gt;&lt;h2&gt;Very Familiar&lt;/h2&gt;&lt;/div&gt;
&lt;div class=&#34;column&#34;&gt;&lt;h2&gt;Exposure/Have Used&lt;/h2&gt;&lt;/div&gt;
&lt;div class=&#34;column&#34;&gt;&lt;h2&gt;Things I&#39;d Love to Work More On&lt;/h2&gt;&lt;/div&gt;
&lt;div class=&#34;row&#34;&gt;
  &lt;div class=&#34;column&#34;&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Azure &amp; AWS&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Go&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Linux&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Infra As Code (pulumi, terraform, etc)&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Kubernetes/Docker&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} GitHub/Actions/CI/Azure Pipelines&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Technical Docs&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} CI/CD/Automation (Dagger, Mage/Go, Pwsh, Bash) &lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Observability (Datadog, Sumologic, etc)&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} SQL (Dev, Design &amp; Operations)&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} PowerShell (CrossPlatform), .NET Framework&lt;br&gt;
  &lt;/div&gt;
  &lt;div class=&#34;column&#34;&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} C#/.NET&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Serverless&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Python&lt;br&gt;
  &lt;/div&gt;
  &lt;div class=&#34;column&#34;&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Go&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Linux&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Serverless&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Microservices&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Distributed Systems &amp; Data&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Developer Tooling&lt;br&gt;
  {{&lt; fa-icon solid  angle-right &gt;}} Containerization&lt;br&gt;
  &lt;/div&gt;
&lt;/div&gt;

## Professional Profile

### Roles

{{&lt; admonition type=&#34;info&#34; title=&#34;Current // Staff Software Engineer&#34; open=true &gt;}}

{{&lt; fa-icon solid  calendar-alt &gt;}} April 2024 - Current {{&lt; fa-icon solid grip-lines-vertical &gt;}} {{&lt; fa-icon regular lightbulb &gt;}} Delinea {{&lt; fa-icon solid grip-lines-vertical &gt;}} Staff Software Engineer - Developer Experience Team

⚡ Recieved stellar ratings &amp; recognization from management, resulting in a promotion to Staff Engineer.&lt;br&gt;
⚡ Joined the Developer Experience Team, a small team focused on solving developer pain points and improving the developer experience as the company continued to grow in both staffing, and platform complexity.&lt;br&gt;
⚡ This role has a larger scope impact for work, including presentations for engineering on various topics.&lt;br&gt;
⚡ Began with effort to consolidate and improve the scattered docs into a solid devex site, improve onboarding and guidance for supply chain security tooling, and other initiatives to improve the developer experience.&lt;br&gt;

#### Public Artifacts

This role didn&#39;t have the work in public GitHub repos, unlike prior teams, so not able to provide much examples, other than blog posts.

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;info&#34; title=&#34;2021-2024 Senior Developer&#34; open=false &gt;}}

{{&lt; fa-icon solid  calendar-alt &gt;}} March 2021 - April 2024 {{&lt; fa-icon solid grip-lines-vertical &gt;}} {{&lt; fa-icon regular lightbulb &gt;}} Delinea {{&lt; fa-icon solid grip-lines-vertical &gt;}} Senior Software Engineer (AWS/Go)

⚡ Built Helm and Pulumi stack for Kubernetes to provide continuous deployment, resulting in &lt; 15 mins from PR merge to app live in Kubernetes.&lt;br&gt;
⚡ Wrote Go task automation for team automating developer tooling setup (1 command to bootstrap), automatic updates of dependencies, security checks, configuration, go builds, container publishing and more.&lt;br&gt;
⚡ Improved SLDC applying DevOps practices towards trunk based development and infra-as-code.&lt;br&gt;
⚡ Did the majority of monorepo migration work and tooling to support single repository workflow for Angular &amp; Go developers to simplify collaboration and development work.&lt;br&gt;
⚡ Supported PR Reviews and oversight of code from offshore team programming primarily in Go.&lt;br&gt;
⚡ Go: added structured logging, APM integration to support observability, and codified health monitors and synthethic checks with Pulumi Datadog SDK&lt;br&gt;
⚡ AWS Architecture redesign for ECS Fargate container driven support
of Go services, as well as supporting Docker configuration.&lt;br&gt;
⚡ Go &amp; Task tooling to support developer workflow improvements for pre-commit, building, and other tooling.&lt;br&gt;
⚡ Investigative work for Kubernetes and usage of microservices using Dapr.&lt;br&gt;

_Things I Used_

Go, AWS/Azure, Pulumi, Kubernetes, Terraform, Terragrunt, Bash, Kubernetes, Dapr (Distributed Application Runtime) for Microservices. Datadog

_Public Artifacts_

Work under NDA.
Public related blog posts on general technology topics where posted on blog as well as some general studies on applying Go with TDD and algorithm studies are listed here.

{{&lt; fa-icon solid  code-branch &gt;}} [Magetools](https://github.com/sheldonhull/magetools)&lt;br&gt;
{{&lt; fa-icon solid  code-branch &gt;}} [100DaysOfCode for Go](https://www.sheldonhull.com/tags/100daysofcode/)&lt;br/&gt;
{{&lt; fa-icon solid  code-branch &gt;}} [Learn Go With Tests - Applied](https://github.com/sheldonhull/learn-go-with-tests-applied)&lt;br&gt;

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;info&#34; title=&#34;2014 - 2021 Senior Developer&#34; open=false &gt;}}

{{&lt; fa-icon solid  calendar-alt &gt;}} 2014 - 2021 {{&lt; fa-icon solid grip-lines-vertical &gt;}} {{&lt; fa-icon regular lightbulb &gt;}} Altus Group {{&lt; fa-icon solid grip-lines-vertical &gt;}} Senior Developer (Database &amp; Dev Operations)

### Some Highlights

{{&lt; fa-icon solid  info-circle &gt;}} Senior Individual Contributor with cross-team impact functioning as Database/Site Reliability Engineer

{{&lt; fa-icon solid  info-circle &gt;}} Started with focus on SQL Server development, architecture, and performance tuning.
Migrated to Development operations team during tenure and operated on development through operations.
Heavy focus on production reliability for data tier.
Additional focus on automation for non-release tasks, such as Terraform deployments, AWS SSM management, automated runbook creation and more.
Functioned in part as Site Reliability Engineer with mixed cross-functional impact.

⚡ Part of transformation of on-premise to Cloud based
product&lt;br&gt;
⚡ Designed AWS Lambda serverless solution for providing KPI insight&lt;br&gt;
⚡ Improved velocity of infrastructure deployments by using Terraform
Cloud, deployed a PaaS based AWS RDS product.&lt;br&gt;
⚡ Built very detailed runbook and documentation library supporting detailed insight on databases, team processes, incident response, and more. Inspired by GitLab&#39;s concept of &#34;handbook first&#34;, I promoted collaborative codification of knowledge among my team&lt;br&gt;
⚡ Designed and built the primary systems management and configuration used to rapidly bootstrap hundreds of instances and allow quickly pushing updates out.
solutions.&lt;br&gt;
⚡ Built robust AMI pipelines combining Azure Pipelines &amp; Packer, including automated tests, matrix builds, and detailed documentation.&lt;br&gt;
⚡ Promoted stronger code based pull request driven workflows with
&#34;Gitops&#34; focus, code reviews, and mentoring of other junior team
members.&lt;br&gt;
⚡ Database Performance tuning, architectural design, and development.
⚡ Initial observability tooling advocate.

#### Things I Used

MSSQL Server, PowerShell, AWS, AWS SDK, Terraform, Lambda, S3,
Athena, Chatops w/Slack, ECS, Docker, Datadog, Grafana, InfluxDB,
Telegraf. Python, C#, Excel when I absolutely no other choice, ...and a lot
more.

#### Public Artifacts

{{&lt; fa-icon solid  user-secret &gt;}} Product related work under NDA

{{&lt; fa-icon solid  rss &gt;}} Blog posts on various general concepts related to Databases, DevOps, PowerShell, AWS, and technology

{{&lt; fa-icon solid  file-alt &gt;}} [Implementation Guide](https://d34bfwpm2i2eri.cloudfront.net)
This was a major effort in migrating content from an outdated large word doc to static generated website with analytics. Load testing, sizing guides, and more were improved. All docs for SQL Server and load test summaries were due to my efforts. CI driven via markdown file updates made this a quick process to keep things up to date. 👍

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;info&#34; title=&#34;2011-2014 SQL Server Developer&#34; open=false &gt;}}

{{&lt; fa-icon solid  calendar-alt &gt;}} 2011-2014 {{&lt; fa-icon solid grip-lines-vertical &gt;}} {{&lt; fa-icon regular lightbulb &gt;}} Selene Finance {{&lt; fa-icon solid grip-lines-vertical &gt;}} SQL Developer

{{&lt; fa-icon solid  info-circle &gt;}} Initially rehired for Asset Analyst work, was recruited into development team after learning SQL.
Continued with full SQL Server development

⚡ Relational database design performance, development, and
production support&lt;br&gt;
⚡ Performed work on business analyst, qa, and developer for the work assigned.
{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;info&#34; title=&#34;Other Boring Stuff&#34; open=false &gt;}}

In case you are bored, I&#39;ve done this as well:

{{&lt; fa-icon solid  info-circle &gt;}} Freddie Mac: Loss Mitigation during mortgage crisis&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Litton Loan Servicing: Loss Mitigation during mortgage crisis&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Greentree Servicing: Mortgage Collections &lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Synergetic Communications: Mortgage Collections&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Vanderbilt Mortgage: Mortgage Collections&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Worked at a private school teaching&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Worked at a Library &amp; Migrated an entire small military base library from one building the other. The darn dewy decimal system is what I blame for my eyes now. :grin:&lt;br&gt;

I&#39;m really glad I&#39;m not working in the mortgage industry &amp; collections oriented roles anymore.

It did teach me to handle high stress situations and do pretty decent at negotation and grow stronger in my communication skills, so there&#39;s some positive to that part of the journey! :wink:

{{&lt; /admonition &gt;}}

### Trivia

{{&lt; fa-icon solid  info-circle &gt;}} First Programming Language: vba :laughing:&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Dark Or Light: join the dark side&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Preferred OS: any. Right now using macOS for development&lt;br&gt;
{{&lt; fa-icon solid  info-circle &gt;}} Terminal: Warp &amp; zsh

### Projects

I&#39;m a big believer in #LearnInPublic approach, and have written for years on my blog on a variety of topics, demonstrating my ability to learn new technology and investment in continued excellence in my craft.
This should help demonstrate my strengths in written communication.

**A few highlights:**

- [Brag - A page with more detail and links than the resume](https://www.sheldonhull.com/brag?ref=bragpage)
- [Go - My Go references docs with tips/templates/practices](https://www.sheldonhull.com/docs/go?ref=bragpage) which I&#39;ve updated periodically.
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

I also contribute back to various projects I use when possible: [PR&#39;s I&#39;ve Authored on GitHub](https://github.com/search?q=type%3Apr&#43;author%3Asheldonhull&amp;type=Issues)
_As always, any posts on this site are not a reflection of my past or present employer._

[^1]: I have nothing against Windows, it&#39;s great, but I&#39;ve chosen to pivot away from Windows Server in my career and focus on Linux.

