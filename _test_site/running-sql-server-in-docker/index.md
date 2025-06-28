# Running SQL Server in Docker

{{&lt; admonition type=&#34;info&#34; title=&#34;Updated 2020-05-05&#34; &gt;}}

I&#39;ve had lots of challenges in getting docker for sql-server working because I&#39;ve wanted to ensure for my dev use case that there was no need for virtual volume management and copying files into and out of this. Instead, I&#39;ve wanted to bind to local windows paths and have it drop all the mdf/ldf right there, so even on container destruction everything is good to go.

After working through the changes in SQL 2019 that require running as non-root, I&#39;ve gotten it work again. No install of sql-server needed. Easy disposable development instance through docker! I&#39;ll update my docker compose content when I can, but in the meantime, this should get you running even more quickly with SQL Server 2019.

```powershell
docker run `
    --name SQL19 `
    -p 1433:1433 `
    -e &#34;ACCEPT_EULA=Y&#34; `
    -e &#34;MSSQL_SA_PASSWORD=ThisIsNotARealPassword@!1}&#34; `
    -v C:\mssql\SQL19:/sql `
    -d mcr.microsoft.com/mssql/server:2019-latest

docker run `
    --name SQL19WithSpaces `
    -p 1434:1433 `
    -e &#34;ACCEPT_EULA=Y&#34; `
    -e &#34;MSSQL_SA_PASSWORD=ThisIsNotARealPassword@!1}&#34; `
    -v C:\mssql\SQL19WithSpaces:/sql `
    -d mcr.microsoft.com/mssql/server:2019-latest
```

{{&lt; /admonition &gt;}}

## Why Use Docker for MSSQL

Say you have an onboarding and need to get a new developer up to speed. Have you gone through the setup process for SQL Server on Windows? It&#39;s a bit tedious and even with running scripts to install (or in my case I wrapped up with Chocolatey), it&#39;s still a lot of things you need, including possibly a reboot if missing some .net dependencies.

The normal solution is to leverage more localdb for quickly deploying and isolating the database.

This has its own set of challenges that personally I like to avoid. Localdb is more isolated, but it&#39;s not truly like running a local SQL Server standard edition, and debugging permissions, sharing, and other things can with its own set of steps to work through. I&#39;ve seen it common for many devs to just avoid these issues and run a local SQL Server installation to just simplify and work with SQL Server as it&#39;s expected to be.

I&#39;d explored Docker SQL Server containers in the past, but one big issue for adoption to me was the issues I had mounting the local Windows folders to the Linux based container. ❓ Why is this important? Ease of usage for a developer. If I proposed this would save effort to many developers working with SQL Server, I&#39;m pretty sure telling them that they&#39;d have to copy a backup or database file in via CLI to a virtual mounted drive that they can&#39;t easily manage would be a deal-breaker. I basically wanted to ensure if they spun up SQL Server in a container, the database backups, mdf and ldf files, and any other created files would be able to persist outside of that instance, ensuring easy development workflow.

I&#39;m happy to say I finally have it working to my satisfaction, resolving most of those concerns.

## Scenarios This is Good For

If you&#39;ve desired to do the following, then using Docker might end up saving you some effort.

* simplify the setup of a new SQL Server instance
* be able to reset your SQL Server instance to allow testing some setup in isolation
* be able to switch SQL Server editions to match a new requirement
* be able to upgrade or patch to a later version of SQL Server with minimal effort

This is not for production. There&#39;s more effort and debate that goes on to using SQL Server in containers, Kubernetes (even more complex!), and other containerization approaches that are far outside the scope of what I&#39;m looking at. This is first and foremost focused on ensuring a development workflow that reduces complexity for a developer and increases the ease at which SQL Server testing can be implemented by making the SQL Server instance easily disposed of and recreated.

If this also means I spread some 🐧 Linux magic to some Windows stack developers... then count it as a sneaky win. 😏

## SQL Server on Linux or Windows containers

The following example is done with SQL Server on Linux. As I&#39;m already comfortable with SQL Server on Windows, I wanted to be try this on Linux based container. I also wanted to continue using Linux based containers for tooling, and not have to switch back to Windows containers for the sole purpose of running SQL Server. At the time I began this testing, I found it was exclusive. You either ran Linux or Windows-based containers. This is changing with the advent of new features in Docker that are there to allow side by side Windows &#43; Linux based containers.

Release notes indicate:

&gt; Experimental feature: LCOW containers can now be run next to Windows containers (on Windows RS3 build 16299 and later). Use --platform=linux in Windows container mode to run Linux Containers On Windows. Note that LCOW is experimental; it requires the daemon experimental option. [Docker Community Edition 18.03.0-ce-win59 2018-03-26](https://docs.docker.com/docker-for-windows/release-notes/)

The main difference in your local development process will be Windows Authentication vs SQL Authentication. Use SQL Authentication with Linux based SQL Server

## Docker Compose Example

The following is the result of a lot of trial and error over a year. Thanks to [Shawn Melton](https://wsmelton.github.io/) 👏 also for providing me with support doing my troubleshooting as part of the SQL Server community in Slack. You can find Shawn&#39;s example I used as a starting point for my 🧪testing in [this gist.](https://gist.github.com/wsmelton/7cce0f6930bb3e60c2dfacc7cf174ccf)

A few helpful tips:

1. Remove `-d` for detached and you can see the SQL Server console output in the console.
2. See the persisted databases (system and user!) in the artifacts directory after docker-compose begins running.

{{&lt; gist sheldonhull  a70a3a731b329b67f47a331c64c72ab5 &gt;}}

## Improving Code Tests

Another reason I&#39;m really excited about is the ability to better support testing through tools like Pester. Yes, it&#39;s a geek thing, but I love a solid written test 🧪that maintains my code and helps me ensure quality with changes. Better TDD is a goal of mine for sure.

🔨 This supports implementation of better tests by providing the potential for spinning up a local SQL Instance, restoring a test database, and running a sequence of actions against it with pass or fail without the additional infrastructure requirements to have this done on another server. Making your tests that are not full integration testing as minimally dependent on external factors is a fantastic step to saving you a lot of work.

A simple pester (PowerShell) might frame the start of a test like this:

```powershell
Before All {
    docker-compose up -d
    Import-Module Dbatools
    # Wait Until dbatools confirms connectivity through something like test-dbaconnection, then proceed with tests
    # Test-DbaConnection ....
    # Restore-DbaDatabase ...
}

After All {
    docker-compose down --volume
}

Describe &#34;DescribeName&#34; {
    Context &#34;ContextName&#34; {
        It &#34;ItName&#34; {
            Assertion
        }
    }
}
```

## Wrap Up

Hope this helps someone. I spent at least a year coming back over time to this hoping to actually get it working in a way that felt like a first-class citizen and reduced complexity for development work.

I&#39;m pretty happy with the results. 😁

