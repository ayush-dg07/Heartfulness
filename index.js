const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const express = require('express');
const session = require('express-session');
const routes = require('./routes');
const response = require('./utils/response');
const mongoose = require('mongoose');
const app = express();


app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(
  session({
    resave: false,
    saveUninitialized: false,
    secret: 'heartfulness',
    cookie: { maxAge: 604800000 }
  })
);

app.use(response);
app.use('/', routes);

const port = 8000;

const url = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASS}@firstcluster.mwyb6.mongodb.net/${process.env.DB_NAME}?retryWrites=true&w=majority`;
mongoose.connect(url, {useNewUrlParser: true, useUnifiedTopology: true, useFindAndModify: false})
.then( (conn) => {
  console.log('Database connected!');
  app.listen(port, (err) => {
    console.log(err || `Server started on ${port}`);
  })
})
.catch( err => console.log('Error in connection', err))

