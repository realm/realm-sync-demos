# Retail App

With the help of Realm's Ecosystem and MongoDB, this Inventory app showcases the Inventory & Delivery operations of a mid/large store chain.

## Features

- Manage Products inventory across a store chain. 
- Manage active stores and their inventory.
- Assign a store manager to a store to manage its realtime inventory.
- Create a delivery user to fullfil the delivery jobs.
- Alert store users to inventory shortage.
- Store users can create a job request to topup inventory.
- Delivery users can perform jobs assigned to them.

- Store user can create order.
- Store user will create job for order and assign it to delivery user.
- Store user can swap btween stores.
- Customer can track the location of the delivery person thru a web app.

## Tech

This app uses a number of tools and services to work properly:

- [Realm DB](https://docs.mongodb.com/realm/cloud/).
- [Realm Sync](https://docs.mongodb.com/realm/sync/).
- [React](https://reactjs.org/docs/getting-started.html).
- [Realm GraphQL](https://docs.mongodb.com/realm/graphql/).

## Folder Structure.

The project has multiple elementd in it, each works as a seperate project.

 - backend - The Realm project which has the realm config and schema's for this project.
 - android - The Store/Delivery User app.
 - iOS - The Store/Delivery User app.
 
Each of these sub-folders has required documentation and step-by-step installation and usage guides.
