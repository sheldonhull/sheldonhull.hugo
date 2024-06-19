---

date: 2024-06-19T19:10:06+0000
title: Automate the Boring Stuff With Ai Like Twitter Annoyances
slug: automate-the-boring-stuff-with-ai-like-twitter-annoyances
tags:
- tech
- development
- microblog
- ai
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

I wanted to remove all the clutter in my Twitter profile, and found the interests section.
A massive number of detected interests are there, and most aren't actually anything I care about. (Yahoo, eCommerce Technology, and more)

Each click sends an API request to remove, and there's no way I was going to go through years of content to click.
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
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    let total = checkboxes.length;
    let index = 0;
    let delay = 500; // Delay between uncheck actions to allow for UI updates and not to trigger rate limits

    console.log(`Total checkboxes to process: ${total}`);

    function scrollToElement(element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    function uncheckCheckbox() {
        if (index >= total) {
            log('Completed processing all checkboxes.');
            return;
        }

        const checkbox = checkboxes[index];
        scrollToElement(checkbox);

        if (checkbox.checked) {
            log(`Unchecking checkbox ${index + 1}/${total}`);
            checkbox.click();

            // Wait for any potential dynamic updates
            setTimeout(() => {
                if (checkbox.getAttribute('aria-checked') === 'false' || !checkbox.checked) {
                    log(`Successfully unchecked checkbox ${index + 1}/${total}`);
                    index++;
                    delay = 500; // Reset the delay after successful uncheck
                } else {
                    log(`Failed to uncheck checkbox ${index + 1}/${total}. Retrying...`, 'error');
                    delay += 500; // Increase the delay before retrying
                }
                setTimeout(uncheckCheckbox, delay); // Move to next checkbox
            }, delay);
        } else {
            log(`Checkbox ${index + 1}/${total} is already unchecked.`);
            index++;
            setTimeout(uncheckCheckbox, 0); // Move to next checkbox
        }
    }

    // Listen for 503 requests from Twitter
    window.addEventListener('fetch', (event) => {
        if (event.request.url.includes('twitter.com') && event.response.status === 503) {
            log('503 error detected from Twitter. Retrying...', 'error');
            delay += 500; // Increase the delay before retrying
        }
    });

    function log(message, type = 'log') {
        console[type](`[TwitterCleanup] ${message}`);
    }

    uncheckCheckbox(); // Start the process
})();
```

Considering I don't want to spend the time to dive into javascript, I love how it gives options to quickly knock out automation I wouldn't make the time to do manually.
