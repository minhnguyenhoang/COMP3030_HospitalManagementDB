# Hospital Management Database Program
Final Project for COMP3030 - Fall Semester 2025, VinUniversity

```
Description Goes Here
```

## Team Members & Roles
- Nguyen Hoang Minh - V202401599 - Frontend Developer
- Do Quang Thai An - V202401422 - Manager & Backend Developer
- Pham Tuan Hung - V202401414 - Backend Developer
- Vu Duc Thanh - V202401636 - Debugging & Frontend Developper 

## Brief Description
### The Problem
In many healthcare facilities, the traditional method of managing patient records (either paper-based or via fragmented digital files) leads to significant inefficiencies. Key issues include:
- **Data Redundancy & Inefficiency:** Receptionists and doctors often waste time re-entering demographic information for returning patients, leading to slower check-in processes.
- **Fragmented Medical History:** A patient’s medical history, allergies, and past treatments are often not immediately accessible during a consultation. This lack of historical context can delay diagnosis or lead to safety risks (e.g., prescribing medication the patient is allergic to).
- **Lack of Insights:** Without a structured database, hospital administrators struggle to generate accurate statistics regarding patient turnout, disease trends, or revenue, making data-driven decision-making difficult.
### Brief Description of the System
The proposed project is a web-based Hospital Management System (HMS) designed exclusively for use by doctors and hospital administrative staff. The system serves as a centralized database to capture, organize, and analyze patient information.
**Key functionalities include:**
- **Intelligent Data Entry & Retrieval:** The system distinguishes between new and returning patients. For returning patients, the system automatically retrieves and populates existing demographic data (Name, Age, Gender, etc.) based on unique identifiers (National ID/Phone Number), significantly reducing input time.
- **Comprehensive Patient Profiles:** Upon looking up a patient, the system presents a dashboard displaying critical medical history, including recent visits, reported symptoms, diagnoses, and known allergies. This ensures doctors have a complete view of the patient's health status immediately.
- **Data Integrity & Statistics:** All inputs are strictly controlled by authorized staff to ensure data accuracy. The system will also include reporting features to visualize hospital statistics, such as patient volume and common diagnoses, aiding in administrative management.


## Functional & Non-Functional Requirements
- Management of administrators, employees, doctors, nurses of a hospital
- Management of patients in a hospital
- Data and medical history of patients
- History of patient appointments/bookings/medical procedures done at the hospital
- History of usage of medication stock, equipment or rooms

## Planned Core Entities
The planned core entities that the databases track are:
- **Doctors**: seniority and rank, working experience, expertise, departments, etc...
- **Nurses**: seniority, working experience, expertise, departments, etc...
- **Departments**: expertise, staff allocation, services, specialisations, etc...
- **Medical Procedures**: history of prescription/recommendation, approval date, head of operation, etc...
- **Medication & Stock**: stock, usage, history of procurement, history of usage/prescription, etc...
- **Medical Equipment**: department allocation, usage, date bought, usage history, etc...
- **Hospital Rooms**: history of usage, department assignment, status, category, etc...


## Tech Stack
```
TODO
```
## Projected Timeline (Tentatively)
| Phase                           | Dates                  | Key Activities                                       |
| ------------------------------- | ---------------------- | ---------------------------------------------------- |
| 1. Team & Topic Finalization    | By 01/12               | Topic selection, GitHub setup, README, submission    |
| 2. Peer Review                  | 08–09/12               | Receive feedback, refine project                     |
| 3. Design Document              | 10–13/12 (check 14/12) | Requirements, ERD, normalization, DDL, task division |
| 4. Backend Development          | 13–16/12               | Tables, views, procedures, triggers, indexing        |
| 5. UI/UX + Integration          | 16–19/12               | Frontend, CRUD, analytics, DB integration            |
| 6. Slides & Documentation       | 17–20/12               | Slides, GitHub cleanup, report                       |
| 7. Final Rehearsal & Submission | 21/12                  | Testing, rehearsal, submission                       |
