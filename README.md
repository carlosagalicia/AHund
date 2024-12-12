# AHund - Risk Management and Visualization Platform

This project is a web application designed to manage risks, clients, collaborators, and projects. It leverages modern web development technologies such as Node.js, Express, and EJS for efficient server-side rendering. The system also incorporates robust database handling with MySQL and provides a dynamic user interface for seamless interaction.

## Overview

- **Risk Management:** Enables users to create, update, and delete risks associated with projects.
- **Client and Collaborator Management:** Handles the registration, update, and listing of clients and collaborators.
- **Dynamic Dashboard:** Displays key project metrics, associated risks, and visualization of critical data.
- **User Authentication:** Secure login system to manage user roles and permissions.
- **Objective:** Provide a centralized platform for managing various aspects of project risks and resources.

## Key Learning Areas

### 1. Backend Development
- **Routing:** Modular route management for risks, clients, collaborators, and dashboards.
- **Database Interaction:** SQL-based schema creation and data handling using `mysql2`.
- **Middleware:** Implementation of authentication and authorization using custom middleware.

### 2. Frontend Development
- **Template Engine:** EJS for rendering dynamic views with user-specific data.
- **Responsive Design:** CSS and JavaScript for enhanced user interaction.
- **Modular Components:** Reusable components for dashboards, lists, and forms.

### 3. Security
- **Session Management:** Securely manages user sessions using `express-session`.
- **CSRF Protection:** `csurf` middleware to protect against cross-site request forgery.
- **Role-Based Access Control:** Custom middleware to restrict access based on user roles.

## Languages and Tools Used

### Backend
- **Node.js:** JavaScript runtime for server-side logic.
- **Express.js:** Web framework for efficient route and middleware management.
- **MySQL:** Database for managing structured data.

### Frontend
- **EJS:** Template engine for rendering views.
- **CSS:** For styling the application.
- **JavaScript:** Enhances interactivity and functionality on the client-side.

## Project Structure

```
AHund
├── controllers
│   ├── clients.controller.js
│   ├── colabs.controller.js
│   ├── dashboard.controller.js
│   ├── login.controller.js
│   ├── main.controller.js
│   └── risks.controller.js
├── models
│   ├── risks.model.js
│   ├── user.model.js
│   ├── clients.model.js
│   ├── colab.model.js
│   └── main.model.js
├── public
│   ├── css
│   ├── images
│   └── javascript
├── routes
│   ├── risks.routes.js
│   ├── clients.routes.js
│   ├── colabs.routes.js
│   ├── dashboard.routes.js
│   ├── login.routes.js
│   ├── main.routes.js
│   ├── isAuth.js
│   └── hasPermit.js
├── sql
│   └── tablas_aHund_estructura.sql
├── util
│   └── database.js
├── views
│   ├── includes
│   ├── edit-project.ejs
│   ├── add-risk.ejs
│   ├── clientes.ejs
│   ├── colaboradores.ejs
│   ├── dashboard.ejs
│   ├── risks.ejs
│   ├── projects.ejs
│   └── register-project.ejs
├── .gitignore
├── eslint.config.mjs
├── package.json
├── package-lock.json
└── server.js
```

## Installation and Usage

### Requirements
- **Node.js**
- **MySQL**
- **npm** for dependency management

### Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/carlosagalicia/AHund-.git
   cd AHund
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up the database:
   - Use the `sql/tablas_aHund_estructura.sql` file to create the necessary database tables.

4. Start the server:
   ```bash
   node server.js
   ```

5. Access the application:
   Navigate to `http://localhost:3003` in your browser.

## Contributions

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push your changes and create a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

