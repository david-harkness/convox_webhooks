# Argos the Loyal

### Installation
bundle install

### Running Locally
convox start


### Deployment
convox deploy
convox exec web rake db:migrate
convox ps | grep web

convox exec [process id] rake db:migrate

