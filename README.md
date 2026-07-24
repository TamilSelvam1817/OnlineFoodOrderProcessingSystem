# 🍔 Online Food Order Processing System

An end-to-end AI-assisted Online Food Order Processing System built using **Spring Boot**, **React**, **MySQL**, **Camunda BPM**, and **ActiveMQ**. The application simulates a real-world food ordering platform with secure authentication, restaurant management, live order tracking, workflow automation, invoice generation, and email notifications.

---

# 📖 Project Overview

The Online Food Order Processing System allows customers to browse restaurants, place food orders, make payments, and track their order status in real time. Restaurant owners can manage incoming orders, while administrators can monitor the complete system.

The application uses Camunda BPM to automate the order lifecycle and ActiveMQ for asynchronous messaging. JWT and Google OAuth 2.0 provide secure authentication.

---

# ✨ Features

## Customer

- User Registration
- Secure Login using JWT
- Google OAuth 2.0 Login
- Browse Restaurants
- Browse Menu Items
- Add Items to Cart
- Checkout Process
- Place Food Orders
- Live Order Tracking
- Download Invoice PDF
- Cancel Order (before kitchen starts)
- Profile Management
- Dark / Light Theme

---

## Restaurant Owner

- Restaurant Dashboard
- View Incoming Orders
- Monitor Order Status
- Manage Restaurant Information

---

## Administrator

- Admin Dashboard
- View All Restaurants
- View All Users
- Monitor Orders
- System Management

---

## Backend Features

- JWT Authentication
- Google OAuth Login
- Spring Security
- Camunda BPM Workflow
- ActiveMQ Messaging
- Email Notifications
- Invoice PDF Generation
- Order Status Scheduler
- REST APIs
- MySQL Database

---

# 🛠 Tech Stack

## Frontend

- React.js
- Redux Toolkit
- React Router
- Tailwind CSS
- Framer Motion
- Axios

---

## Backend

- Java 21
- Spring Boot
- Spring Security
- Spring Data JPA
- JWT
- OAuth2
- ActiveMQ
- Camunda BPM

---

## Database

- MySQL

---

## Tools

- IntelliJ IDEA
- VS Code
- Postman
- Git
- GitHub
- Railway
- MySQL Workbench

---

# 🏗 Architecture

```
                     React Frontend
                           │
                           │ REST API
                           ▼
                  Spring Boot Backend
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
 Spring Security      Camunda BPM       ActiveMQ Queue
        │                  │                  │
        ▼                  ▼                  ▼
 JWT Authentication  Order Workflow   Email Notification
                           │
                           ▼
                      MySQL Database
```

---

# ⚙️ How to Run

## Backend

```bash
git clone https://github.com/yourusername/food-order-processing-system.git

cd backend

mvn clean install

mvn spring-boot:run
```

Backend runs on

```
http://localhost:8080
```

---

## Frontend

```bash
cd frontend

npm install

npm run dev
```

Frontend runs on

```
http://localhost:5173
```

---

## Database

Import

```
database.sql
```

using MySQL Workbench.

---

# 📸 Screenshots

The screenshots are available inside the **screenshots/** folder.

Included Screenshots

- Landing Page
- Login Page
- Register Page
- Home Page
- Restaurant Details
- Checkout Page
- Orders Page
- Restaurant Dashboard
- Admin Dashboard
- Invoice PDF
- Camunda Workflow

---

# 🔑 Demo Credentials

## Customer

Email

```
customer@food.com
```

Password

```
password
```

---

## Restaurant Owner

Email

```
owner@food.com
```

Password

```
password
```

---

## Administrator

Email

```
admin@food.com
```

Password

```
password
```

---

# 🌐 Live Application

## Frontend

https://frontend-production-26f5.up.railway.app

## Backend

https://onlinefoodorderprocessingsystem-production.up.railway.app

---

# 🔄 Order Workflow

```
ORDER_PLACED
      │
      ▼
PAYMENT_PROCESSING
      │
      ▼
RESTAURANT_ACCEPTED
      │
      ▼
KITCHEN_PREPARING
      │
      ▼
OUT_FOR_DELIVERY
      │
      ▼
DELIVERED
```

---

# 📧 Email Notifications

The system automatically sends:

- Customer Order Confirmation
- Restaurant Owner Notification
- Invoice Email
- Payment Status Notification

---

# 📄 Invoice Generation

The application automatically generates a downloadable PDF invoice after successful order placement.

---

# 🔒 Authentication

- JWT Authentication
- Google OAuth 2.0 Login
- Spring Security Role-Based Authorization

Roles

- ROLE_CUSTOMER
- ROLE_RESTAURANT
- ROLE_ADMIN

---

# 🤖 AI-Assisted Development

This project was developed with the assistance of AI tools including:

- Antigravity
- ChatGPT

AI was used for:

- Architecture discussions
- Debugging
- Code optimization
- UI improvements
- Workflow design
- API implementation

All generated code was reviewed, modified, integrated, and tested before deployment.

---

# 👨‍💻 Developed By

**Tamil Selvam D**

Software Engineer Candidate
