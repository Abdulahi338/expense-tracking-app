API Endpoints

Base URL (local):

http://localhost:5000

Auth APIs
1) Register

POST /api/auth/register

Body (JSON):

{
  "username": "testuser",
  "email": "test@test.com",
  "password": "123456"
}

2) Login

POST /api/auth/login

Body (JSON):

{
  "email": "test@test.com",
  "password": "123456"
}

Income APIs (CRUD)
1) Create Income

POST /api/incomes

Body (JSON):

{
  "amount": 500,
  "source": "Salary",
  "paymentMethod": "Cash",
  "date": "2026-02-01",
  "description": "January salary"
}

2) Get All Incomes

GET /api/incomes

3) Update Income

PUT /api/incomes/:id

Body (JSON example):

{
  "amount": 650,
  "description": "Updated income"
}

4) Delete Income

DELETE /api/incomes/:id

Expense APIs (CRUD)
1) Create Expense (with balance check)

POST /api/expenses

Body (JSON):

{
  "amount": 100,
  "category": "Food",
  "paymentMethod": "Cash",
  "date": "2026-02-01",
  "description": "Lunch"
}


✅ If balance is not enough, response will be like:

{
  "message": "Insufficient balance. Please add income first.",
  "balance": 300
}

2) Get All Expenses

GET /api/expenses

3) Update Expense

PUT /api/expenses/:id

Body (JSON example):

{
  "amount": 120,
  "description": "Updated expense"
}

4) Delete Expense

DELETE /api/expenses/:id

Quick Notes (for README)
Content-Type header

For POST/PUT requests: