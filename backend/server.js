require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const apiRoutes = require('./routes/apiRoutes');
const Artwork = require('./models/Artwork');

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// API routes
app.use('/api', apiRoutes);

// Global Error Handling Middleware (must be last)
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/app';

const DUMMY_ARTWORKS = [
  { pictureName: 'Starry Night', artist: 'Vincent van Gogh', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', imageUrl: 'https://picsum.photos/seed/starry1/400/300' },
  { pictureName: 'The Persistence of Memory', artist: 'Salvador Dalí', description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', imageUrl: 'https://picsum.photos/seed/dali1/400/300' },
  { pictureName: 'The Scream', artist: 'Edvard Munch', description: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.', imageUrl: 'https://picsum.photos/seed/scream1/400/300' },
  { pictureName: 'Girl with a Pearl Earring', artist: 'Johannes Vermeer', description: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', imageUrl: 'https://picsum.photos/seed/vermeer1/400/300' },
  { pictureName: 'The Birth of Venus', artist: 'Sandro Botticelli', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim.', imageUrl: 'https://picsum.photos/seed/venus1/400/300' },
];

async function seedIfEmpty() {
  const count = await Artwork.countDocuments();
  if (count === 0) {
    await Artwork.insertMany(DUMMY_ARTWORKS);
    console.log('Seeded 5 dummy artworks');
  }
}

async function start() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('MongoDB connected');
    await seedIfEmpty();
  } catch (err) {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  }

  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

start();
