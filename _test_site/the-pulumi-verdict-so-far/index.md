# The Pulumi Verdict So Far


## What Pulumi Is

- Pulumi is like a muscle car.
Great if you want full control, power, and flexibility.
- Pulumi is fast.
- Has actual loops.
Sorry `HCL`... Your loops are just confusing.[^2]

## What Pulumi Is Not

- Pulumi is like a rally car.
You will be traveling a gravel road that might result in a few bumps and potholes.
It can handle it.
However, there are things (just like `HCL` had/has over time) you&#39;ll run into that don&#39;t make sense or are bugs, but since it&#39;s younger there might not be immediate fixes.

## When Would I Choose Terraform Over Pulumi?

- If you prefer minivans over rally cars. (j/k)
- If I want to leverage a prebuilt complex module, like those from the Terraform registry made by CloudPosse, Terraform could provide a better value for the time.
    - I hope that Pulumi eventually has a full &#34;Crosswalk&#34; support where folks begin sharing prebuilt stacks with best practices, but I feel it&#39;s an uphill road as a latecomer from Terraform.
- When there is a module that provides the functionality you want, it might make sense to use it over rebuilding in Pulumi.
- If you expect no one in your org will support Pulumi, you might use it for a few things here and there, but it&#39;s a tough road unless others are interested and willing to try it out.

## When Would I choose Pulumi over Terraform?

- If you lean towards &#34;developer&#34; over &#34;infrastructure&#34; engineering in your skillset, meaning you are comfortable writing in the primary languages Pulumi supports. I feel it requires a bit more coding (esp with Typed languages) understanding upfront, while `HCL` is something you can pick up without requiring general-purpose coding knowledge.
- If you are solid with Go, Python, C#, or Typescript, but not quite as advanced as `HCL`.
- If you understand infrastructure. This is key. Terraform modules tend to hold your hand and do a lot of good things for you out of the box. Pulumi is like giving you the lego pieces to build whatever you want, but not a step-by-step assembly guide.
- When you have the autonomy to select a combination of tools in your role.
- When you want to use looping constructs and other language functions without dealing with the limits of confusion of `HCL`.
- If you want to deviate from very basic `yaml` and `tfvar` inputs, then Pulumi can be more flexible with the range of libraries and built-in configuration functionality Pulumi offers.
- If you want to store encrypted secrets in your `yaml` for simplicity and velocity, Pulumi does this very elegantly.
- If you want to manage complex naming conventions, then using a struct with methods is fantastic, allowing you to enforce naming and self-document using Go&#39;s documentation functionality (and IntelliSense).

## Other Notes

### Support

- Pulumi: Expect delays. I believe many of those helping are not doing support in Slack or GitHub full-time. This can make the unique challenges faced in edge cases difficult to allocate time to support. I believe this would change if the enterprise support tier was engaged, so if it&#39;s an org-wide rollout, then consider this.
- Terraform: In contrast, I&#39;ve had _absymally_ low engagement from Terraform in forums and GitHub. I think both prioritize (rightly) the Enterprise clients, which leaves the lower tier subscribers a bit on their own/crowdsourced support at times. They should close their forums down and rely on GitHub unless engagement changes. The best part about Terraform, is you often don&#39;t need support since so many community members use it.

## Components

Components allow you to provide similar functionality to the org as Terraform modules.
If you are rolling this out to an org, consider becoming familiar with this and simplify other development teams&#39; usage by having the core components provided with all the best practices, tagging, and naming convention preset.
[^2]: My top post of all time to this day is a post on using terraform `for_each`.

