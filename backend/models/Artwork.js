const mongoose = require('mongoose');

const artworkSchema = new mongoose.Schema({
  pictureName: { type: String, required: true, index: true },
  artist: { type: String, required: true, index: true },
  description: { type: String, required: true },
  imageUrl: { type: String, required: true },
});

module.exports = mongoose.model('Artwork', artworkSchema);
