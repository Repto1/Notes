const mongoose = require("mongoose");

const { Schema } = mongoose;

const noteSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
    },
    creationDate: {
      type: String,
      required: false,
    },
    completed: {
      type: Boolean,
      default: false,
    },
    completionDate: {
      type: String,
      required: false,
    },
  },
  { timestamps: true }
);

const Note = mongoose.model("Note", noteSchema);

module.exports = {
  Note,
};
