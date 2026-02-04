# Backend API Documentation

Base URL: `http://localhost:5000/api`

## Authentication

### Register User
- **Endpoint**: `POST /auth/register`
- **Body**:
  ```json
  {
    "username": "example_user",
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```
- **Response**: `201 Created` - `{ "message": "User registered successfully" }`

### Login User
- **Endpoint**: `POST /auth/login`
- **Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```
- **Response**: `200 OK`
  ```json
  {
    "message": "Login successful",
    "token": "jwt_token_here",
    "user": { ... }
  }
  ```

## Incomes
*All income routes require `Authorization: Bearer <token>` header.*

### Add Income
- **Endpoint**: `POST /incomes/add-income`
- **Body**:
  ```json
  {
    "title": "Salary",
    "amount": 5000,
    "category": "Job",
    "description": "Monthly salary",
    "date": "2023-10-01"
  }
  ```
- **Response**: `200 OK` - `{ "message": "Income Added", "income": { ... } }`

### Get Incomes
- **Endpoint**: `GET /incomes/get-incomes`
- **Response**: `200 OK` - List of income objects.

### Delete Income
- **Endpoint**: `DELETE /incomes/delete-income/:id`
- **Response**: `200 OK` - `{ "message": "Income Deleted" }`

## Expenses
*All expense routes require `Authorization: Bearer <token>` header.*

### Add Expense
- **Endpoint**: `POST /expenses/add-expense`
- **Body**:
  ```json
  {
    "title": "Groceries",
    "amount": 150,
    "category": "Food",
    "description": "Weekly shopping",
    "date": "2023-10-02"
  }
  ```
- **Response**: `200 OK` - `{ "message": "Expense added", "expense": { ... } }`

### Get Expenses
- **Endpoint**: `GET /expenses/get-expenses`
- **Response**: `200 OK` - List of expense objects.

### Delete Expense
- **Endpoint**: `DELETE /expenses/delete-expense/:id`
- **Response**: `200 OK` - `{ "message": "Expense deleted" }`
