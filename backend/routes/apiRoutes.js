const express = require('express');
const router = express.Router();
const { getArtworks } = require('../controllers/artworkController');
const { getMessages, createMessage } = require('../controllers/messageController');

// GET /api/artworks - optional query param: q (search on pictureName OR artist)
router.get('/artworks', getArtworks);

// GET /api/artworks/:id/messages - messages sorted by createdAt asc
router.get('/artworks/:id/messages', getMessages);

// POST /api/artworks/:id/messages - payload: { text: string }
router.post('/artworks/:id/messages', createMessage);

module.exports = router;
