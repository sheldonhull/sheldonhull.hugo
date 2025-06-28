# Red Gate SQL Source Control v4 offers schema locks


Looks like the rapid release channel now has a great feature for locking database objects that you are working on. Having worked in a shared environment before, this could have been a major help. It&#39;s like the poor man&#39;s version of checking an object out in visual studio except on database objects! With multiple developers working in a shared environment, this might help reduce conflicting multiple changes on the same object.

Note that this doesn&#39;t look to evaluate dependency chains, so there is always the risk of a dependent object being impacted. I think though that this has some promise, and is a great improvement for shared environment SQL development that uses source control.

