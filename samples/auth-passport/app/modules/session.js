// See https://github.com/expressjs/session

module.exports = {
  secret: 's3cr3t',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 60000,
    secure: true
  }
}
