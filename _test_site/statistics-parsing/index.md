# Statistics Parsing


Never really enjoyed reading through the statistics IO results, as it makes it hard to easily guage total impact when you have a long list of tables. A friend referred me to: http://www.statisticsparser.com/ This site is great! However, I really don&#39;t like manually copying and pasting the results each time. I threw together a quick autohotkey script that will detect your clipboard change event, look for &#34;scan count&#34; keyword, and then open a &#34;chrome app&#34;, paste the results and submit. Note that I have the option &#34;window name enabled&#34; at the bottom of the textbox on the webpage. If you don&#39;t the tabcount navigation might be a little off, so tweak this if you want.

{{&lt; gist sheldonhull  01631b28176f71ce4789 &gt;}}

