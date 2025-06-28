# Assume a role with AWS PowerShell Tools

## Assume A Role

I&#39;ve had some issues in the past working with `AWS.Tools` PowerShell SDK and correctly assuming credentials.

By default, most of the time it was easier to use a dedicated IAM credential setup for the purpose.

However, as I&#39;ve wanted to run some scripts across multiple accounts, the need to simplify by assuming a role has been more important.

It&#39;s also a better practice than having to manage multiple key rotations in all accounts.

First, as I&#39;ve had the need to work with more tooling, I&#39;m not using the SDK encrypted `json` file.

Instead, I&#39;m leveraging the `~/.aws/credentials` profile in the standard `ini` format to ensure my tooling (docker included) can pull credentials correctly.

Configure your file in the standard format.

Setup a `[default]` profile in your credentials manually or through `Initialize-AWSDefaultConfiguration -ProfileName &#39;my-source-profile-name&#39; -Region &#39;us-east-1&#39; -ProfileLocation ~/.aws/credentials`.

If you don&#39;t set this, you&#39;ll need to modify the examples provided to include the source `profilename`.

{{&lt; gist sheldonhull  &#34;e73dc7689be62dc7e8946d4ab948728b&#34; &#34;aws-cred-example&#34; &gt;}}

Next, ensure you provide the correct Account Number for the role you are trying to assume, while the MFA number is going to come from the &#34;home&#34; account you setup.
For the `Invoke-Generate`, I use a handy little generator from `Install-Module NameIt -Scope LocalUser -Confirm:$false`.

{{&lt; gist sheldonhull  &#34;e73dc7689be62dc7e8946d4ab948728b&#34; &#34;aws-sts-assume-role-example.ps1&#34; &gt;}}

Bonus: Use Visual Studio Code Snippets and drop this in your snippet file to quickly configure your credentials in a script with minimal fuss. 🎉

{{&lt; gist sheldonhull  &#34;e73dc7689be62dc7e8946d4ab948728b&#34; &#34;vscode-snippet.json&#34; &gt;}}

I think the key area I&#39;ve missed in the past was providing the mfa and token in my call, or setting up this correctly in the configuration file.

## Temporary Credentials

In the case of needing to generate a temporary credential, say for an environment variable based run outside of the SDK tooling, this might also provide something useful.

It&#39;s one example of further reducing risk vectors by only providing a time-limited credential to a tool you might be using (can limit to a smaller time-frame).

{{&lt; gist sheldonhull  &#34;e73dc7689be62dc7e8946d4ab948728b&#34; &#34;generate-temporary-credentials.ps1&#34; &gt;}}

## AWS-Vault

Soon to come, using [aws-vault](https://bit.ly/3eTwztU) to improve the security of your AWS sdk credentials further by simplifying role assumption and temporary sessions.

I&#39;ve not ironed out exactly how to deal with some issues with using this great session tool when jumping between various tools such as PowerShell, python, docker, and more, so for now, I&#39;m not able to provide all the insight.
Hopefully, I&#39;ll add more detail to leveraging this once I get things ironed out.

Leave a comment if this helped you out or if anything was confusing so I can make sure to improve a quick start like this for others. 🌮

