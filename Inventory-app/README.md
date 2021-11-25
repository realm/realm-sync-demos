# Inventory App

With the help of Realm's Ecosystem and MongoDB, this Inventory app showcases the Inventory & Delivery operations of a mid/large store chain.

## Features

- Manage Products inventory across the store chain. 
- Manage active stores and its inventory.
- Assign a store manager to a store to manage it's realtime inventory.
- Create a delivery user to fullfil the delivery jobs.
- Alert store user on inventory shortage.
- Store user can create a job request to topup the inventory.
- Delivery user can perform jobs assigned to them.
## Tech

This app uses a number of tools and services to work properly:

- [Realm DB](https://docs.mongodb.com/realm/cloud/).
- [Realm Sync](https://docs.mongodb.com/realm/sync/).
- [React](https://reactjs.org/docs/getting-started.html).
- [Realm GraphQL](https://docs.mongodb.com/realm/graphql/).

## Folder Structure.

The project has multiple projects into it each works as a seperate project.

 - backend - The Realm project which has the realm config and schema's for this project.
 - frontend - The Admin dashboard to login and manage Inventory, Stores and Users.
 - android - The Store/Delivery User app.
 - ios - The Store/Delivery User app.
 
Each of this sub-folders will have required documentation to step-by-step installation and usage.
