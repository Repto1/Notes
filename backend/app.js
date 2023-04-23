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

app.listen(port, function () {
  console.log(`API rodando em http://localhost:${port}`);
});
