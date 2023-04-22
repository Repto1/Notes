const mongoose = require("mongoose");

const { Schema } = mongoose;

const noteSchema = new Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  creationDate: {
    type: String,
    required: true,
  },
  completionDate: {
    type: String,
    required: false,
  },
});

const Note = mongoose.model("Note", noteSchema);

module.exports = {};
