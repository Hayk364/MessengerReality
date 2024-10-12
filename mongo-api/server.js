const express = require('express');
const { MongoClient } = require('mongodb');
const bodyParser = require('body-parser');
const cors = require('cors');
const crypto = require('crypto');
const { encrypt,decrypt } = require('./myModule');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

const uri = 'mongodb://localhost:27017';
const client = new MongoClient(uri);
const dbName = 'Message';

const key = crypto.createHash('sha256').update('mySecretKey').digest('base64').substr(0, 32)

client.connect()
    .then(() => {
        console.log('Connect MongoDB');
    })
    .catch(err => console.error('Connect Error MongoDB:', err));

const collectionName = 'user';

app.get('/api/users', async (req, res) => {
    try {
        const db = client.db(dbName)
        const users = await db.collection('passwords').find().toArray()
        let array = []
        for (let user of users) {
            array.push({name:user.name,password:decrypt(user.password,key)})
            console.log({name:user.name,password:user.password.content})
        }
        res.json(array)
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});
app.post('/api/users', async (req, res) => {
    try {
        console.log("Create API")
        const db = client.db(dbName);
        const name = req.body.name
        const password = encrypt(req.body.password,key)
        console.log(decrypt(password,key))
        const result = await db.collection(collectionName).insertOne({name:name,password:password.content});
        const result2 = await db.collection('passwords').insertOne({name:name,password:password})
        res.status(201).json({id: result.insertedId,name:name,password:password.content})
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Сервер запущен на http://localhost:${PORT}`);

});
