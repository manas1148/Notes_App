# Flutter Notes App

A modern and feature-rich notes application built with Flutter that allows users to create, manage, and organize their notes efficiently.

## 🌟 Key Features

- **Create and Edit Notes**: Easily create new notes with titles and content
- **Categories**: Organize notes by categories for better management
- **Search Functionality**: Quick search through notes by title or content
- **Date Tracking**: Automatic date tracking for all notes
- **Sort by Date**: Notes are automatically sorted by date (most recent first)
- **Category Management**: View and filter notes by categories
- **Clean UI**: Modern and intuitive user interface
- **Local Storage**: Secure local storage using SQLite database

## 🛠️ Technologies Used

- Flutter
- SQLite (sqflite)
- Path Provider
- Material Design

## 📱 Screenshots

[Add your app screenshots here]

## 🎥 Demo Video

https://github.com/user-attachments/assets/e40cd7fe-7223-4ae6-9b19-cc5dce42d183

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio 
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/manas1148/Notes_App.git
```

2. Navigate to project directory
```bash
cd flutter-notes-app-1
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## 📝 Database Schema

The app uses SQLite database with the following schema:

```sql
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  content TEXT,
  date TEXT,
  category TEXT
)
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page].



## 👤 Author

Manas Rai Kaushik
- GitHub: github.com/manas1148/
- LinkedIn: https://www.linkedin.com/in/manas-rai-kaushik-1b4200242/

## ⭐ Show your support

Give a ⭐️ if this project helped you!

---


