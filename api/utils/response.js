module.exports = (req, res, next) => {
    res.sendError = (err, msg = 'Internal server error, please contact us.') => {
      err && console.log('[ERROR] ', err);
      console.log(msg);
      res.send({ success: false, msg });
    };
    res.sendSuccess = (data, msg, status) => {
      //console.log(msg);
      res.send({ success: true, msg, status, ...(data && { data }) });
    };
    next();
  };