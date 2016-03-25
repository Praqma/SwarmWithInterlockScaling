docker-machine create -d virtualbox mh-keystore

eval "$(docker-machine env mh-keystore)"

docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap


docker-machine create \
-d virtualbox \
--swarm --swarm-master \
--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
swarm-master


docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
swarm-slave-01 &

docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
swarm-slave-02 &


wait

eval $(docker-machine env --swarm swarm-master)
docker info

read -p "Press [Enter] key to start containers..."


docker-compose -f application/docker-compose.yml up -d

echo "
add $(docker-machine ip swarm-master) web.docker.demo to /etc/hosts
"
echo "Visit http://$(docker-machine ip swarm-master)/haproxy?stats
username stats, password interlock
"

echo "Visit http://web.docker.demo in a browser to hit the webapp container
"

read -p "Press [Enter] key to scale webapp container to 5..."
docker-compose -f application/docker-compose.yml scale webapp=5

