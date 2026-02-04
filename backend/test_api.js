const BASE_URL = "http://localhost:5000/api";

async function testBackend() {
    console.log("🚀 Starting Backend Tests...\n");

    let token = "";
    const testUser = {
        username: "testuser_" + Date.now(),
        email: "test" + Date.now() + "@example.com",
        password: "password123"
    };

    // 1. REGISTER
    try {
        const res = await fetch(`${BASE_URL}/auth/register`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(testUser)
        });
        const data = await res.json();
        if (res.ok) {
            console.log("✅ Register Passed:", data.message);
        } else {
            console.error("❌ Register Failed:", data);
            return;
        }
    } catch (err) {
        console.error("❌ Register Error:", err.message);
        return;
    }

    // 2. LOGIN
    try {
        const res = await fetch(`${BASE_URL}/auth/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email: testUser.email, password: testUser.password })
        });
        const data = await res.json();
        if (res.ok && data.token) {
            token = data.token;
            console.log("✅ Login Passed. Token received.");
        } else {
            console.error("❌ Login Failed:", data);
            return;
        }
    } catch (err) {
        console.error("❌ Login Error:", err.message);
        return;
    }

    // 3. ADD INCOME
    try {
        const res = await fetch(`${BASE_URL}/incomes/add-income`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({
                title: "Test Salary",
                amount: 5000,
                category: "Salary",
                description: "Monthly salary",
                date: "2023-10-01"
            })
        });
        const data = await res.json();
        if (res.ok) {
            console.log("✅ Add Income Passed:", data.message);
        } else {
            console.error("❌ Add Income Failed:", data);
        }
    } catch (err) {
        console.error("❌ Add Income Error:", err.message);
    }

    // 4. ADD EXPENSE
    try {
        const res = await fetch(`${BASE_URL}/expenses/add-expense`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({
                title: "Groceries",
                amount: 150,
                category: "Food",
                description: "Weekly groceries",
                date: "2023-10-02"
            })
        });
        const data = await res.json();
        if (res.ok) {
            console.log("✅ Add Expense Passed:", data.message);
        } else {
            console.error("❌ Add Expense Failed:", data);
        }
    } catch (err) {
        console.error("❌ Add Expense Error:", err.message);
    }

    // 5. GET INCOMES
    try {
        const res = await fetch(`${BASE_URL}/incomes/get-incomes`, {
            headers: { "Authorization": `Bearer ${token}` }
        });
        const data = await res.json();
        if (res.ok && Array.isArray(data)) {
            console.log(`✅ Get Incomes Passed: Found ${data.length} incomes.`);
        } else {
            console.error("❌ Get Incomes Failed:", data);
        }
    } catch (err) {
        console.error("❌ Get Incomes Error:", err.message);
    }

    // 6. GET EXPENSES
    try {
        const res = await fetch(`${BASE_URL}/expenses/get-expenses`, {
            headers: { "Authorization": `Bearer ${token}` }
        });
        const data = await res.json();
        if (res.ok && Array.isArray(data)) {
            console.log(`✅ Get Expenses Passed: Found ${data.length} expenses.`);
        } else {
            console.error("❌ Get Expenses Failed:", data);
        }
    } catch (err) {
        console.error("❌ Get Expenses Error:", err.message);
    }

    console.log("\n🎉 Testing Complete.");
}

testBackend();
