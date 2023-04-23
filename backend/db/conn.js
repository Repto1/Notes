const mongoose = require("mongoose");
const mongodb = require("mongodb");

async function main() {
  try {
    mongoose.set("strictQuery", true);

    await mongoose.connect(
      "mongodb+srv://SuperUser:vljS16ohnO09lrx0@cluster0.ynorlk8.mongodb.net/?retryWrites=true&w=majority"
    );

    console.log("Connected");
  } catch (error) {
    console.log(`ERRO!!!!! ${error}`);
  }
}

module.exports = main;
