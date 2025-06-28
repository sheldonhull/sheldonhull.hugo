# Enabling Instant File Initialization


Found a couple good walkthroughs on enabling instant file initialization. However, I&#39;m becoming more familar with the nuances of various setups and found it confusing in trying to map the correct user/group to enable this option. In my case, I had the SQL Service running under NT SERVICE/MSSSQLSERVER and as such this logic wasn&#39;t showing up when trying to find groups/users to add to the necessary permissions. Lo and behold...

I typed it in manually and it worked. If time permits I&#39;ll update the article later with a more technical explanation, but as of now, this is just a quick functional post to show what resolved the issue. Add the service account or group (whatever you have sql server in) to the perform volume maintenance privileges in the local security policy.

![Instant File Initialization 1](/images/enable_instant_file_initialization-2015-05-21_07_15_15_czth2j.png)
![Instant File Initialization 2](/images/enable_instant_file_initialization-2015-05-21_07_26_43_jg50g7.png)
![Instant File Initialization 3](/images/enable_instant_file_initialization-2015-05-21_08_03_18_zgnxp4.png)
![Instant File Initialization 4](/images/enable_instant_file_initialization-2015-05-21_08_31_55_nazxlf.png)

