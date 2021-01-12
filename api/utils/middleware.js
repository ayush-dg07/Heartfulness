const isLoggedIn = (req, res, next) => {
    if(req.session.user) next();
    else return res.sendError(null, 'User not logged in');
}

const isLoggedOut = (req, res, next) => {
    if(!req.session.user) next();
    else return res.sendError(null, 'User is logged in');
}

module.exports = { isLoggedIn, isLoggedOut };