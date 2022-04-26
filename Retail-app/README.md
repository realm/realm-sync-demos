# Inventory App

With the help of Realm's Ecosystem and MongoDB, this Inventory app showcases the Inventory & Delivery operations of a mid/large store chain.

## Features

- Manage Products inventory across a store chain. 
- Manage active stores and their inventory.
- Assign a store manager to a store to manage its realtime inventory.
- Create a delivery user to fullfil the delivery jobs.
- Alert store users to inventory shortage.
- Store users can create a job request to topup inventory.
- Delivery users can perform jobs assigned to them.
## Tech

This app uses a number of tools and services to work properly:

- [Realm DB](https://docs.mongodb.com/realm/cloud/).
- [Realm Sync](https://docs.mongodb.com/realm/sync/).
- [React](https://reactjs.org/docs/getting-started.html).
- [Realm GraphQL](https://docs.mongodb.com/realm/graphql/).

## Folder Structure.

The project has multiple elementd in it, each works as a seperate project.

 - backend - The Realm project which has the realm config and schema's for this project.
 - frontend - The Admin dashboard to login and manage Inventory, Stores, Jobs and Users.
 - android - The Store/Delivery User app.
 - iOS - The Store/Delivery User app.
 
Each of these sub-folders has required documentation and step-by-step installation and usage guides.
