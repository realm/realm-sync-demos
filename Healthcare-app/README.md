# Healthcare Solution

The solution showcases how MongoDB Realm and MongoDB Atlas can help address key usecases for the healthcare space using Flexible Sync & [FHIR](https://www.hl7.org/fhir/overview.html).

## Features

Doctor/Nurse App

- Register to the platform as a Doctor/Nurse.
- Pickup a hopital they want to serve.
- Take up a patient consultant and provide reports and medication.
- Assign a consultation to a Nurse for followup notes.

Patient App

- Register to the platform as a Patient.
- Add their pre-existing condition/illness for easy access.
- Create a consultation to a Doctor by the hospital they service.
- Review their consultation summary.


## Key Technical Highlights
- Offline use of mobile applications by the Patient and Doctor/Nurse.
- Real time sync of data 
- Demonstration of Flexible sync.

## Tech

This app uses a number of tools and services to work properly:

- [Realm DB](https://docs.mongodb.com/realm/cloud/).
- [Realm Sync](https://docs.mongodb.com/realm/sync/).

## Folder Structure.

The project has multiple elemented in it, each works as a seperate project.

 - Backend - The Realm project which has the realm config and schema's for this project.
 - Android - Mobile app for Patient and Doctors.
 - iOS - Mobile app for Patient and Doctors.
 
Each of these sub-folders has required documentation and step-by-step installation and usage guides.
