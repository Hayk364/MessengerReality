const { MongoClient } = require('mongodb')
const bodyParser = require('body-parser')
const cors = require('cors')
const crypto = require('crypto')
const express = require('express')
const myModule = require('./myModule')

const app = express()
const PORT = 4000

app.use(cors())
app.use(bodyParser.json())

const uri = 'mongodb://localhost:27017'
const client = new MongoClient(uri)
const dbName = 'node' 

client.connect()
    .then(() => {
        console.log("MongoDB Has Been Connected")
    })
    .catch((err) =>{
        console.error(err)
    })
const collection = 'users'

app.get('/api/get',async (req,res) => {
    try {
        const db = client.db(dbName)
        const users = await db.collection(collection).find().toArray()
        for (let index = 0; index < users.length; index++) {
            console.log("Username: ",users[index].name)
            console.log("Password: ",users[index].password.content)
        }
    } catch (error) {
        console,error(error)
    }
})
app.post('/api/set/:name/:password',async (req,res) =>{
    try {
        const key = crypto.randomBytes(32)
        const db = client.db(dbName)
        const username = req.params.name
        const password = myModule.encrypt(req.params.password,key)
        console.log("Username: ",username)
        console.log("Password: ",password.content)
        const result = await db.collection(collection).insertOne({name:username,password:password})
        console.log(result)
    } catch (error) {
        console.error(error)
    }
})
app.listen(PORT,() =>{
    console.log(`Server Has been Started: http://localhost:${PORT}`)
})