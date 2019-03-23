set-location C:
import-csv -path "disqus_csv_with_url_columnname_added"| %{ 
    [pscustomobject]@{
        Original= $_.url 
        Modified = $_.url -replace '\?.*$','' -replace '\-\d{1}$', '' -replace 'temp-slug-7\d', 'calculating-some-max-mirror-stats' -replace 'influxdb', 'influx-db' -replace 'https://sheldon-hull-gy5m.squarespace.com/blog/','https://www.sheldonhull.com/blog/' -replace 'ableton-live', 'ableton-live-&-lemur-setup-(from-a-windows-user)'
    }
} | export-csv X:\gh-pages\sheldonhull.github.io\Disqus-Fix2.csv