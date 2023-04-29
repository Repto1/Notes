const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

app.use(cors());

app.use(express.json());

// DataBase connection

const conn = require("./db/conn");

conn();

// Router

const routes = require("./routes/router");

app.use("/api", routes);

app.listen(port, function () {
  console.log(`API ADDRESS: http://localhost:${port}`);
});
