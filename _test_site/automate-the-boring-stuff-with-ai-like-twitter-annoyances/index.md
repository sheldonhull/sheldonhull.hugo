# Automate the Boring Stuff With Ai Like Twitter Annoyances


I wanted to remove all the clutter in my Twitter profile, and found the interests section.
A massive number of detected interests are there, and most aren&#39;t actually anything I care about. (Yahoo, eCommerce Technology, and more)

Each click sends an API request to remove, and there&#39;s no way I was going to go through years of content to click.
I pasted in the div from inspect element and with a few additional prompts to improve it, generated a snippet to past in the Chrome developer console that:

- Clicks each item for me, with some graceful cooldown logic since API throttling nearly immediately occurred.
- Logs the total items to process at the start.
- Logs the start of each request with the format Starting request x/y.
- Logs a successful uncheck with a ✔ emoji and the format ✔ Successfully unchecked x/y.
- Logs if an item is already unchecked.
- Estimates the remaining time to complete the process and logs it after each action.
- At the end of the process, logs that all items have been processed.

```javascript
(function() {
    const checkboxes = document.querySelectorAll(&#39;input[type=&#34;checkbox&#34;]&#39;);
    let total = checkboxes.length;
    let index = 0;
    let delay = 500; // Delay between uncheck actions to allow for UI updates and not to trigger rate limits

    console.log(`Total checkboxes to process: ${total}`);

    function scrollToElement(element) {
        element.scrollIntoView({ behavior: &#39;smooth&#39;, block: &#39;center&#39; });
    }

    function uncheckCheckbox() {
        if (index &gt;= total) {
            log(&#39;Completed processing all checkboxes.&#39;);
            return;
        }

        const checkbox = checkboxes[index];
        scrollToElement(checkbox);

        if (checkbox.checked) {
            log(`Unchecking checkbox ${index &#43; 1}/${total}`);
            checkbox.click();

            // Wait for any potential dynamic updates
            setTimeout(() =&gt; {
                if (checkbox.getAttribute(&#39;aria-checked&#39;) === &#39;false&#39; || !checkbox.checked) {
                    log(`Successfully unchecked checkbox ${index &#43; 1}/${total}`);
                    index&#43;&#43;;
                    delay = 500; // Reset the delay after successful uncheck
                } else {
                    log(`Failed to uncheck checkbox ${index &#43; 1}/${total}. Retrying...`, &#39;error&#39;);
                    delay &#43;= 500; // Increase the delay before retrying
                }
                setTimeout(uncheckCheckbox, delay); // Move to next checkbox
            }, delay);
        } else {
            log(`Checkbox ${index &#43; 1}/${total} is already unchecked.`);
            index&#43;&#43;;
            setTimeout(uncheckCheckbox, 0); // Move to next checkbox
        }
    }

    // Listen for 503 requests from Twitter
    window.addEventListener(&#39;fetch&#39;, (event) =&gt; {
        if (event.request.url.includes(&#39;twitter.com&#39;) &amp;&amp; event.response.status === 503) {
            log(&#39;503 error detected from Twitter. Retrying...&#39;, &#39;error&#39;);
            delay &#43;= 500; // Increase the delay before retrying
        }
    });

    function log(message, type = &#39;log&#39;) {
        console[type](`[TwitterCleanup] ${message}`);
    }

    uncheckCheckbox(); // Start the process
})();
```

Considering I don&#39;t want to spend the time to dive into javascript, I love how it gives options to quickly knock out automation I wouldn&#39;t make the time to do manually.

