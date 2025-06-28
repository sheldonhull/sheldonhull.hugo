# Does sp_rename on a column preserve the ms_description?


Did some checking as couldn&#39;t find help in the MSDN documentation. My test on SQL 2016 shows that since the `column_id` isn&#39;t changing, the existing mapping of the description for the column is preserved.

{{&lt; gist sheldonhull  bf8fc1a0b0c3200da6dd95f2bdeb3314 &gt;}}


I know it&#39;s probably pretty obvious, but I had someone ask me, so figured proving the mapping for ms_description is maintained would be a good thing to walk through. Score another point for Microsoft, for design practices

