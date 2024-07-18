#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#Import GPG Key
echo "Importing AlmaLinux 8 new GPG Key"
# Wait for the URL to be reachable
echo "Waiting for RPM-GPG-KEY-AlmaLinux to be reachable"
until rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux
do
    rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux
    sleep 2
done
#Wait for the repo
echo "Waiting for repo to be reacheable"
curl --retry 20 -s -o /dev/null "https://download.docker.com/linux/centos/docker-ce.repo"
echo "Adding repo"
until dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
do
   dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sleep 2
done
dnf remove podman buildah
echo "Installing docker support"
until dnf -y install docker-ce docker-ce-cli containerd.io
do
    dnf -y install docker-ce docker-ce-cli containerd.io
    sleep 2
done
systemctl start docker.service
systemctl enable docker.service
#Wait for Internet access through the FGT by testing the docker regsitry
echo "Waiting for docker registry to be reacheable"
curl --retry 20 -s -o /dev/null "https://index.docker.io/v2/"
echo "installing containers"
retries=5
until docker run -d --restart unless-stopped --name demo-web-app -p 2000:80 -e HOST_MACHINE_NAME="$(hostname)" benoitbmtl/demo-web-app
do
    docker pull benoitbmtl/demo-web-app
    sleep 2
    retries=$((retries - 1))
done
retries=5
until docker run -d --restart unless-stopped --name juice-shop -p 3000:3000 bkimminich/juice-shop
do
    docker pull bkimminich/juice-shop
    sleep 2
    retries=$((retries - 1))
done
retries=5
until docker run -d --restart unless-stopped --name petstore3 -p 4000:8080 swaggerapi/petstore3
do
    docker pull swaggerapi/petstore3
    sleep 2
    retries=$((retries - 1))
done
cat << 'EOF' > /root/compose.yml
volumes:
  dvwa:
services:
  dvwa:
    image: ghcr.io/digininja/dvwa:latest
    pull_policy: always
    environment:
      - DB_SERVER=db
    depends_on:
      - db
    ports:
      - 1000:80
    restart: always
  db:
    image: docker.io/library/mariadb:10
    environment:
      - MYSQL_ROOT_PASSWORD=dvwa
      - MYSQL_DATABASE=dvwa
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
    volumes:
      - dvwa:/var/lib/mysql
    restart: unless-stopped
EOF
docker compose -f /root/compose.yml up -d
