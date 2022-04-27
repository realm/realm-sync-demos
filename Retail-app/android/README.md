
# Store manager app
This app demonstrates a use case for logistics for product movement. 
App will be used by the store admin for creating jobs. To move product from store to store.
The delivery user uses the app to process the job while the product movement happens.

Note: Repalce google api key in string.xml for address search feature.

## Features:
## SignUp
- First Name, Last Name,Email,Password and User type (Store User or Delivery Person)
- Select Stores only for Store User
- Based on user type, different screens will be shown for a Store user and Delivery user
## Login using email ID and Password
* Based on user type, different screens will be shown for a Store user and Delivery user

## Store Admin User
- View Store Inventory of Products
- Swap the Store
- Product Name, SKU number, Image, Product Description, Price, Total Quantity Available
- Local Alert if Quantity goes below 5 units (The 5 units is hardcoded, can be changed to any number)
- Search by Product Name within the Store inventory
- Create a delivery job
- Select Pickup Store , Address, Products and quantities, Destination Store and Address, Pickup - Date and Time
- Assign Delivery User
- Edit Delivery Job
- Reassign a new Delivery user if only in Open state.
- View Delivery jobs
- Open, In-Progress, Completed
- Create an Order
- Select Pickup type(Store or Home delivery) , Select Address(Only for Home delivery), Customer Name and Email, Products and quantities,Select Payment Type(Cash or Credit card) , Date and Time
- Edit and Delete Order
- Create a delivery job from Order and
- Assign Delivery User
- Edit Delivery Job
- Reassign a new Delivery user if only in Open state.
- View Delivery jobs
- Open, In-Progress, Completed
- View User profile


## Delivery User
- View To-Do,In-Progress,Completed job in tabView
- View details of the delivery job
- Pickup Store and Address, Products and quantities, Destination Store and Address, Pickup Date and Time
- Option to update the delivery job status to
- In-Progress (Capture Location only for Delivery User jobs)
- Completed (Capture Date and Time of completion)

# Screens

## Splash screen <br><img src="./ScreenShots/1_Splash.png" width="400" height="700">
## Login screen <br><img src="./ScreenShots/2_Login.png" width="400" height="700">
## SignUp screen <br><img src="./ScreenShots/3_Signup.png" width="400" height="700">
## Store Admin Dashboard screen <br><img src="./ScreenShots/4_Admin_Dashboard.png" width="400" height="700">
## Product Details screen <br><img src="./ScreenShots/5_Product_Details.png" width="400" height="700">
## Swap Store screen <br><img src="./ScreenShots/6_Swap_store.png" width="400" height="700">
## Create Job screen <br><img src="./ScreenShots/7_Create_job.png" width="400" height="700">
## Date Pick screen <br><img src="./ScreenShots/8_date_picker.png" width="400" height="700">
## Time Pick screen <br><img src="./ScreenShots/9_time_picker.png" width="400" height="700">
## Jobs List screen <br><img src="./ScreenShots/10_Jobs_list.png" width="400" height="700">
## Edit Job screen <br><img src="./ScreenShots/11_Edit_job.png" width="400" height="700">
## Create Order for store screen <br><img src="./ScreenShots/12_Create_Order.png" width="400" height="700">
## Create Order for Home delivery screen <br><img src="./ScreenShots/13_Create_Order_Delivery_user.png" width="400" height="700">
## Order List screen <br><img src="./ScreenShots/14_Order_list.png" width="400" height="700">
## Order summary screen <br><img src="./ScreenShots/14_Order_summary.png" width="400" height="700">
## Filter Job screen <br><img src="./ScreenShots/15_Filter_job.png" width="400" height="700">
## Admin profile screen <br><img src="./ScreenShots/16_Profile.png" width="400" height="700">
## Delivery User TO-Do list screen <br><img src="./ScreenShots/17_Delivery_user_todo.png" width="400" height="700">
## Delivery User Job details screen <br><img src="./ScreenShots/18_Job_details.png" width="400" height="700">
## Delivery User In-Progress screen <br><img src="./ScreenShots/19_progress.png" width="400" height="700">
## Delivery User Update status screen <br><img src="./ScreenShots/20_change_job_status.png" width="400" height="700">
## Delivery User Completed job screen <br><img src="./ScreenShots/21_completed_job.png" width="400" height="700">

