
const { json } = require('express');
const jsonwebtoken = require('jsonwebtoken');
module.exports={
    create(content){
        const jwt_option = {
            algorithm: 'HS256',
            expiresIn: '4h'
        }
        const jwt_content = {
            content
        };
        return jsonwebtoken.sign(jwt_content, process.env.SECRETJWT, jwt_option)
        
    },
authenticate(request, response, next) {
    const authHeader = request.headers['authorization']
    const token = authHeader && authHeader.split(' ')[1]
    if (token == null) return response.sendStatus(401)
  
    jsonwebtoken.verify(token, process.env.SECRETJWT, (err, user) => {
      console.log(err)
      if (err) return response.sendStatus(401)
       next()
    })
  },
  checkTokenMiddleware (request, response, next)  {
    // Récupération du token
    const extractBearerToken = headerValue => {
        if (typeof headerValue !== 'string') {
            return false
        }
    
        const matches = headerValue.match(/(bearer)\s+(\S+)/i)
        return matches && matches[2]
    }
    const token = request.headers.authorization && extractBearerToken(request.headers.authorization)

    // Présence d'un token
    if (!token) {
        return response.status(401).json({ message: 'Error. Need a token' })
    }

    // Véracité du token
    jsonwebtoken.verify(token, process.env.SECRETJWT, (err, decodedToken) => {
        if (err) {
            response.status(401).json({ message: 'Error. Bad token' })
        } else {
            return next()
        }
    })
    
    console.log(jsonwebtoken.decode(token).exp);
},expiration(request,response, next){
    const extractBearerToken = headerValue => {
        if (typeof headerValue !== 'string') {
            return false
        }
    
        const matches = headerValue.match(/(bearer)\s+(\S+)/i)
        return matches && matches[2]
    }
    const token = request.headers.authorization && extractBearerToken(request.headers.authorization)
    const currentTime =Date.now() /1000

    if(currentTime > jsonwebtoken.decode(token).exp)
    {console.log('token expired');
        response.status(401).json({ error :'Token is expired'})
        
    }else{
        console.log('token not expired');
        response.status(200).json({messsage : 'token not expired'})
        
    }
}

}