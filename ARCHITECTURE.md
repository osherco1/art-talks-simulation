ARCHITECTURE.md
Markdown
# Art Talks - Architecture Contract

## Single Source of Truth
This document defines the strict data models and API contracts. The IDE must not invent new fields, entities, or endpoints.

## 1. Database Schema (MongoDB / Mongoose)

### `Artwork` Collection
- `_id`: ObjectId
- `pictureName`: String (Indexed for search)
- `artist`: String (Indexed for search)
- `description`: String (Lorem ipsum text)
- `imageUrl`: String (URL to public image)

### `Message` Collection
- `_id`: ObjectId
- `artworkId`: ObjectId (Ref to Artwork)
- `text`: String
- `createdAt`: Date (Default: Date.now)

## 2. REST API Contract

### GET `/api/artworks`
- **Query Params:** `q` (optional, string) -> performs case-insensitive regex match on `pictureName` OR `artist`.
- **Response:** `200 OK`
  ```json
  [
    {
      "_id": "60d5ec...",
      "pictureName": "Starry Night",
      "artist": "Vincent van Gogh",
      "description": "Lorem ipsum...",
      "imageUrl": "https://..."
    }
  ]
GET /api/artworks/:id/messages
Response: 200 OK (Array of messages sorted by createdAt asc)

JSON
[
  {
    "_id": "71e6fd...",
    "artworkId": "60d5ec...",
    "text": "Beautiful piece!",
    "createdAt": "2026-03-11T02:22:22.000Z"
  }
]
POST /api/artworks/:id/messages
Payload:

JSON
{
  "text": "I really love the colors."
}
Response: 201 Created (Returns the created message object).

3. Frontend Architecture (Flutter + GetX)
Controllers
GalleryController: Manages the list of artworks and the current search query state. Handles debouncing of search input.

DiscussionController: Manages the selected artwork's details and the list of chat messages. Handles the optimistic UI update when submitting a new message.

Screens
GalleryScreen: Displays search bar and a responsive GridView/ListView of artwork cards.

DiscussionScreen:

Desktop/Tablet: Left side (Artwork details), Right side (Chat interface).

Mobile: Top (Artwork details), Bottom (Chat interface inside an Expanded widget).