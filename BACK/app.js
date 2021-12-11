require('dotenv').config();
const port = process.env.PORT || 3001;
const cors = require('cors');
const sanitizer = require('sanitizer');
const express = require('express');

const app = express();

app.use(cors('*'));

app.use(express.urlencoded({
   extended: true
}));

const router = require('./app/routers/index.js');

app.use(express.json());
app.use( (req, res, next) => {
   if (req.body) {
       for (const prop in req.body) {
           req.body[prop] = sanitizer.escape(req.body[prop]);
       }
   }
   next();
});
app.use(router);

app.listen(port, _ => {
   console.log(`http://localhost:${port}`);
});