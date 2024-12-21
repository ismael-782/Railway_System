# Railway Application

<img src="https://github.com/user-attachments/assets/0e6eead0-8b05-4d4b-82e2-a933fb7b55c6" alt="Screenshot 2024-12-19 200126" width="250"/>
<img src="https://github.com/user-attachments/assets/68f38678-2524-4bd9-8de9-0da8ad406c94" alt="Screenshot 2024-12-19 200145" width="250"/>
<img src="https://github.com/user-attachments/assets/cf94554f-a0ce-4a9b-a1e9-2fddf78954e6" alt="Screenshot 2024-12-19 200210" width="250"/>

## Table of Contents
1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [System Features](#system-features)
4. [Passenger Pages](#passenger-pages)
    - [Home Page](#home-page-passenger)
    - [Settings Page](#settings-page-passenger)
    - [My Common Trips](#my-common-trips)
    - [Ticket Summary](#ticket-summary)
    - [Booking Page](#booking-page)
5. [Staff/Admin Pages](#staff-admin-pages)
    - [Home Page](#home-page-admin)
    - [Assigning Staff to Train Page](#assigning-staff-to-train-page)
    - [Reservation Details Page](#reservation-details-page)
    - [Settings Page](#settings-page-admin)
6. [How to Run the System](#how-to-run-the-system)
7. [Screenshots](#screenshots)

---

## Overview
The Railway Application is a Flutter-based mobile application for efficient railway system management. It serves two types of users: **Passengers** and **Staff/Admins**. 
- Passengers can book trips, view tickets, and manage settings.
- Staff/Admins can assign roles, view reports, and manage train schedules.

---

## Technologies Used
- **Frontend**: Flutter
- **Backend**: MySQL
- **Environment Configuration**: `.env` file

---

## System Features
### Passenger Features
- Browse and book trips.
- View ticket details and summaries.
- Manage frequently used routes.

### Staff/Admin Features
- Assign staff to trains.
- Access detailed trip and reservation reports.
- Manage train schedules and passenger data.

---

## Passenger Pages

### Home Page (Passenger)
The home page for passengers provides a user-friendly interface where passengers can easily navigate through the system's features. This page displays the essential options for booking, checking trips, and accessing other vital features, ensuring a smooth user experience from the start.

<img src="https://github.com/user-attachments/assets/be4515cb-e355-4637-9609-deec39583d79" alt="Screenshot 2024-12-19 200604" width="250"/>

### Settings Page (Passenger)
The settings page allows passengers to personalize their preferences and update personal information. It includes options for adjusting notification settings, modifying contact details, and other customization features to enhance the user experience.

<img src="https://github.com/user-attachments/assets/a9157405-31ec-4432-9450-fdbdb4584475" alt="Screenshot 2024-12-19 200804" width="250"/>

### My Common Trips
This page displays the common trips that a passenger frequently takes, offering a quick view of past journeys. It allows passengers to easily rebook their regular trips without having to re-enter trip details each time.

<img src="https://github.com/user-attachments/assets/12ef222a-d810-483d-98bf-3ff4902533a9" alt="Screenshot 2024-12-19 200816" width="250"/>

### Ticket Summary
The ticket summary page provides passengers with a detailed view of their booked tickets. It includes trip information, seat details, and payment status, ensuring passengers have all the necessary information at a glance.

<img src="https://github.com/user-attachments/assets/5612299c-ad21-4778-9a83-34ec492bb0f5" alt="Screenshot 2024-12-19 200832" width="250"/>

## Booking Pages

This section of the app is designed for users to book tickets for the railway system. The screens display a clean and intuitive interface where users can select the desired train, date, and time for their journey. The process is streamlined, with easy-to-navigate buttons and input fields for ticket details, ensuring a seamless booking experience.

<img src="https://github.com/user-attachments/assets/c184f7df-e211-4f4b-9e48-33f5420a5c96" width="250"/>  
<img src="https://github.com/user-attachments/assets/20945d85-645e-48f2-991c-bdfe034b56d2" width="250"/>  
<img src="https://github.com/user-attachments/assets/5f496e5c-87ee-45ac-a60d-837ad322ffdb" width="250"/>

---

## Staff/Admin Pages

### Home Page (Admin)
The admin home page provides an overview of the railway system's operations. It includes quick access to various administrative tools for managing the system, with an organized layout that ensures efficient task navigation and oversight.

<img src="https://github.com/user-attachments/assets/f7788615-4d5a-48d9-8eab-6c2a43a9f6b2" width="250"/>

### Assigning Staff to Train Page
This page allows administrators to assign staff members to specific trains. The interface displays a list of available staff and trains, making it easy for admins to assign roles, ensuring smooth operations and scheduling.

<img src="https://github.com/user-attachments/assets/a080ff3d-7a1e-4ee2-9530-6cdf6a730774" width="250"/>

### Reservation Details Page
The reservation details page provides admins with an overview of user reservations. This page includes vital information such as the passenger's details, train time, and ticket status, allowing administrators to manage and track all bookings efficiently.

<img src="https://github.com/user-attachments/assets/590c98b0-7f5b-4cc2-9e41-d24d82f5f84d" width="250"/>

### Settings Page (Admin)
The settings page allows administrators to configure and manage system settings, including user preferences, operational parameters, and other administrative options, ensuring the system runs smoothly and efficiently.

<img src="https://github.com/user-attachments/assets/be70abcd-f740-4996-8881-56c19a3850f5" width="250"/>


---

## How to Run the System

### Prerequisites
1. Install **Flutter** and set up the environment.
2. Install a MySQL server and set up the database.

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd railway-application
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Complete the `.env` file with your database server information:
   ```env
   DB_HOST=your-database-host
   DB_USER=your-database-username
   DB_PASSWORD=your-database-password
   DB_NAME=your-database-name
   ```
5. Run the application:
   ```bash
   flutter run
   ```

---

## Staff/Admin Reports the System Provides
Below are the Reports provided on the Settings page of the Staff/Admin:

1. **Current Active Trips Report**

   <img src="https://github.com/user-attachments/assets/e2d3c044-75b3-42ad-a7f6-de2c178db259" width="250"/>

2. **Train Stations Report**
   
   <img src="https://github.com/user-attachments/assets/405cf31d-cb4b-419f-b536-46f2764a430a" width="250"/>

3. **Waitlisted Loyalty Passenger Report**
   
   <img src="https://github.com/user-attachments/assets/9daf6576-d8d5-43cd-acb4-d15fd8857e37" width="250"/>

4. **Load Factor Report**
   
   <img src="https://github.com/user-attachments/assets/c138e2f9-2bac-4c0a-be7d-2360bf1dd8f4" width="250"/>

5. **Dependents Report**
   
   <img src="https://github.com/user-attachments/assets/87be1f0f-df92-4a3f-b651-e79b68006872" width="250"/>


---

Thank you for using the Railway Application! 🚆

