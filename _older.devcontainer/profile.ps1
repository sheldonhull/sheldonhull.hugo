using namespace System.Management.Automation
using namespace System.Management.Automation.Language
$ProgressPreference = 'Ignore'
Register-ArgumentCompleter -Native -CommandName 'git-town' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $commandElements = $commandAst.CommandElements
    $command = @(
        'git-town'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
            }
            $element.Value
        }
    ) -join ';'
    $completions = @(switch ($command) {
        'git-town' {
            [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterName, 'Developer tool to print git commands run under the hood')
            [CompletionResult]::new('abort', 'abort', [CompletionResultType]::ParameterValue, 'Aborts the last run git-town command')
            [CompletionResult]::new('alias', 'alias', [CompletionResultType]::ParameterValue, 'Adds or removes default global aliases')
            [CompletionResult]::new('append', 'append', [CompletionResultType]::ParameterValue, 'Creates a new feature branch as a child of the current branch')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generates auto-completion scripts for Bash, zsh, fish, and PowerShell')
            [CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterValue, 'Displays your Git Town configuration')
            [CompletionResult]::new('continue', 'continue', [CompletionResultType]::ParameterValue, 'Restarts the last run git-town command after having resolved conflicts')
            [CompletionResult]::new('diff-parent', 'diff-parent', [CompletionResultType]::ParameterValue, 'Shows the changes committed to a feature branch')
            [CompletionResult]::new('discard', 'discard', [CompletionResultType]::ParameterValue, 'Discards the saved state of the previous git-town command')
            [CompletionResult]::new('hack', 'hack', [CompletionResultType]::ParameterValue, 'Creates a new feature branch off the main development branch')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Help about any command')
            [CompletionResult]::new('kill', 'kill', [CompletionResultType]::ParameterValue, 'Removes an obsolete feature branch')
            [CompletionResult]::new('main-branch', 'main-branch', [CompletionResultType]::ParameterValue, 'Displays or sets your main development branch')
            [CompletionResult]::new('new-branch-push-flag', 'new-branch-push-flag', [CompletionResultType]::ParameterValue, 'Displays or sets your new branch push flag')
            [CompletionResult]::new('new-pull-request', 'new-pull-request', [CompletionResultType]::ParameterValue, 'Creates a new pull request')
            [CompletionResult]::new('offline', 'offline', [CompletionResultType]::ParameterValue, 'Displays or sets offline mode')
            [CompletionResult]::new('perennial-branches', 'perennial-branches', [CompletionResultType]::ParameterValue, 'Displays your perennial branches')
            [CompletionResult]::new('prepend', 'prepend', [CompletionResultType]::ParameterValue, 'Creates a new feature branch as the parent of the current branch')
            [CompletionResult]::new('prune-branches', 'prune-branches', [CompletionResultType]::ParameterValue, 'Deletes local branches whose tracking branch no longer exists')
            [CompletionResult]::new('pull-branch-strategy', 'pull-branch-strategy', [CompletionResultType]::ParameterValue, 'Displays or sets your pull branch strategy')
            [CompletionResult]::new('rename-branch', 'rename-branch', [CompletionResultType]::ParameterValue, 'Renames a branch both locally and remotely')
            [CompletionResult]::new('repo', 'repo', [CompletionResultType]::ParameterValue, 'Opens the repository homepage')
            [CompletionResult]::new('set-parent-branch', 'set-parent-branch', [CompletionResultType]::ParameterValue, 'Prompts to set the parent branch for the current branch')
            [CompletionResult]::new('ship', 'ship', [CompletionResultType]::ParameterValue, 'Deliver a completed feature branch')
            [CompletionResult]::new('skip', 'skip', [CompletionResultType]::ParameterValue, 'Restarts the last run git-town command by skipping the current branch')
            [CompletionResult]::new('sync', 'sync', [CompletionResultType]::ParameterValue, 'Updates the current branch with all relevant changes')
            [CompletionResult]::new('undo', 'undo', [CompletionResultType]::ParameterValue, 'Undoes the last run git-town command')
            [CompletionResult]::new('version', 'version', [CompletionResultType]::ParameterValue, 'Displays the version')
            break
        }
        'git-town;abort' {
            break
        }
        'git-town;alias' {
            break
        }
        'git-town;append' {
            break
        }
        'git-town;completions' {
            [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterName, 'Developer tool to print git commands run under the hood')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'help for completions')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'help for completions')
            [CompletionResult]::new('--no-descriptions', 'no-descriptions', [CompletionResultType]::ParameterName, 'disable completions description for shells that support it')
            break
        }
        'git-town;config' {
            [CompletionResult]::new('reset', 'reset', [CompletionResultType]::ParameterValue, 'Resets your Git Town configuration')
            [CompletionResult]::new('setup', 'setup', [CompletionResultType]::ParameterValue, 'Prompts to setup your Git Town configuration')
            break
        }
        'git-town;config;reset' {
            break
        }
        'git-town;config;setup' {
            break
        }
        'git-town;continue' {
            break
        }
        'git-town;diff-parent' {
            break
        }
        'git-town;discard' {
            break
        }
        'git-town;hack' {
            [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Prompt for the parent branch')
            [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'Prompt for the parent branch')
            break
        }
        'git-town;help' {
            break
        }
        'git-town;kill' {
            break
        }
        'git-town;main-branch' {
            break
        }
        'git-town;new-branch-push-flag' {
            [CompletionResult]::new('--global', 'global', [CompletionResultType]::ParameterName, 'Displays or sets your global new branch push flag')
            break
        }
        'git-town;new-pull-request' {
            break
        }
        'git-town;offline' {
            break
        }
        'git-town;perennial-branches' {
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Prompts to update your perennial branches')
            break
        }
        'git-town;perennial-branches;update' {
            break
        }
        'git-town;prepend' {
            break
        }
        'git-town;prune-branches' {
            break
        }
        'git-town;pull-branch-strategy' {
            break
        }
        'git-town;rename-branch' {
            [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Force rename of perennial branch')
            break
        }
        'git-town;repo' {
            break
        }
        'git-town;set-parent-branch' {
            break
        }
        'git-town;ship' {
            [CompletionResult]::new('-m', 'm', [CompletionResultType]::ParameterName, 'Specify the commit message for the squash commit')
            [CompletionResult]::new('--message', 'message', [CompletionResultType]::ParameterName, 'Specify the commit message for the squash commit')
            break
        }
        'git-town;skip' {
            break
        }
        'git-town;sync' {
            [CompletionResult]::new('--all', 'all', [CompletionResultType]::ParameterName, 'Sync all local branches')
            [CompletionResult]::new('--dry-run', 'dry-run', [CompletionResultType]::ParameterName, 'Print the commands but don''t run them')
            break
        }
        'git-town;undo' {
            break
        }
        'git-town;version' {
            break
        }
    })
    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
if (-not (Get-InstalledModule PSReadline -ErrorAction SilentlyContinue))
{
    Install-Module PSReadline -Force -Confirm:$false -Scope CurrentUser
}
Import-Module PSReadLine
Import-CommandSuite


Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward


Set-PSReadLineKeyHandler -Key Ctrl+C -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste

# The built-in word movement uses character delimiters, but token based word
# movement is also very useful - these are the bindings you'd use if you
# prefer the token based movements bound to the normal emacs word movement
# key bindings.

Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

Invoke-Expression (@(&"/usr/local/bin/starship" init powershell --print-full-init) -join "`n")
New-Alias 'tf' -Value 'terraform' -Force -ErrorAction SilentlyContinue
#$ENV:PATH += ":/home/codespace/.dotnet/tools"
