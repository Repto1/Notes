const mongoose = require("mongoose");
const mongodb = require("mongodb");

async function main() {
  try {
    mongoose.set("strictQuery", true);

    await mongoose.connect(
      "<your mongoDB URI>"
    );

    console.log("Connected");
  } catch (error) {
    console.log(`ERRO!!!!! ${error}`);
  }
}

module.exports = main;
