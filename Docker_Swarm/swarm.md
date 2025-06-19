# инициализация swarm на master node
docker swarm init

# покинуть swarm
docker swarm leave -f

# Присвоить label на ноду
docker node update --label-add postgres=true nodeName

# присоединить worker ноды
docker swarm join --token SWMTKN-1-1syc7fhxsgkyoot71r2io7x8n5xaxmxulwtcfsovgsf099so6s-761a3k66huuq1yd0bx2mso8y5 10.217.6.191:2377

# список доступных нод
docker node ls

# список сервисов swarm
docker service ls

# деплой docker-stack.yml
docker stack deploy --with-registry-auth -c docker-stack-dev.yml pk

# остановить docker-stack.yml
docker stack rm pk

# лог контейнера
docker service logs -f pk_flower_backend

# состояние сервиса
docker service ps pk_postgres

# данный о контейнере
docker service ps pk_postgres

# удалить volume контейнера
docker volume ls
docker volume rm pk_pgdata pk_pgadmin_backend

# инспектирование контейнера
docker inspect pk_postgres

# rollback сервиса
docker service rollback pk_websocket