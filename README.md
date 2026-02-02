# 📌 API Endpoints

## 🌐 Base URL (Local)
http://localhost:5000

---

## 🔐 Authentication APIs

### Register User
- Method: POST  
- URL: /api/auth/register  

Body (JSON):
```json
{
  "username": "testuser",
  "email": "test@test.com",
  "password": "123456"
}
Login User
Method: POST

URL: /api/auth/login

Body (JSON):

{
  "email": "test@test.com",
  "password": "123456"
}
💰 Income APIs (CRUD)
Create Income
Method: POST

URL: /api/incomes

Body (JSON):

{
  "amount": 500,
  "source": "Salary",
  "paymentMethod": "Cash",
  "date": "2026-02-01",
  "description": "January salary"
}
Get All Incomes
Method: GET

URL: /api/incomes

Update Income
Method: PUT

URL: /api/incomes/:id

Body (JSON):

{
  "amount": 650,
  "description": "Updated income"
}
Delete Income
Method: DELETE

URL: /api/incomes/:id

🧾 Expense APIs (CRUD)
Create Expense (Balance Check)
Method: POST

URL: /api/expenses

Body (JSON):

{
  "amount": 100,
  "category": "Food",
  "paymentMethod": "Cash",
  "date": "2026-02-01",
  "description": "Lunch"
}
If balance is insufficient:

{
  "message": "Insufficient balance. Please add income first.",
  "balance": 300
}
Get All Expenses
Method: GET

URL: /api/expenses

Update Expense
Method: PUT

URL: /api/expenses/:id

Body (JSON):

{
  "amount": 120,
  "description": "Updated expense"
}
Delete Expense
Method: DELETE

URL: /api/expenses/:id

