var express = require("express");
var cors = require('cors');
var compression = require('compression');
var helmet = require('helmet');
var app = express();
var port = 3000;

app.use(compression());
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

var api = require("./api.js");
var auth = require("./auth.js");

app.use("/api", api);
app.use("/auth", auth);

app.get("/", function (req, res) {
  res.send("Hello world!");
});

app.set('port', process.env.PORT || port);
app.listen(port);