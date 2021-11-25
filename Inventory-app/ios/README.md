# Store manager app
This app demonstrates a use case for logistics for product movement. 
App will be used by the store admin for creating jobs. To move product from store to store.
The delivery user uses the app to process the job while the product movement happens.

## Features:

## Login using email ID and Password
* Based on user type, different screens will be shown for a Store user and Delivery user

## Store Admin User
- View Store Inventory of Products
- Product Name, SKU number, Image, Product Description, Price, Total Quantity Available
- Local Alert if Quantity goes below 5 units (The 5 units is hardcoded, can be changed to any number)
- Search by Product Name within the Store inventory
- Create a delivery job
- Select Pickup Store and Address, Products and quantities, Destination Store and Address, Pickup - Date and Time
- Assign Delivery User
- Edit Delivery Job
- Reassign a new Delivery user if only in Open state.
- View Delivery jobs
- Open, In-Progress, Completed

## Delivery User
- View list of delivery jobs
- View Open (Assigned to the user)
- View details of the delivery job
- Pickup Store and Address, Products and quantities, Destination Store and Address, Pickup Date and Time
- Option to update the delivery job status to
- In-Progress
- Completed (Capture Date and Time of completion)

# Screens

## Login screen <br><img src="./Screens/1.png" width="400" height="700">
## Store Admin Dashboard screen <br><img src="./Screens/2.png" width="400" height="700">
## Product Details screen <br><img src="./Screens/3.png" width="400" height="700">
## Create Job screen <br><img src="./Screens/4.png" width="400" height="700">
## Add Product screen <br><img src="./Screens/5.png" width="400" height="700">
## Admin Dashboard Jobs screen <br><img src="./Screens/6.png" width="400" height="700">
## Delivery Job screen <br><img src="./Screens/7.png" width="400" height="700">
## Assign User screen <br><img src="./Screens/8.png" width="400" height="700">
## Admin Profile screen <br><img src="./Screens/9.png" width="400" height="700">
## Delivery Dashboard screen <br><img src="./Screens/10.png" width="400" height="700">
## Delivery Edit Job Status screen <br><img src="./Screens/11.png" width="400" height="700">