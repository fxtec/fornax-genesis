#!/bin/bash
#$(./aws.sh ecr get-login --no-include-email --region us-east-1)
docker build -t fornax-genesis .
#docker tag fornax-genesis:latest 184176894826.dkr.ecr.us-east-1.amazonaws.com/fornax-genesis:latest
#docker push 184176894826.dkr.ecr.us-east-1.amazonaws.com/fornax-genesis:latest

echo saving...
docker save -o ../volumes/fornax-genesis.tar fornax-genesis

#clean
docker system prune -f
docker volume prune -f
