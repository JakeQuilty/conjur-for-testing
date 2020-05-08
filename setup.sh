#!/bin/bash

set -e

docker-compose down
docker-compose pull
docker-compose run --no-deps --rm conjur data-key generate > data_key
export CONJUR_DATA_KEY="$(< data_key)"
docker-compose up -d
sleep 3
echo "Creating admin account..."
docker-compose exec conjur conjurctl account create myConjurAccount > admin_data
cat admin_data
echo "Initiating -url conjur -account myConjurAccount"
docker-compose exec client conjur init -u conjur -a myConjurAccount
docker-compose exec client conjur authn login -u admin
echo "Copying policy to CLI container..."
docker cp policy.yml conjur_client:/root/
echo "Loading policy into root..."
docker-compose exec client conjur policy load root /root/policy.yml > user_data
cat user_data
echo "Creating cert for API, and copying to ."
docker-compose exec client cp /root/.conjurrc /root/temp-conjurrc
docker-compose exec client conjur init -u https://host.docker.internal:8443 -a myConjurAccount
docker-compose exec client rm /root/.conjurrc
docker-compose exec client mv /root/temp-conjurrc /root/.conjurrc
docker cp conjur_client:/root/conjur-myConjurAccount.pem .
echo "DONE"
