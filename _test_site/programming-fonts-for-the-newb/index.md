# Programming Fonts For The Newb


## the camps

Once you get into coding fonts, you&#39;ll find that there are two primary camps.

1.  Don&#39;t give a crap about it. &#34;I&#39;ll use defaults for everything and probably wouldn&#39;t care if I was coding in Arial&#34;. If this is you, then this post is definitely not for you. Please continue to enjoy Comic Sans with my pity. :-)
2.  Font aficionados &#34;Your world will change forever once you use this specific font! It will increase your productivity 300%&#34;

Inside the font afficiando realm, you have various subcultures.

*   Fixed Font Only
*   Elastic Tabstops [are the future](http://bit.ly/2GXrrFR), why can&#39;t anyone get with the program? (Elastic tabtop fonts allow proportional fonts with better alignment )
*   Ligature Fonts changed my world

## cool resource

One really cool resource for exploring these various types of fonts is [Programming Fonts - Test Drive](http://bit.ly/2pFIu6P). This is a pretty cool resource to preview various fonts and find links and resources for them.

## monospaced

Monospaced fonts ensure that every character take up the same amount of space regardless. This means a period takes up the same space as any other letter of the alphabet.

The goal in recommending this for code editing has to do with the purpose of what&#39;s being written and read. In reading your eyes flow over words, and punctuation, while important, supports the words. It doesn&#39;t need to take up the same space. In code, every punctuation character is just as important as every single letter written. If you have a bunch of nested formulas for example, reading

```powershell
(&#39;....Total time to process: {0:g}&#39; -f [timespan]::fromseconds(((Get-Date)-$StartTime).Totalseconds).ToString(&#39;hh\:mm\:ss&#39;))
```

becomes harder than ensuring all the punctuation and special characters are easily readable like this:

```powershell
(&#39;....Total time to process: {0:g}&#39; -f [timespan]::fromseconds(((Get-Date)-$StartTime).Totalseconds).ToString(&#39;hh\:mm\:ss&#39;))
```

Visual Studio, SSMS, and other editors by default choose a monospaced font in code editing. However, there are additional options besides the built in fonts.

## some i&#39;ve explored

1.  Bitstream Vera Sans Mono: My go to for a long time. It&#39;s aesthetically nice, and has a bit of the Ubuntu styling with some rounder edges.
2.  Fira Code Retina: Very nice with ligature support. This has become my current favorite due to the very nice style with the added perk of the ligatures. That&#39;s a nice little typography enhancement that really makes special combinations of characters stand out for readability. This is just a rendering feature that doesn&#39;t impact the underlying text per documentation:
&gt; This is just a font rendering feature: underlying code remains ASCII-compatible. This helps to read and understand code faster. [FiraCode Github](https://github.com/tonsky/FiraCode)



## what to what to look for

As you dive into the world of exploring fonts, here&#39;s a couple things I&#39;d look for.

1.  Characters that can hide problems are easily identified such as a period, or dash, most monospaced fonts are great for this, but some have smaller symbols that might make them a little less readable.
2.  Resizes well for your target zoom. I&#39;ve tried some fonts that don&#39;t seem to look right once you change your zoom level or the size of the font. I looked up some details on this and apparently some fonts are bitmapped, and some vector images. If you are using bitmapped fonts, then the target size is ideal, while adjusting zoom level can cause blurriness or fuzzy quality as it&#39;s not going to rescale like a vector based font would. This isn&#39;t bad if you are ok with the normal font size levels.


{{&lt; fancybox-gallery
    &#34;fontgallery&#34;
&#34;testcaption&#34;
    &#34;fira-code-mono.png&#34;
    &#34;source-code-pro.png&#34;
    &#34;bitstream-vera-sans-mono.png&#34;
&gt;}}



So far my personal favorite is Fira Code, so check that one out if you are looking for something interesting to try.


## resource links

[FiraCode Github](http://bit.ly/2fpxcSQ)

