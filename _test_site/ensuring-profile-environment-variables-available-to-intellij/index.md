# Ensuring Profile Environment Variables Available to Intellij


Open IntelliJ via terminal: ` open &#34;/Users/$(whoami)/Applications/JetBrains Toolbox/IntelliJ IDEA Ultimate.app&#34;`

This will ensure your `.profile`, `.bashrc`, and other profile settings that might be loading some default environment variables are available to your IDE.
For macOS, you&#39;d have to set in the `environment.plist` otherwise to ensure they are available to a normal application.

ref: [OSX shell environment variables – IDEs Support (IntelliJ Platform) | JetBrains](http://bit.ly/3p3BgHy)

