const router = require('express').Router()
const auth = require('./auth')
const mid = require('../utils/middleware');


router.post('/register', mid.isLoggedOut, auth.register)
router.post('/login', mid.isLoggedOut, auth.login)

router.post('/updateDetails', mid.isLoggedIn, auth.updateDetails)
router.post('/verify', mid.isLoggedIn, auth.verify);

router.get('/getUser', mid.isLoggedIn, auth.getUser);
router.get('/logout', mid.isLoggedIn, auth.logout)

module.exports = router