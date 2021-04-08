var express = require('express');
var router = express.Router();

const User = require('../db/User.js');

const user = new User();

router.post('/register', async (req, res) => {
  const { username, password, email } = req.body;
  const result = await user.register(username, password, email);
  res.status(result).end();
});

router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const {
    statusCode,
    user: { id, email },
  } = await user.login(username, password);

  const loggedInUser = { id, username, email };

  if (statusCode === 204) {
    req.session.user = loggedInUser;
  }

  res.json({ user: loggedInUser, statusCode });
});

router.post('/logout', (req, res) => {
  req.session.destroy(() => {
    res.status(200).end();
  });
});

router.get('/currentUser', (req, res) => {
  req.session.user
    ? res.json({ user: req.session.user })
    : res.json({ loggedIn: false });
});

module.exports = router;
