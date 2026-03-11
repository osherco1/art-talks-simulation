const Artwork = require('../models/Artwork');
const mongoose = require('mongoose');

async function getArtworks(req, res, next) {
  try {
    const { q } = req.query;
    let filter = {};

    if (q && typeof q === 'string' && q.trim()) {
      const regex = new RegExp(q.trim(), 'i');
      filter = {
        $or: [
          { pictureName: regex },
          { artist: regex },
        ],
      };
    }

    const artworks = await Artwork.find(filter).lean();
    res.status(200).json(artworks);
  } catch (err) {
    next(err);
  }
}

module.exports = { getArtworks };
