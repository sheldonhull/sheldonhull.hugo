// sourced from https://github.com/ColinEberhardt/applause-button/issues/33#issuecomment-519374441
function loadClapCount() {
    // the clap counts for each article are displayed via span elements with the 'clap' class, find all these
    var elements = jQuery(".clap").toArray();
    // the article that each clap represents is indicates by the data-url attribute
    var urls = elements.map(function (el) {
        return el.getAttribute("data-url");
    });
    // send an API request that asks for the clap count of all of these articles
    jQuery.ajax({
        url: "https://api.applause-button.com/get-multiple",
        method: "POST",
        data: JSON.stringify(urls),
        headers: {
            "Content-Type": "text/plain"
        },
        contentType: "text/plain"
    }).done(function (claps) {
        // when the response returns, locate each element and update the count
        jQuery(".clap").each(function () {
            var elem = jQuery(this),
                url = elem.attr("data-url").replace(/^https?:\/\//, "");
            var clapCount = claps.find(function (c) { return c.url === url; });
            if (clapCount && clapCount.claps > 0) {
                elem.css("display", "initial")
                    .find(".count")
                    .html(clapCount.claps);
            }
        });
    });
