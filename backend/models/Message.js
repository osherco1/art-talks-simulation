const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  artworkId: { type: mongoose.Schema.Types.ObjectId, ref: 'Artwork', required: true },
  text: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Message', messageSchema);
