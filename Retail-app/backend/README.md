# Retail App Realm Configuration

The Configurations for the Realm app. Use Realm CLI to configure a new Realm App using this configurations.

## Installation & Confiuration of Realm App

* Create a new Programatic API key - Create a new Programatic API key on the Project Access manager. 
* Download & Install the Realm CLI using `npm install -g mongodb-realm-cli``
* Use the above created Public and Private key to login to the Realm CLI using `realm-cli login --api-key <my-api-key> --private-api-key <my-private-api-key>`
* Create a new the Realm App using `realm-cli push -y --project="<MongoDB Atlas Project ID>"`

