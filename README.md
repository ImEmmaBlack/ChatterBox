# README


running locally


clone
Ensure you have docker and docker compose installed

Run the following to get up and running locally
```
docker-compose build
docker-compose run website rake db:create
docker-compose run website rake db:migrate
docker-compose up
```

The front end for this app can be found here: 
https://github.com/ImEmmaBlack/ChatterBox-React

