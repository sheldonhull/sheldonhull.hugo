# Failover all databases to other server


Quick snippet I threw together to help with failing over synchronized databases to the other server in bulk. No way I want to click that darn Fail-over button repeatedly. This scripts the statements to print (i commented out the exec portion) so that you can preview the results and run manually.Note that it&#39;s also useful to have a way to do this as leaving databases running on the mirror server for an indefinite period can violate licensing terms on the secondary server when it&#39;s a fail-over server and not meant to be the primary.

{{&lt; gist sheldonhull  b753658689b40b2883c5 &gt;}}

