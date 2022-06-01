# Healthcare Solution

The solution showcases how MongoDB Realm and MongoDB Atlas can help address key usecases for the healthcare space using Flexible Sync & [FHIR](https://www.hl7.org/fhir/overview.html).

## Features

Realm App
- Configuration for schemas.
- Configuration for custom function authentications.
- Function and Triggers for the User Registrations.

## Tech

This app uses a number of tools and services to work properly:

- [Realm DB](https://docs.mongodb.com/realm/cloud/).
- [Realm Sync](https://docs.mongodb.com/realm/sync/).


## Installation & Confiuration of Realm App

* Create a new Programatic API key - Create a new Programatic API key on the Project Access manager. 
* Download & Install the Realm CLI using `npm install -g mongodb-realm-cli``
* Use the above created Public and Private key to login to the Realm CLI using `realm-cli login --api-key <my-api-key> --private-api-key <my-private-api-key>`
* Create a new the Realm App using `realm-cli push -y --project="<MongoDB Atlas Project ID>" --remote="<REALM App Id>"`
* Make sure, Hosting is enabled on Realm UI.



## Seed Data

Please find the seed data for Organzations and Codes to sideload on the database to be used accross the apps.