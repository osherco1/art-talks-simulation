# Art Talks 🎨

A full-stack application featuring an interactive image gallery and real-time discussion boards for artworks. This project was developed as a time-boxed assignment, focusing on clean architecture, end-to-end functionality, and seamless user experience.

## 🏗 Tech Stack

* **Frontend:** Flutter (Dart) with **GetX** for reactive state management and routing.
* **Backend:** Node.js with **Express**.
* **Database:** MongoDB with **Mongoose** ORM.

## ✨ Key Features

1.  **Interactive Gallery:** A responsive grid displaying artworks.
2.  **Smart Search:** Real-time debounced filtering by artwork name or artist.
3.  **Discussion Board:** A chat interface for each artwork.
4.  **Responsive Design:** Adapts fluidly between mobile (stacked) and desktop (side-by-side) layouts.

## 🧠 Architectural Decisions & Trade-offs

Given the time constraint of the assignment, the following strategic decisions were made to prioritize a robust, working MVP over incomplete complex features:

* **Auto-Seeding Database:** To fulfill the requirement of a "hardcoded list of pictures" while maintaining a pure full-stack flow, the backend is designed to automatically seed the MongoDB database with 5 initial artworks on startup (if the collection is empty). This eliminates the need for manual DB setup or an admin panel.
* **Optimistic UI vs. WebSockets:** Instead of introducing the integration overhead and potential flakiness of WebSockets for a simple chat feature, I implemented an **Optimistic UI** pattern in the Flutter client. When a user sends a message, it is instantly appended to the local state (UI) and sent to the backend asynchronously. This provides a "real-time" feel with zero latency for the user, while keeping the REST API stateless and robust.
* **GetX for State Management:** Chosen for its boilerplate-free reactivity and dependency injection. `GalleryController` and `DiscussionController` strictly separate business logic from the UI.
* **Debounced Search:** The gallery search implements a 500ms debounce to prevent API spamming and ensure smooth performance as the user types.

## 🚀 How to Run the Project

### Prerequisites
* [Node.js](https://nodejs.org/) installed
* [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
* [MongoDB](https://www.mongodb.com/try/download/community) running locally (default port 27017)

### 1. Start the Backend
Navigate to the backend directory, install dependencies, and start the server:
```bash
cd backend
npm install
node server.js
Note: The server runs on http://localhost:3000. On its first run, it will automatically connect to MongoDB and seed the initial artworks.

2. Start the Frontend
Open a new terminal, navigate to the frontend directory, install packages, and launch the app (Chrome is recommended for quick testing):

Bash
cd frontend
flutter pub get
flutter run -d chrome
📂 Folder Structure Highlights
backend/models/: Mongoose schemas defining the data contract (Artwork, Message).

frontend/lib/controllers/: GetX controllers handling API communication and reactive UI state.

frontend/lib/screens/: Responsive UI components using standard Material widgets.