---
date: "2017-02-18T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Implicit Transactions"
slug: "implicit-transactions"
---

Never messed around with this setting in the server configuration, so I was unfamilar with the impact it would have.If I ran a statement with something like the following:

    insert into foo
    select bar
    insert into foo
    select bar

I know that if the first had an aborting error, such as text was too long, the second statement would not complete as the batch would have failed.
If you instead did

    insert into foo
    select bar
    GO
    insert into foo
    select bar

and had the same error, the second would be completed, since the first would throw an error, but the GO separates the second statement explicitly into another batch, and therefore another transaction.
Interestingly, the `Implicit Transactions` option changes the behavior to making each statement act as if it was encapsulated by `begin transaction --- commit transaction` instead of requiring this to be defined.
So if you set `implicit transactions` on and ran the statement below with no go statement:

    insert into foo
    select bar
    insert into foo
    select bar

It is really operating as if:

    begin transaction
    insert into foo
    select bar
    commit transaction
    GO
    begin transaction
    insert into foo
    select bar
    commit transaction

[MSDN - Implicit Conversions](http://bit.ly/1U0362O) is a resource that further documents the behavior, indicating that a rollback for the particular transaction is handled automatically. This means that since that each statement is treated as a transaction that it will not abort the second statement and terminate execution if the first experinces the error, since by "implicit conversions" this would be handled separately.
MSDN article with example code to walk through it
[https://technet.microsoft.com/en-us/library/ms190230(v=sql.105).aspx](https://technet.microsoft.com/en-us/library/ms190230(v=sql.105).aspx)

    /*******************************************************
    STEP 1: SETUP
    *******************************************************/
    use tempdb;
    set nocount on;
    set xact_abort off;
    set implicit_transactions off;
    if object_id('dbo.TestImplicitTrans','U') is not null
    begin
    print 'Dropped dbo.TestImplicitTrans per existed';
    drop table dbo.TestImplicitTrans;
    end;
    print 'create table dbo.TestImplicitTrans';
    create table dbo.TestImplicitTrans
    (
    test_k int primary key
    identity(1,1)
    not null
    ,random_text varchar(5) not null
    );
    go
    /*******************************************************
    TEST 1:
    xact_abort off
    set implicit_transactions off
    Results in:
    - first transaction fails
    - second transaction succeeds (this is due to xact_abort off not being activated)
    test_k  random_text
    2           12345
    *******************************************************/
    use tempdb;
    go
    set nocount on;
    set xact_abort off;
    set implicit_transactions off;
    truncate table dbo.TestImplicitTrans;
    print 'Statement 1 START';
    insert into dbo.TestImplicitTrans (random_text) values ('00001x');
    print 'Current trancount: ' + cast(@@trancount as varchar(100));
    insert into dbo.TestImplicitTrans (random_text) values ('00002');
    print 'Current trancount: ' + cast(@@trancount as varchar(100));
    insert into dbo.TestImplicitTrans (random_text) values ('00003');
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 1 END';
    print char(13) + char(13) + 'Statement 2 START';
    insert  into dbo.TestImplicitTrans
    (random_text)
    values
    ('12345'  -- random_text - varchar(5)
    );
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 2 END';
    select
    *
    from
    dbo.TestImplicitTrans as TIT;
    go
    /*******************************************************
    TEST 2:
    xact_abort on
    set implicit_transactions off
    Results in:
    - first transaction fails
    - second transaction doesn't execute due to xact abort being set on
    test_k  random_text
    NONE
    *******************************************************/
    use tempdb;
    go
    set nocount on;
    set xact_abort on;
    set implicit_transactions off;
    truncate table dbo.TestImplicitTrans;
    print 'Statement 1 START';
    insert  into dbo.TestImplicitTrans
    (random_text)
    values
    ('12345x'  -- random_text - varchar(5)  ONE CHARACTER TOO LARGE
    );
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 1 END';
    print char(13) + char(13) + 'Statement 2 START';
    insert  into dbo.TestImplicitTrans
    (random_text)
    values
    ('12345'  -- random_text - varchar(5)
    );
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 2 END';
    select
    *
    from
    dbo.TestImplicitTrans as TIT;
    go
    /*******************************************************
    TEST 2:
    xact_abort off
    set implicit_transactions off
    Results in:
    - first transaction fails
    - second transaction doesn't execute due to xact abort being set on
    test_k  random_text
    NONE
    *******************************************************/
    use tempdb;
    go
    set nocount on;
    set xact_abort on;
    set implicit_transactions on;
    truncate table dbo.TestImplicitTrans;
    print 'Statement 1 START';
    insert  into dbo.TestImplicitTrans
    (random_text)
    values
    ('12345x'  -- random_text - varchar(5)  ONE CHARACTER TOO LARGE
    );
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 1 END';
    print char(13) + char(13) + 'Statement 2 START';
    insert  into dbo.TestImplicitTrans
    (random_text)
    values
    ('12345'  -- random_text - varchar(5)
    );
    print 'Successfully inserted: ' + cast(@@rowcount as varchar(10));
    print 'Statement 2 END';
    select
    *
    from
    dbo.TestImplicitTrans as TIT;
    go
