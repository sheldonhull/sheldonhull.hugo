# My Experience Switching To A Macbook Pro From Windows


{{&lt; admonition type=&#34;Info&#34; title=&#34;update 2021-05-19&#34; open=&#34;true&#34;&gt;}}

updated with fresh thoughts

Regarding stability issues, I&#39;d say those initial stability issues haven&#39;t continued, so I&#39;m very happy with the overall stability.
The only thing that really gave me pain was DisplayLink drivers, which seem to always be a pain on Windows or MacOS.

{{&lt; /admonition &gt;}}

## My background

My background has been very strongly focused on the .NET world, with a focused start on SQL Server, later branching into learning PowerShell.
This world was heavily focused on Windows.

## Why switch

Having focused on Windows for so long, using a Macbook for development always intrigued me, but was actually not the driving factor.
Poor specs and performance issues with the currently issued laptop kept impacting my work, causing impact to my efforts. As my work right now is heavily focused in DevOps oriented areas, I found that the reliance on tooling that only worked in Windows over time has greatly reduced.

While I&#39;m very excited for WSL2 with Windows, what I kept feeling like I was doing was battling my system instead of accomplishing the work I needed to get done.
As someone who has been an obsessive tweaker of whatever OS I&#39;m on, I&#39;ve actually found my desire for full customization diminishing as the development work becomes more interesting.
In this case, being able to work with more linux tooling without as much conflict was appealing.

Additionally, the windows specs for the workbooks I had available were definitely subpar to what a highend macbook could offer.

So I took the plunge, was approved thanks to a supportive manager, and now am working exclusively on a 16&#34; Macbook Pro I9.

## Setup

Learned some Ansible on the fly and configured everything pretty much from the start with Ansible.
Overall, that made it a much better developer onboarding experience than trying to write my initial chocolatey package bootstrap script.

## Painpoints

{{&lt; fa-icon solid  external-link-alt &gt;}} DisplayLink installation was painful for docking usage.
Gotta be careful during updates.

{{&lt; fa-icon solid  bullseye &gt;}} No aeropeek

{{&lt; fa-icon solid  window-restore &gt;}} No automatic window snapping without third party apps

{{&lt; fa-icon solid  keyboard &gt;}} Text editing shortcuts

{{&lt; fa-icon solid  home &gt;}} Absolutely despise the changed home/end and selection behavior.
Trying to remap this is painful.
I&#39;ve limited my remapping to try and adjust to the way it works natively, but it&#39;s difficult.
VSCode remapping for certain actions is also tricky, but possible.

## Wins

{{&lt; fa-icon solid  search &gt;}} So far I&#39;ve found Finder to be really good and much more intuitive than Explorer in Windows.

{{&lt; fa-icon solid  folder &gt;}} The consistency of app placement makes finding things to run quick, whereas in Windows, finding the app can be a beast at times.
Think about this from a new Windows developer perspective. Go to Program Files (x86), or Program Files, but some go into AppData, and then settings in ProgramData, but sometimes that program prefers to put some of the configuration data in the Program directory and sometimes in ProgramData.... unless they want to put it in AppData.... and then Local/Roaming etc. It gets really really confusing quick.
That&#39;s why tools like _Everything_ are so helpful!

{{&lt; fa-icon brands  docker &gt;}} Docker startup is 🚀 FAST. I&#39;m talking about an update for Docker, and install restart and in a few seconds it&#39;s back up and running.
I&#39;ve been so used to it being minutes on Windows.
Mounted drive performance isn&#39;t great, but neither is it on Windows.

{{&lt; fa-icon solid  beer &gt;}} I love Chocolatey &amp; Scoop on Windows, but I&#39;m seeing some advantages to a central repository containing all the packages, instead of each package being the responsibility of maintainers to keep up to date.
This makes the contribution phase much more difficult in Chocolatey. I&#39;ve written very complex Choco packages for my company, but haven&#39;t yet setup a community one, whereas Brew, Scoop, and others have a central repository that you can easily submit a push request to with improvements or new additions without having to manage the autorefresh of the packages.
A minor, but important distinction to me, as the ease of contributing must be there for more people to engage in it.
{{&lt; typeit  &gt;}}Brew is _stellar_.{{&lt; /typeit &gt;}}

{{&lt; fa-icon brands  windows &gt;}} Not having Windows as my OS has helped me go cold turkey as much as possible on running more workloads in Docker.
Visual Studio Docker workspaces are absolutely incredible, and paired with a good tool like `InvokeBuild` with PowerShell, you have a stellar setup than can easily bootstrap itself on a new machine with ease.

## Quirks

{{&lt; fa-icon solid  mouse &gt;}} As of this time, mouse cursor not auto-hiding in full screen video without work arounds on certain sites.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} Experimenting with some apps resulted in 2 full system crashes in first 3 weeks of using, so stability while good wasn&#39;t as stellar as I was hoping. Just like Windows, it all depends on what you are running.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} Massive lag on bluetooth and even Logitech Unifying receiver based mouse and keyboard, enough to make them unusable.
Others seem to have had similar issues when I searched.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} Need to buy a powered hub to expand ports, as only USB-C resulting in all my peripherals not working.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} Docks don&#39;t provide enough power for a macbook pro at times.
Gone are the days of a slick dock that my laptop locks into.
Get used to running cables.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} Had to google &#34;how to remove bonks&#34; to get the annoying keyboard sound effect from driving my insane. This required editing: `/DefaultKeyBinding.dict`. Seriously, this was just silly.

{{&lt; fa-icon solid  long-arrow-alt-right &gt;}} I find the power button the mac annoying.
Tends to have a mind of it&#39;s own when I&#39;m thinking &#34;just start darn you!&#34;

## Development Experience

I feel kinda strange as I&#39;ve not needed to dive into system internals like I felt I needed with Windows.

At somepoint, I needed to touch the registry, work through service quirks, .NET library conflicts and more.

Overall, it feels like things are just easier and I fight less with development tools and libraries.

Perhaps the most hands on portion is just making sure binaries get to `PATH` as there is no real &#34;global variable&#34; like you have in Windows.
Instead, this is normally managed in the user&#39;s `.bashrc` file, or in my case I use `.profile` and a powershell file to load my own overrides.

## PowerShell &amp; Shells

I put work into using `zsh` as my default, with a bunch of customizations.
I still came back to PowerShell ❤️.

PowerShell is a fantastic default shell for macOS, and allowed me to immediately get value from the terminal without having to use a specific syntax to that shell (if it isn&#39;t POSIX compliant like Fish)

With PSReadline, the editor experience and autocomplete on my history is fantastic and I have no complaints.

I&#39;m trying to keep an open mind and not &#34;hate on bash/fish/zsh&#34;, as they have a long history.
I can see if someone has a background in Linux only, that PowerShell is too much of a paradigm change to adopt without a desire to explore it.

For those with experience in more object oriented tooling, it will be more natural in my opinion than the quirks of bash scripts.[^bash-quirks]

With `ConvertFrom-Json` being such as magical tool, I&#39;ve been able to mix and match native tooling with PowerShell automagic cmdlets and get some great productive results.

### Shell Customization

With my dotfiles managed by [chezmoi](https://www.chezmoi.io/), my terminal in any environment looks great as I&#39;m using [starship](https://starship.rs/)

## Apps

The ecosystem for nice dev tools feels better.
I bought [Alfred Microblog Post]({{&lt; relref &#34;2020-06-24t16-03-49-00-00.md&#34; &gt;}} &#34;alfred microblog&#34;) and [Dash](https://kapeli.com/dash) and find them really useful.

## Verdict

So far, the experience has been one I&#39;d repeat.
For me, I&#39;ve actually accomplished more, and gotten aware from my desk more with the improved quality of the mobile experience and touchpad.

Would I do it again?
Currently yes.

[^bash-quirks]: After digging through the mess of bash if comparison blocks, I found the PowerShell ternary operator very readable.
`(Test-Path $File -PathType Leaf) ? (Write-Host &#34;😀 Do something with positive match and process&#34;) : (Write-Host &#34;😢 Sad panda&#34;)`
Since all the bash tools are pretty much accessible from your `pwsh` prompt and scripts simply by being called, you gain all the perks of a clear readable scripting language, while still using native tooling.
It&#39;s not better than bash, just different.
For those experienced in bash and not really desiring to try something new, no problem!
For those looking to try something new, I think it&#39;s a great way to write a cross platform script, and a good default shell.

