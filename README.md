# journal
So I added the docker
In order to run the app:
```
# Dev
docker-compose up
# Prod
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
# Test
docker-compose -f docker-compose.yml -f docker-compose.test.yml up test
```