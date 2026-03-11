const Message = require('../models/Message');
const Artwork = require('../models/Artwork');
const mongoose = require('mongoose');

async function getMessages(req, res, next) {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'Invalid artwork ID' });
    }

    const artworkExists = await Artwork.exists({ _id: id });
    if (!artworkExists) {
      return res.status(404).json({ error: 'Artwork not found' });
    }

    const messages = await Message.find({ artworkId: id })
      .sort({ createdAt: 1 })
      .lean();

    res.status(200).json(messages);
  } catch (err) {
    next(err);
  }
}

async function createMessage(req, res, next) {
  try {
    const { id } = req.params;
    const { text } = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'Invalid artwork ID' });
    }

    const artworkExists = await Artwork.exists({ _id: id });
    if (!artworkExists) {
      return res.status(404).json({ error: 'Artwork not found' });
    }

    if (!text || typeof text !== 'string' || !text.trim()) {
      return res.status(400).json({ error: 'Text is required' });
    }

    const message = await Message.create({
      artworkId: id,
      text: text.trim(),
    });

    res.status(201).json(message.toObject());
  } catch (err) {
    next(err);
  }
}

module.exports = { getMessages, createMessage };
