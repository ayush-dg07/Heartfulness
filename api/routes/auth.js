const user = require('../models').user;
const to = require('../utils/to');
const bcrypt = require('bcrypt');

let auth = {};

auth.register = async (req, res) => {
    let e,r;
    [e,r] = await to(user.find({username: req.body.username}));
    if(r.length > 0) {
        return res.sendError(null, 'Username taken');
    }
    const newUser = new user({
        email: req.body.email,
        username: req.body.username,
        password: await bcrypt.hash(req.body.password, 10),
    })
    await newUser.save();
    return res.sendSuccess(null, 'User registered');
}

auth.verify = async (req, res) => {
    if(req.session.user.username != req.body.username) return res.sendError(null, 'Not authorized');
    let e,r;
    [e,r] = await to(user.findOneAndUpdate( { username: req.body.username }, { verified: 1 }));
    if(e) return res.sendError(e);
    return res.sendSuccess(null, 'User verified'); 
}

auth.updateDetails = async (req, res) => {
    if(req.session.user.username != req.body.username) return res.sendError(null, 'Not authorized');
    let e,r;
    [e,r] = await to(user.findOneAndUpdate( { username: req.body.username }, {
        phone: req.body.phone,
        userDetails: {
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            profession: req.body.profession,
            age: req.body.age,
            address: {
                line1: req.body.line1,
                line2: req.body.line2,
                city: req.body.city,
                country: req.body.country,
                pincode: req.body.pincode
            }
        }
    }));
    if(e) return res.sendError(e);
    return res.sendSuccess(null, 'User details updated'); 
}

auth.login = async (req, res) => {
    let e,u;
    [e,u] = await to(user.findOne({ username: req.body.username}));
    if(e) return res.sendError(e);
    if(!u) return res.sendError(null, 'User not found');
    [e,r] = await to(bcrypt.compare(req.body.password, u.password));
    if(e) return res.sendError(e);
    if(r == false) return res.sendError(null, 'Wrong password');
    else {
        u.password = undefined;
        delete u.password;
        req.session.user = u;
        req.session.save(() => {
            res.sendSuccess(null, 'Login successful');
        });
    }
}

auth.logout = async (req, res) => {
    req.session.destroy(() => {
        res.sendSuccess(null, 'Logout successful');
    });
}

auth.getUser = async (req,res) => {
    res.sendSuccess(req.session.user, 'User details loaded')
}


module.exports = auth;