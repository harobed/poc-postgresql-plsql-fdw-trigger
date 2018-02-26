.PHONY: reset
reset:
	docker-compose exec db1 su postgres -c "dropdb db1 | true; createdb db1"; docker-compose exec db2 su postgres -c "dropdb db2 | true; createdb db2"

.PHONY: create
create:
	cat db2_create.sql | docker exec -i --user postgres `docker-compose ps -q db2` psql db2
	cat db1_create.sql | docker exec -i --user postgres `docker-compose ps -q db1` psql db1

.PHONY: insert
insert:
	cat db1_insert.sql | docker exec -i --user postgres `docker-compose ps -q db1` psql db1
