const express = require('express');
const { MongoClient } = require('mongodb');
const bodyParser = require('body-parser');
const cors = require('cors');
const crypto = require('crypto');
const { decrypt,encrypt} = require('./myModule');

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
        console.log('Подключено к MongoDB');
    })
    .catch(err => console.error('Ошибка подключения к MongoDB:', err));

const collectionName = 'users';

app.get('/api/users', async (req, res) => {
    try {
        const db = client.db(dbName)
        const users = await db.collection(collectionName).find().toArray()
        let array = []
        for (let user of users) {
            array.push({name:user.name,password:myModule.decrypt(user.password,key)})
            console.log({name:user.name,password:user.password.content,key})
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
        const user = {
            name:req.body.name,
            password:myModule.encrypt(req.body.password,key)
        };//Update This Passsword
        console.log(user.password)
        const result = await db.collection(collectionName).insertOne(user);
        console.log("Data Send: ",data)
        res.status(201).json(result.ops[0]);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`Сервер запущен на http://localhost:${PORT}`);
});
