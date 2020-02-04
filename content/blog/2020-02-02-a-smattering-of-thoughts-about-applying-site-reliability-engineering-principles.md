---

date: 2019-04-16T23:19:00.000+00:00
title: A Smattering of Thoughts About Applying Site Reliability Engineering principles
slug: a-smattering-of-thoughts-about-applying-site-reliability-engineering-principles
excerpt: Applying more SRE principles in your DevOps culture can help equip you with more concrete steps.
tags:
- agile
- working-smart
- site-reliability-engineering
- tech
- devops
draft: true
toc: true

---

I figured I'd go ahead and take this article which I've gutted several times and share some thoughts, even if it's not an authority on the topic. 😀
In the last year, I've been interested in exploring the DevOps philosophy as it applies to operations and software development.
There are so many ways this is done, that DevOps lost much of its meaning in the inundation of DevOps phrases.

What does it mean to plan and scale your workflow in a DevOps culture?
How do operational stability and the pressure for new feature delivery in a competitive market meet in a healthy tension?

## What is Site Reliability Engineering

Google's SRE material provides a solid guide on the implementation of SRE teams.
They consider SRE and DevOps in a similar relationship to how Agile views Scrum.
Scrum is an implementation of Agile tenants.
Site Reliability Engineering is an implementation of a DevOps mindset in a systematic approach.

> If you think of DevOps like an interface in a programming language, class SRE implements DevOps. [Google SRE](http://bit.ly/36R2F5r)

What I like about the material, is that a lot of the fixes I've considered to improvements in workflow and planning have been thoughtfully answered in their guide, since it's a specific implementation rather than a broader philosophy with less specific steps.

Regardless of where you are in your journey, a lot of the principles have much to offer.
Even smaller organizations can benefit from many of these concepts, with various adjustments being made to account for the capabilities of the business.

## Recommended Reading

Recommended reading if this interests you:

| Link |
| ---- |
| [Deploys: It’s Not Actually About Fridays – charity.wtf](http://bit.ly/2GPnJ1O) |
| [DevOps Topologies](https://web.devopstopologies.com/) |
| [Do you have an SRE team yet? How to start and assess your journey](http://bit.ly/2tna4fb) |
| [Google - Site Reliability Engineering](http://bit.ly/2RP2zqT) |
| [Love (and Alerting) in the Time of Cholera (and Observability) – charity.wtf](http://bit.ly/2GMw1HR) |

## Site Reliability Engineering & DevOps

### Where I Started

At the beginning of my tech career, I worked at a place that the word "spec" or "requirement" was considered unreasonable. Acceptance criteria would have been looked down upon, as something too formal and wasteful.

While moving towards to implementation of any new project, I was expected to gather the requirements, build the solution, ensure quality and testing, and deploy to production.
That "cradle to grave" approach done correctly can promote the DevOps principles, such as ensuring rapid feedback from the end-users and ownership from creation through to production.

However, one key area that notably is different from the much healthier development culture I'm now part of, is the failure to build-out requirements, acceptance criteria, and an effective prioritization for the work that is incoming.

I've been in a somewhat interesting blend of roles that gives me some insight into this.
As a developer, I always look at things from an {{< fa robot >}} automation & coding perspective.
It's the exception, rather than the norm for me to do it manually without any type of way to reproduce via code.

I've also been part of a team that did some automation for various tasks in a variety of ways, yet often resolved issues via manual interactions due to the time constraints and pressures of inflowing work. Building out integration tests, code unit tests, or any other automated testing was a nice idea in theory, but allocating time to slow down and refactor for automated testing on code, deployments, and other automated tasks were often deemed too costly or time prohibitive to pursue.

### Reactive


* Difficult to categorize emergency from something that could be done in a few weeks
* Difficult to deliver on a set of fully completed tasks in a sprint (if you even do a sprint)
* High interrupt ratio for request-driven work instead of able to put into a sprint with planning. This is common in a DevOps dedicated team topology that is in some of the Anti-Types mentioned in [DevOps Anti-Type topologies](https://web.devopstopologies.com/)
* Sprint items in progress tend to stay there for more than a few days due to the constant interruptions or unplanned work items that get put on their plate.
* Unplanned work items are constant, going above the 25% buffer normally put into a sprint team.
* Continued feature delivery pressure without the ability to invest in resiliency of the system.

Google has a lot more detail on the principles of "on call" rotation work compared to project-oriented work. [Life of An On-Call Engineer](https://landing.google.com/sre/sre-book/chapters/being-on-call/). Of particular relevance is mention of capping the time that Site Reliability Engineers spend on purely operational work to 50% to ensure the other time is spent building solutions to impact the automation and service reliability in a proactive, rather than reactive manner.

### SLO & Error Budgets

One of the things that struck home, was the importance of SLO and error budgets.
Error budgets provide the key ingredient to balancing new feature delivery, while still ensuring happy customers with a stable system.

One of the best sections I've read on this was: [Embracing Risk](http://bit.ly/2UfsA4l).

Error budgets are discussed, and internal SLI (Server Level Indicators).
These are integral to ensuring a balance of engineering effort in balance with new feature delivery.
The goal of 100% reliability, while sounding great, is inherently unrealistic.

> Product development performance is largely evaluated on product velocity, which creates an incentive to push new code as quickly as possible. Meanwhile, SRE performance is (unsurprisingly) evaluated based upon the reliability of a service, which implies an incentive to push back against a high rate of change. Information asymmetry between the two teams further amplifies this inherent tension.

## Wrap Up

Long-winded post, but since I've been mulling over this for a while, and had a mix of practical and concept-oriented concepts to cover, I hope you got some value from this either on the SRE concept level or the practical steps to approaching an operational task from more of a software development mentality with writing tests.

As always, these are personal thoughts and don't reflect the opinion of my company or other entity.
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk1ODk3MzYwM119
-->