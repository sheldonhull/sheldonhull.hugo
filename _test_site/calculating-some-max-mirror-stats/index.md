# Calculating Some Max Mirror Stats


This turned out to be quite a challenge. I couldn&#39;t find anything that made this very clean and straight forward to calculate, and in my case I was trying to gauge how many mirroring databases I could run on a server.In my scenario, I wasn&#39;t running Expensive Edition (@BrentO coined this wonderful phrase), so was looking for the best way to assess numbers by doing mirroring on a large number of databases, in my case &gt; 300 eventually.
The documentation was... well.... a bit confusing. I felt like my notes were from the movie &#34;A Beautiful Mind&#34; as I tried to calculate just how many mirrors were too many!
This is my code snippet for calculating some basic numbers as I walked through the process. Seems much easier after I finished breaking down the steps.
And yes, Expensive Edition had additional thread impact due to multi-threading after I asked about this. Feedback is welcome if you notice a logical error. Note that this is &#34;theoretical&#34;. As I&#39;ve discovered, thread count gets reduced with increase activity so the number mirrored database that can be mirrored with serious performance issues gets decreased with more activity on the server.

{{&lt; gist sheldonhull  1335ab60accc21b95ece &gt;}}

