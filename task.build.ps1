<#
.Description
    Initialize and build project
.Notes
    PS> New-Alias ib -value "invoke-build"
    Set this value in your profile to have a quick alias to call
#>

[cmdletbinding()]
param(
    $BuildRoot = $BuildRoot,
    $Tasks,
    [switch]$LoadConstants
)

foreach ($file in (Get-ChildItem -Path (Join-Path $BuildRoot 'build/functions')  -Filter '*.ps1').FullName) { . $file }
foreach ($file in (Get-ChildItem -Path (Join-Path $BuildRoot 'build/tasks')  -Filter '*.tasks.ps1').FullName) { . $file }

# Can handle both windows and mac if powershell core is setup on mac
if ([System.IO.Path]::GetFileName($MyInvocation.ScriptName) -ne 'Invoke-Build.ps1')
{
    $ErrorActionPreference = 'Stop'
    if (!(Get-Module InvokeBuild -ListAvailable))
    {
        Install-Module InvokeBuild
        'Installed and imported InvokeBuild as was not available'
    }
    Import-Module InvokeBuild
    # call Invoke-Build
    & Invoke-Build -Task $Tasks -File $MyInvocation.MyCommand.Path @PSBoundParameters
    return
}

###################################
# Load All Custom & Project Tasks #
###################################

Enter-Build {
    $script:HUGO_VERSION = '0.69.2'

    $ProjectDirectory = $BuildRoot | Split-Path -leaf
    $script:ArtifactDirectory = (Join-Path $BuildRoot 'artifacts')
    $null = New-Item $script:ArtifactDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue

    if ($LoadConstants)
    {
        $ConstantsFile = (Join-Path "${ENV:HOME}${ENV:USERPROFILE}" ".invokebuild/$ProjectDirectory.constants.ps1")
        if (Test-Path $ConstantsFile)
        {
            . $ConstantsFile
            Write-Build DarkYellow "Loaded: $ConstantsFile"
        }
        else
        {
            New-Item $ConstantsFile -ItemType File -Force
        }
    }
}

#Synopsis: Bootstrap all the required dependencies
check bootstrap-powershell-modules {
    if (-not (Get-InstalledModule PSDepend -ErrorAction SilentlyContinue)) { Install-Module PSDepend -Scope currentuser -Confirm:$false -Force -AllowClobber }
    Invoke-PSDepend -InputObject @{
        psdepend                            = 'latest'
        PsDependoptions                     = @{
            Version = 'Latest'
            Target  = 'currentuser'
        }
        'PSGalleryModule::dbatools'         = 'latest'
        # 'PSGalleryModule::AWS.Tools.Installer'      = 'latest'
        'PSGalleryModule::PSReadLine'       = 'latest'
        'PSGalleryModule::PSScriptAnalyzer' = 'latest'
        'PSGalleryModule::Pester'           = 'latest'
        'PSGalleryModule::PSGitHub'         = 'latest'
        # 'EnsureRequiredAWSToolsModulesAreInstalled' = @{
        #     DependencyType = 'Command'
        #     Source         = "Install-AWSToolsModule 'AWS.Tools.Common', 'AWS.Tools.SimpleSystemsManagement' -MinimumVersion 4.0.6 -CleanUp -Confirm:`$false -Scope CurrentUser"
        #     DependsOn      = 'AWS.Tools.Installer'
        # }
    } -Confirm:$false -Install -Import
}

check bootstrap-install-serverless-cli {
    ($PSVersionTable.OS -match 'Windows') ? { choco install serverless -y --no-progress --quiet } : { curl --progress-bar -o- -L https://slss.io/install | bash }
    bash -c export PATH="$HOME/.serverless/bin:$PATH"
    $ENV:PATH = "$($ENV:HOME)/.serverless/bin:$($ENV:PATH)"
}

check bootstrap-install-aws-vault {
    Write-Build DarkGray "Bootstraping aws-vault for: $($PSVersionTable.OS)"
    switch -Wildcard ($PSVersionTable.OS)
    {
        'Windows' { choco install aws-vault -y --no-progress --quiet }
        'Darwin' { brew cask install aws-vault }
        'Linux'
        {
            $releases = Get-GitHubRelease -Owner 99designs -RepositoryName 'aws-vault' -Latest | Get-GitHubReleaseAsset
            Write-Build DarkGray "Github Releases found: $(@($releases).count)"
            $downloadurl = $releases.Where{ $_.Name -match 'linux\-amd64' }.url
            sudo curl -L -o /usr/local/bin/aws-vault $downloadurl
            sudo chmod 755 /usr/local/bin/aws-vault
        }
    }
}

#Synposis: cleanup local artifacts
Task clean {
    Write-Build DarkGray "removing artifacts"
    Assert { $ArtifactDirectory -match 'artifacts' }
    remove $ArtifactDirectory
    New-Item -Path $ArtifactDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue *> $null
}

Task vscode-rebuild-tasks {
    if (-not (Get-InstalledScript 'New-VSCodeTask' -ErrorAction SilentlyContinue))
    {
        Write-Build DarkGray "Installing New-VscodeTask"
        Install-Script -name New-VsCodeTask -Force -Confirm:$false -Scope CurrentUser
    }
    #New-VSCodeTask.ps1 -BuildFile 'tasks.build.ps1' -Shell 'pwsh' #-WhereTask{ $_.Jobs.Count -gt 1 }
    . (Join-Path (Get-InstalledScript 'New-VSCodeTask').InstalledLocation 'New-VSCodeTask.ps1') -BuildFile ./task.build.ps1 -Shell 'pwsh' #-WhereTask{ $_.Jobs.Count -gt 1 }
    $TasksJsonFile = Join-Path $BuildRoot '.vscode\tasks.json'
    $Content = Get-Content $TasksJsonFile -Raw
    $NewContent = $Content.Replace('"command": "Invoke-Build -Task', '"command": "./build.ps1 -LoadConstants -Task')
    $UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($TasksJsonFile, $NewContent, $UTF8NoBOM)
}


Task powershell-format-code {
    $Settings = Join-Path $BuildRoot 'build/settings/powershell-formatting-settings.psd1'
    Write-Build DarkGray  "Applying Formatting to All PS1 Files in docs"
    $files = Get-ChildItem -Path $BuildRoot -Filter *.ps1 -Recurse | Where-Object FullName -NotMatch 'artifacts'
    Write-Build DarkGray  "Total Files to Process: $(@($Files).Count)"
    $x = 0
    $id = Get-Random
    Write-Progress -Id $id -Activity 'Formatting Files' -PercentComplete 0
    $files | ForEach-Object {

        $f = $_
        [string]$content = ([System.IO.File]::ReadAllText($f.FullName)).Trim()
        $formattedContent = Invoke-Formatter -ScriptDefinition $content -Settings  $Settings
        $UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllLines($f.FullName, $formattedContent, $UTF8NoBOM) #no bom by default here or could use 6.1 out-file with this built in
        Write-Progress -Id $id -Activity 'Formatting Files' -PercentComplete ([math]::Floor(($x / @($files).Count)) * 100) -CurrentOperation "Formatted $($f.FullName)" -ErrorAction SilentlyContinue
        $x++
    } -End {
        Write-Progress -Id $id -Activity 'Formatting Files' -Completed
    }
}

#Synopsis: Run quick commit action, for example, to allow updated formatting to be reapplied by CICD tool to all files after check-in, even if someone forgot to run this manually.
Task git-commit-push {
    git commit -am"ci: [$(git branch --show-current)] github actions commit"
    git push
}

##################
# Standard Tasks #
##################
Task . clean
Task tidy vscode-rebuild-tasks, powershell-format-code
Task bootstrap clean, bootstrap-powershell-modules, setup-hugo

########
# CICD #
########
Task github-tidy vscode-rebuild-tasks, powershell-format-code, git-commit-push
