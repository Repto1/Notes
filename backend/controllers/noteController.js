const { Note: NoteModel } = require("../models/noteModel");

const noteController = {
  create: async (req, res) => {
    try {
      const note = {
        title: req.body.title,
      };

      const response = await NoteModel.create(note);

      res.status(201).json({ response });
    } catch (error) {
      console.log(error);
    }
  },
  getAll: async (req, res) => {
    try {
      const notes = await NoteModel.find();

      res.json(notes);
    } catch (error) {
      console.log(error);
    }
  },

  get: async (req, res) => {
    try {
      const id = req.params.id;
      const note = await NoteModel.findById(id);

      if (!note) {
        res.status(404).json({ msg: "nota nao encontrada" });
        return;
      }

      res.json(note);
    } catch (error) {
      console.log(error);
    }
  },

  delete: async (req, res) => {
    try {
      const id = req.params.id;

      const note = await NoteModel.findById(id);

      if (!note) {
        res.status(404).json({ msg: "nota nao encontrada" });
        return;
      }

      const deleteNote = await NoteModel.findByIdAndDelete(id);

      res.status(200).json({ deleteNote, msg: "apagado com sucesso" });
    } catch (error) {
      console.log(error);
    }
  },

  update: async (req, res) => {
    const id = req.params.id;
    const note = {
      title: req.body.title,
    };

    const updateNote = await NoteModel.findByIdAndUpdate(id, note);

    if (!updateNote) {
      res.status(404).json({ msg: "nota nao encontrada" });
      return;
    }

    res.status(200).json({ msg: "Nota Atualizda!" });
  },
};

module.exports = noteController;
