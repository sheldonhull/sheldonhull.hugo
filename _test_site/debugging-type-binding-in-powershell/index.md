# Debugging Type Binding in PowerShell


Some effort I spent in researching Type Binding in Stack Overflow to help answer a question by [Chris Oldwood](https://stackoverflow.com/users/106119/chris-oldwood) helped me solidify my understanding of the best way to debug more  complicated scenarios such as this in PowerShell.


&gt; [Why does this PowerShell function&#39;s default argument change value based on the use of . or &amp; to invoke a command within it? ](https://stackoverflow.com/q/53860403/68698)

Spent some digging into this and this is what I&#39;ve observed.

First for clarity I do not believe that you should consider the NullString value the same as null in a basic comparison. Not sure why you need this either, as this is normally something I&#39;d expect from c# development. You should be able to just use `$null` for most work in PowerShell.

```powershell
if($null -eq [System.Management.Automation.Language.NullString]::Value)
{
    write-host &#34;`$null -eq [System.Management.Automation.Language.NullString]::Value&#34;
}
else
{
    write-host &#34;`$null -ne [System.Management.Automation.Language.NullString]::Value&#34;
}
```

Secondly, the issue is not necessarily because of the call operator, ie `&amp;`. I believe instead you are dealing with underlying parameter binding coercion. Strong data typing is definitely a weak area for PowerShell, as even explicitly declared `[int]$val` could end up being set to a string type by PowerShell automatically in the next line when writing `Write-Host $Val`.

To identify the underlying behavior, I used the `Trace-Command` function ([Trace Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/trace-command?view=powershell-6)) .

I changed the Use-Dot to just call the function as no write-host was needed to output the string.

```powershell
function Use-Ampersand
{
    param(
        [string]$NullString = [System.Management.Automation.Language.NullString]::Value
    )
    Format-Type $NullString
    &amp;cmd.exe /c exit 0
}
```

The Format-Type I modified to also use what is considered a better practice of `$null` on the left, again due to type inference.

```powershell
function Format-Type($v= [System.Management.Automation.Language.NullString]::Value)
{

    if ($null  -eq $v)
    {
     &#39;(null)&#39;
    }
    else {
        $v.GetType().FullName
     }
}
```

To narrow down the issue with the data types, I used the following commands, though this is not where I found insight into the issue. Theyh  when called directly worked the same.

```powershell
Trace-Command -Name TypeConversion -Expression { Format-Type $NullString} -PSHost
Trace-Command -Name TypeConversion -Expression { Format-Type ([System.Management.Automation.Language.NullString]$NullString) } -PSHost
```

However, when I ran the functions using TypeConversion tracing, it showed a difference in the conversions that likely explains some of your observed behavior.

```powershell
Trace-Command -Name TypeConversion  -Expression { Use-Dot} -PSHost
Trace-Command -Name TypeConversion  -Expression { Use-Ampersand} -PSHost
```

```powershell
# USE DOT
DEBUG: TypeConversion Information: 0 :  Converting &#34;&#34; to &#34;System.String&#34;.
DEBUG: TypeConversion Information: 0 :      Converting object to string.
DEBUG: TypeConversion Information: 0 :  Converting &#34;&#34; to &#34;System.Object&#34;. &lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
DEBUG: TypeConversion Information: 0 :  Converting &#34;.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW;.CPL&#34; to &#34;System.String&#34;.
DEBUG: TypeConversion Information: 0 :      Result type is assignable from value to convert&#39;s type
```

`OUTPUT: (null)`

```powershell
# Use-Ampersand
DEBUG: TypeConversion Information: 0 : Converting &#34;&#34; to &#34;System.String&#34;.
DEBUG: TypeConversion Information: 0 :     Converting object to string.
DEBUG: TypeConversion Information: 0 : Converting &#34;&#34; to &#34;System.String&#34;. &lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
DEBUG: TypeConversion Information: 0 :     Converting null to &#34;&#34;.        &lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
DEBUG: TypeConversion Information: 0 : Converting &#34;.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW;.CPL&#34; to &#34;System.String&#34;.
DEBUG: TypeConversion Information: 0 :     Result type is assignable from value to convert&#39;s type
```

`OUTPUT: System.String`

The noticeable difference is in `Use-Ampersand` it shows a statement of `Converting null to &#34;&#34;` vs `Converting &#34;&#34; to &#34;System.Object&#34;`.

In PowerShell, `$null &lt;&gt; [string]&#39;&#39;`. An empty string comparison will pass the null check, resulting in the success of outputting `GetType()`.

# A Few Thoughts On Approach With PowerShell

Why it&#39;s doing this, I&#39;m not certain, but before you invest more time researching, let me provide one piece of advice based on learning the hard way.

_If start dealing with issues due to trying to coerce data types in PowerShell, first consider if PowerShell is the right tool for the job_

Yes, you can use type extensions. Yes, you can use .NET data types like `$List = [System.Collections.Generic.List[string]]::new()` and some .NET typed rules can be enforced. However, PowerShell is not designed to be a strongly typed language like C#. Trying to approach it like this will result in a many difficulties. While I&#39;m a huge fan of PowerShell, I&#39;ve learned to recognize that it&#39;s flexibility should be appreciated, and it&#39;s limits respected.

If I really had issues that required mapping `[System.Management.Automation.Language.NullString]::Value` so strongly, I&#39;d consider my approach.

That said, this was a challenging investigation that I had to take a swing at, while providing my 10 cents afterwards.

# Other Resources

After posting my answer, I found another [answer](https://stackoverflow.com/a/51354791/68698) that seemed relevant, and also backs up the mentioning of not using `[NullString]` normally, as its usage in PowerShell is not really what it was designed for.

_Stackoverflow specific content republished under CC-BY-SA_

