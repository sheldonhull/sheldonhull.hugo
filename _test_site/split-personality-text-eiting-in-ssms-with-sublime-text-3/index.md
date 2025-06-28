# Split personality text editing in SSMS with Sublime Text 3


My preview post showed a demonstration of the multi-cursor editing power of Sublime Text 3 when speeding up your coding with SQL server.There is a pretty straight forward way to setup sublime (or one of your preferred text editors) to open the same file you are editing in SQL Management Studio without much hassle. I find this helpful when the type of editing might benefit from some of the fantastic functionality in Sublime.

## External Tool Menu

Go to `Tools &gt; External Tools`

![external tool menu](/images/external-tool-menu2_ggiuan.jpg)

## Setup Sublime Commands to Open

&lt;table data-preserve-html-node=&#34;true&#34;&gt;
&lt;tbody&gt;&lt;tr data-preserve-html-node=&#34;true&#34;&gt;
&lt;th data-preserve-html-node=&#34;true&#34;&gt;Setting&lt;/th&gt;
&lt;th data-preserve-html-node=&#34;true&#34;&gt;Value&lt;/th&gt;
&lt;/tr&gt;
&lt;tr data-preserve-html-node=&#34;true&#34;&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;Title&lt;/td&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;Edit in Sublime&lt;/td&gt;
&lt;/tr&gt;
&lt;tr data-preserve-html-node=&#34;true&#34;&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;Command&lt;/td&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;C:\Program Files\Sublime Text 3\sublime_text.exe&lt;/td&gt;
&lt;/tr&gt;
&lt;tr data-preserve-html-node=&#34;true&#34;&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;Arguments&lt;/td&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;$(ItemPath):$(CurLine):$(CurCol)&lt;/td&gt;
&lt;/tr&gt;
&lt;tr data-preserve-html-node=&#34;true&#34;&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;Initial Directory&lt;/td&gt;
&lt;td data-preserve-html-node=&#34;true&#34;&gt;$(ItemDir)&lt;/td&gt;
&lt;/tr&gt;
&lt;/tbody&gt;&lt;/table&gt;

_Limitation: Unsaved temporary files from SSMS are empty when you navigate to them. If you save the SQL file you will be able to correctly switch to the file in Sublime and edit in Sublime and SSMS together._

**Important:**
One thing I personally experienced that wasn&#39;t consistent was the handling of unsaved files. If the file is SqlQuery as a temp file that hasn&#39;t been saved, then this opening didn&#39;t work for me. Once I had the file named/saved, it worked perfectly, even bringing the cursor position in Sublime to match what was currently in SSMS.

![](/images/setup-sublime-commands-to-open2_h4au3z.jpg)

## Refresh File3

`Tools &gt; Options &gt; Environment &gt; Documents`
You can setup the auto-refresh to be in the background if you wish, or manually select the refresh from SSMS when it detects the change. If the auto-refresh happens while you are editing sometimes it caused me to have redo some work (or control-z) in Sublime, but for the most part it&#39;s pretty seamless.

![](/images/refresh-file2_hxke35.jpg)

