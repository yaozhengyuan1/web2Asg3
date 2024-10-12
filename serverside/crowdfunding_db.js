const express = require('express');
const cors = require('cors');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// const db = mysql.createConnection({
//     host: 'localhost',
//     user: '',
//     password: '.',
//     database: 't1'
// });
const db = mysql.createConnection({
    host: '127.0.0.1',
    user: 'zyao12_admin',
    password: 'zyao12_admin',
    database: 'zyao12_crowdfunding_db'
});

app.get('/fundraiser/:id', (req, res) => {
    const fundraiserId = req.params.id;
    const sqlQuery = `
        SELECT f.FUNDRAISER_ID, f.ORGANIZER, f.CAPTION, f.TARGET_FUNDING, 
               f.CURRENT_FUNDING, f.CITY, f.ACTIVE, c.NAME AS CATEGORY_NAME, 
               d.DONATION_ID, d.DATE AS DONATION_DATE, d.AMOUNT AS DONATION_AMOUNT, 
               d.GIVER AS DONATION_GIVER
        FROM FUNDRAISER f
        LEFT JOIN category c ON f.CATEGORY_ID = c.CATEGORY_ID
        LEFT JOIN donation d ON f.FUNDRAISER_ID = d.FUNDRAISER_ID
        WHERE f.FUNDRAISER_ID = ?;`;

    db.query(sqlQuery, [fundraiserId], (error, results) => {
        if (error) return res.status(500).json({ error: 'Database query failed.' });
        const fundraiser = {
            FUNDRAISER_ID: results[0]?.FUNDRAISER_ID,
            ORGANIZER: results[0]?.ORGANIZER,
            CAPTION: results[0]?.CAPTION,
            TARGET_FUNDING: results[0]?.TARGET_FUNDING,
            CURRENT_FUNDING: results[0]?.CURRENT_FUNDING,
            CITY: results[0]?.CITY,
            ACTIVE: results[0]?.ACTIVE,
            CATEGORY_NAME: results[0]?.CATEGORY_NAME,
            DONATIONS: results.map(row => ({
                DONATION_ID: row.DONATION_ID,
                DONATION_DATE: row.DONATION_DATE,
                DONATION_AMOUNT: row.DONATION_AMOUNT,
                DONATION_GIVER: row.DONATION_GIVER
            }))
        };
        res.json(fundraiser);
    });
});

app.get('/fundraisers', (req, res) => {
    const sqlQuery = `
        SELECT f.FUNDRAISER_ID, f.ORGANIZER, f.CAPTION, f.TARGET_FUNDING, 
               f.CURRENT_FUNDING, f.CITY, f.ACTIVE, c.NAME AS CATEGORY_NAME, 
               d.DONATION_ID, d.DATE AS DONATION_DATE, d.AMOUNT AS DONATION_AMOUNT, 
               d.GIVER AS DONATION_GIVER
        FROM FUNDRAISER f
        LEFT JOIN category c ON f.CATEGORY_ID = c.CATEGORY_ID
        LEFT JOIN donation d ON f.FUNDRAISER_ID = d.FUNDRAISER_ID;`;

    db.query(sqlQuery, (error, results) => {
        if (error) return res.status(500).json({ error: 'Database query failed.' });
        const fundraisers = results.reduce((acc, row) => {
            const id = row.FUNDRAISER_ID;
            if (!acc[id]) {
                acc[id] = {
                    FUNDRAISER_ID: row.FUNDRAISER_ID,
                    ORGANIZER: row.ORGANIZER,
                    CAPTION: row.CAPTION,
                    TARGET_FUNDING: row.TARGET_FUNDING,
                    CURRENT_FUNDING: row.CURRENT_FUNDING,
                    CITY: row.CITY,
                    ACTIVE: row.ACTIVE,
                    CATEGORY_NAME: row.CATEGORY_NAME,
                    DONATIONS: []
                };
            }
            if (row.DONATION_ID) {
                acc[id].DONATIONS.push({
                    DONATION_ID: row.DONATION_ID,
                    DONATION_DATE: row.DONATION_DATE,
                    DONATION_AMOUNT: row.DONATION_AMOUNT,
                    DONATION_GIVER: row.DONATION_GIVER
                });
            }
            return acc;
        }, {});
        res.json(Object.values(fundraisers));
    });
});

app.post('/donation', (req, res) => {
    const { fundraiser_id, giver, amount } = req.body;

    if (!fundraiser_id || !giver || !amount || amount < 5) {
        return res.status(400).json({ error: 'Invalid input: ensure all fields are present and amount is at least 5 AUD' });
    }

    const insertDonationSQL = `
        INSERT INTO donation (FUNDRAISER_ID, GIVER, AMOUNT, DATE) 
        VALUES (?, ?, ?, NOW())`;

    db.query(insertDonationSQL, [fundraiser_id, giver, amount], (err, result) => {
        if (err) {
            console.error('Error inserting donation:', err); // Log the error for debugging
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ message: 'Donation added successfully', donationId: result.insertId });
    });
});


app.post('/fundraiser', (req, res) => {
    const { caption, organizer, target_funding, current_funding, city, active, category_id } = req.body;
    const insertFundraiserSQL = `
        INSERT INTO FUNDRAISER (CAPTION, ORGANIZER, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY_ID) 
        VALUES (?, ?, ?, ?, ?, ?, ?)`;

    db.query(insertFundraiserSQL, [caption, organizer, target_funding, current_funding, city, active, category_id], (err, result) => {
        if (err) return res.status(500).json({ error: err });
        res.status(201).json({ message: 'Fundraiser created successfully', fundraiserId: result.insertId });
    });
});

app.put('/fundraiser/:id', (req, res) => {
    const { caption, organizer, target_funding, current_funding, city, active, category_id } = req.body;
    const updateFundraiserSQL = `
        UPDATE FUNDRAISER 
        SET CAPTION = ?, ORGANIZER = ?, TARGET_FUNDING = ?, 
            CURRENT_FUNDING = ?, CITY = ?, ACTIVE = ?, CATEGORY_ID = ? 
        WHERE FUNDRAISER_ID = ?`;

    db.query(updateFundraiserSQL, [caption, organizer, target_funding, current_funding, city, active, category_id, req.params.id], (err, result) => {
        if (err) return res.status(500).json({ error: err });
        if (result.affectedRows === 0) return res.status(404).json({ error: 'Fundraiser not found' });
        res.json({ message: 'Fundraiser updated successfully' });
    });
});

app.delete('/fundraiser/:id', (req, res) => {
    const fundraiserId = req.params.id;

    const checkDonationsSQL = 'SELECT COUNT(*) AS donationCount FROM donation WHERE FUNDRAISER_ID = ?';
    const deleteFundraiserSQL = 'DELETE FROM FUNDRAISER WHERE FUNDRAISER_ID = ?';

    db.query(checkDonationsSQL, [fundraiserId], (err, results) => {
        if (err) {
            console.error('Error checking donations:', err); // Log the error for debugging
            return res.status(500).json({ error: 'Database error: ' + err });
        }

        if (results[0].donationCount > 0) {
            return res.status(400).json({ error: 'Cannot delete fundraiser with existing donations' });
        }

        db.query(deleteFundraiserSQL, [fundraiserId], (deleteErr, deleteResult) => {
            if (deleteErr) {
                console.error('Error deleting fundraiser:', deleteErr); // Log the error for debugging
                return res.status(500).json({ error: 'Error deleting fundraiser: ' + deleteErr });
            }
            if (deleteResult.affectedRows === 0) {
                return res.status(404).json({ error: 'Fundraiser not found' });
            }
            res.json({ message: 'Fundraiser deleted successfully' });
        });
    });
});




app.get('/query', (req, res) => {
    const { organizer, city, category } = req.query;
    let query = 'SELECT * FROM FUNDRAISER WHERE ACTIVE = 1';
    let conditions = [];

    if (organizer) conditions.push(`ORGANIZER LIKE '%${organizer}%'`);
    if (city) conditions.push(`CITY LIKE '%${city}%'`);
    if (category) conditions.push(`CATEGORY_ID = ${category}`);

    if (conditions.length > 0) query += ' AND ' + conditions.join(' AND ');

    db.query(query, (error, results) => {
        if (error) return respondWithError(res, error);
        res.json(results);
    });
});




app.listen(port, () => {
    console.log(`Server running on port: ${port}`);
});
