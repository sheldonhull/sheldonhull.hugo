# 2020-05-05T20:12:01&#43;00:00

Finally got [atomic algolia](https://forestry.io/blog/search-with-algolia-in-hugo/) to work in CICD for my hugo blog. I&#39;ve tried tackling this in many ways over time, but this finally just worked with plug and play ease thanks to just adding a line to the hugo build `netlify.toml` file.

If you want to try this out, assuming you&#39;ve already got an algolia index, json file generated and all... then just:

1. Setup env variables in netlify build
2. Add the following line to your netlify production build script

```shell
echo &#34;Starting atomic-algolia update&#34;
npm run algolia
```

You should get the following output from your netlify build if everything went right. No hits to algolia if you didn&#39;t change your indexes! 🎉

```text
3:13:47 PM: &gt; sheldonhull.hugo@1.0.0 algolia /opt/build/repo
3:13:47 PM: &gt; atomic-algolia
3:13:47 PM: [Algolia] Adding 0 hits to sheldonhull.com
3:13:47 PM: [Algolia] Updating 0 hits to sheldonhull.com
3:13:47 PM: [Algolia] Removing 0 hits from sheldonhull.com
3:13:47 PM: [Algolia] 156 hits unchanged in sheldonhull.com
```

