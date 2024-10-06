const crypto = require('crypto');
const { create } = require('domain');


// //SYMETRIC ENCRYPTION
// function encrypt(text,key){
//     const iv = crypto.randomBytes(16) // sozdayom vektor inicalizacii 128 bit

//     const cipher = crypto.createCipheriv('aes-256-cbc',Buffer.from(key),iv) // sozdayom obyekt shivrovanie peredayom text iv i key v Buffer.from chtoby key bil v binarnom formate 

//     let encrypted = cipher.update(text,'utf8','hex') // sozdayom shivrovanni text i govorim chto ot utf8 menyat v hex
//     encrypted += cipher.final('hex') // dobovlyaem posledni chast shivrovannomu texta v formateb hex

//     return {
//         iv: iv.toString('hex'),
//         content: encrypted
//     }
// }
// function decrypt(encrypted,key){
//     const iv = Buffer.from(encrypted.iv,'hex')

//     const decipher = crypto.createDecipheriv('aes-256-cbc',Buffer.from(key),iv)

//     let decrypted = decipher.update(encrypted.content,'hex','utf8')
//     decrypted+= decipher.final('utf8')
//     return decrypted

// }
// const KEY = crypto.createHash('sha256').update('myKey').digest('base64').substr(0, 32)
// const newKey = crypto.createHash('sha256').update('hayko').digest('base64').substr(0,10)
// const text = "Hayk"

// const data = encrypt(text,KEY)

// console.log("Hex Format",data)
// console.log("UTF-8 Format",decrypt(data,KEY))
// console.log("Key: ",newKey)

//ASYMETRIC ENCRYPT

// function generateKeyPair() {
//     const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
//         modulusLength: 2048
//     })
//     return { publicKey, privateKey }
// }

// function encryptWithPublicKey(publicKey,text) {
//     const encrypted = crypto.publicEncrypt(publicKey,Buffer.from(text))
//     return encrypted.toString('hex')
// }

// function decryptWithPrivateKey(privateKey,encrypted){
//     const decrypted = crypto.privateDecrypt(privateKey,Buffer.from(encrypted, 'hex'))
//     return decrypted.toString('utf8')

// }

// const { publicKey, privateKey } = generateKeyPair();


// const message = "Hayk"

// const encryptMessage = encryptWithPublicKey(publicKey,message)
// console.log('Encrypt: ',encryptMessage)

// const decryptMessage = decryptWithPrivateKey(privateKey,encryptMessage)
// console.log('Decrypt: ',decryptMessage)


//SIGN MESSAGE
// const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
//     modulusLength: 2048,
// });





// 1GCRX47ZMZRC3HCXKGXV3CHD






// const message = "Its The Very High Text"

// const sign = crypto.createSign('SHA256')
// sign.update(message)
// sign.end()
// const signature = sign.sign(privateKey,'hex')

// console.log("Numeric sign: ", signature)

// const verify = crypto.createVerify('SHA256')
// verify.update(message)
// verify.end()
// const isVerified = verify.verify(publicKey,signature,'hex')

// console.log('Sign is Right: ',isVerified)
