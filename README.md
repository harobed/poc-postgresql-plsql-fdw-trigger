This is a POC to test:

* [dblink](https://www.postgresql.org/docs/9.6/static/dblink.html)
* and [Trigger Procedures](https://www.postgresql.org/docs/9.6/static/plpgsql-trigger.html)

to insert some datas on remote [Postgresql](https://en.wikipedia.org/wiki/PostgreSQL) when data are
inserted on local database.

TODO: test the same think with [postgres_fdw](https://www.postgresql.org/docs/9.6/static/postgres-fdw.html)


```
$ docker-compose up -d
```

Drop databases:

```
$ docker-compose exec db1 su postgres -c "dropdb db1 | true; createdb db1"; docker-compose exec db2 su postgres -c "dropdb db2 | true; createdb db2"
```

Create two databases:

```
$ cat db1_create.sql | docker exec -i --user postgres `docker-compose ps -q db1` psql db1
$ cat db2_create.sql | docker exec -i --user postgres `docker-compose ps -q db2` psql db2
```


Insert data:

```
$ cat db1_insert.sql | docker exec -i --user postgres `docker-compose ps -q db1` psql db1
```


See data inserted by trigger on `db2`:

```
$ echo "select * from t2;" | docker exec -i --user postgres `docker-compose ps -q db2` psql db2                                                                                                                 id | field2
----+--------
 22 | row1
 23 | row2
 24 | row3
(3 rows)
```

See list foreign tables:

```
docker exec -it --user postgres `docker-compose ps -q db1` psql db1
psql (9.6.6)
Type "help" for help.

db1=# \det
 List of foreign tables
 Schema | Table | Server
--------+-------+--------
 public | t2    | db2
(1 row)
```


http://paquier.xyz/postgresql-2/postgres-9-4-feature-highlight-trigger-foreign-tables/
