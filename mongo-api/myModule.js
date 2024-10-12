// const crypto = require('crypto')

// function encrypt(text,key){
//     const iv = crypto.randomBytes(16)

//     const cipher = crypto.createCipheriv('aes-256-cbc',Buffer.from(key),iv)

//     let encrypted = cipher.update(text,'utf-8','hex')
//     encrypted += cipher.final('hex')
    
//     return {
//         iv:iv.toString('hex'),
//         content:encrypted
//     }
// }

// function decrypt(encrypted,key){
//     const iv = Buffer.from(encrypted.iv,'hex')

//     const decipher = crypto.createDecipheriv('aes-256-cbc',Buffer.from(key),iv)

//     let dencrypted = decipher.update(encrypted.content,'hex','utf-8')

//     dencrypted += decipher.final('utf-8')

//     return dencrypted
// }

// module.exports = {
//     encrypt,
//     decrypt
// }
const crypto = require('crypto')

function encrypt(text,key){
    const iv = crypto.randomBytes(16)

    const cipher = crypto.createCipheriv('aes-256-cbc',Buffer.from(key),iv)

    let encrypted = cipher.update(text,'utf-8','hex')
    encrypted+= cipher.final('hex')

    return {
        iv:iv.toString('hex'),
        content: encrypted
    }
}
function decrypt(encrypted,key){
    const iv = Buffer.from(encrypted.iv,'hex')

    const decipher = crypto.createDecipheriv('aes-256-cbc',Buffer.from(key),iv)

    let decrypted = decipher.update(encrypted.content,'hex','utf-8')
    decrypted+= decipher.final('utf-8')
    
    return decrypted
}

module.exports = {
    encrypt,
    decrypt
}