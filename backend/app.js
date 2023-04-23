const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

let tasks = [
  { id: 1, title: "Comprar leite", completed: false },
  { id: 2, title: "Pagar a conta de luz", completed: false },
  { id: 3, title: "Fazer exercícios", completed: true },
];

app.use(cors());

app.get("/tasks", (req, res) => {
  res.json(tasks);
});

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
