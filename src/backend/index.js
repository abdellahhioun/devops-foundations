const express = require('express');
const { Pool } = require('pg');
const { createClient } = require('redis');
const nodemailer = require('nodemailer');
require('dotenv').config();

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;
const VERSION = "1.0.0";

// 1. Route Bienvenue 
app.get('/', (req, res) => {
    res.json({ message: "Welcome to CloudNative Labs API", version: VERSION });
});

// 2. Route Health (Liveness Probe) 
app.get('/health', (req, res) => {
    res.json({ status: "ok", service: "backend" });
});

// 3. Route Database (PostgreSQL) [3, 1]
const pool = new Pool({
    connectionString: `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:5432/${process.env.DB_NAME}`
});

app.get('/db', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({ 
            status: "connected", 
            database: process.env.DB_NAME, 
            timestamp: result.rows.now 
        });
    } catch (err) {
        res.status(500).json({ status: "down", error: err.message });
    }
});

// 4. Route Cache (Redis) [4, 1]
const redisClient = createClient({
    url: `redis://${process.env.REDIS_HOST}:6379`
});
redisClient.connect().catch(console.error);

app.get('/cache', async (req, res) => {
    try {
        const visits = await redisClient.incr('visits');
        res.json({ status: "ok", visits });
    } catch (err) {
        res.status(500).json({ status: "down", error: err.message });
    }
});

// 5. Route Contact (MailHog) [5, 1]
const transporter = nodemailer.createTransport({
    host: process.env.MAIL_HOST,
    port: 1025,
    secure: false
});

app.post('/contact', async (req, res) => {
    try {
        await transporter.sendMail({
            from: '"DevOps Team" <noreply@localhost>',
            to: "test@example.com",
            subject: "Infrastructure Test",
            text: "Ceci est un test SMTP via MailHog."
        });
        res.json({ message: "Email sent successfully" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(PORT, () => console.log(`API running on port ${PORT}`));