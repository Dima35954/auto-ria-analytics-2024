const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

let cars = [
    { id: "1", make: "Toyota", model: "Camry", priceUsd: 25000, year: 2022 },
    { id: "2", make: "BMW", model: "X5", priceUsd: 55000, year: 2023 }
];

app.get('/api/v1/cars', (req, res) => {
    console.log('GET request received for cars');
    res.status(200).json({
        data: cars,
        total: cars.length
    });
});

app.post('/api/v1/cars', (req, res) => {
    const newCar = req.body;

    if (!newCar.make || !newCar.price) {
        return res.status(400).json({ error: "Missing required fields" });
    }

    newCar.id = (cars.length + 1).toString();
    cars.push(newCar);

    console.log('POST request: Added new car:', newCar.make);
    res.status(201).json({
        id: newCar.id,
        status: "created",
        message: "Listing added successfully",
        car: newCar
    });
});

app.get('/api/v1/analytics/price-trend', (req, res) => {
    const trendData = [
        { month: "January", avgPrice: 12500 },
        { month: "February", avgPrice: 12800 },
        { month: "March", avgPrice: 13200 }
    ];

    res.status(200).json({ trend: trendData });
});

app.listen(PORT, () => {
    console.log(` Server is running on http://localhost:${PORT}`);
});