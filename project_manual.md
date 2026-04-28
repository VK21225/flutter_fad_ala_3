# Quick Notes - Project Workflow Manual

## Overview
**Quick Notes** is a simple, aesthetically pleasing note-taking application built with Flutter. It utilizes the `shared_preferences` package to provide persistent local storage for note data. The application features a modern, clean UI design, emphasizing user experience without compromising simplicity.

## Application Architecture

The application adopts a standalone Model-View-Controller pattern integrated within a single Dart file (`main.dart`), suitable for lightweight utilities.

### 1. Model (`Note`)
The data model for a single note item.
- **Attributes**: `id` (String), `title` (String), `content` (String), and `updatedAt` (DateTime).
- **Serialization**: Contains `toJson()` and factory constructor `Note.fromJson()` to facilitate converting data into a JSON string format suitable for local storage.

### 2. View/UI
The Views consist of two primary screens:
- **`NotesListScreen`**: The default screen that loads existing notes. It uses a `ListView.builder` inside a `Scaffold` background, offering a premium and minimalist dark-mode aesthetic. Notes are displayed as floating material cards. Notes can be deleted easily via a swipe-to-dismiss gesture (`Dismissible` widget).
- **`NoteEditorScreen`**: Provides text fields for title and content. Upon pressing back or the save icon, the screen attempts to save the note automatically and passes it back to the `NotesListScreen`.

### 3. Logic & State Management
State transitions are handled via Flutter's core `StatefulWidget` mechanisms and asynchronous Dart methods (`async` / `await`).

#### Local Storage Integration (`shared_preferences`)
The application relies heavily on saving and retrieving a global list of Note models serialized to a JSON string.

1.  **Loading Notes (`_loadNotes`)**:
    When the application initially loads, it accesses the SharedPreferences instance and attempts to read the JSON string mapped to the `'notes'` key. If successful, it decodes the JSON data, instantiates an array of `Note` objects, sorts them by their `updatedAt` property, and calls `setState()` to update the UI.

2.  **Saving Data (`_saveNotes`)**:
    Invoked whenever a modified, added, or deleted note occurs. It transforms the active List of Note objects back into a complex JSON array format (`json.encode`), and stores it back to the `'notes'` key, overwriting the old data.

## Workflow Pipeline
1.  **Startup**: Launch the app. State is initialized, and `shared_preferences` retrieves `.json` cache.
2.  **Creation**: User clicks the `FloatingActionButton`. `Navigator.push` brings up the editor. Upon editing and returning, a new `Note` model is instantiated, injected into the main List, and saved.
3.  **Viewing/Updating**: User taps an existing `Note` card. Data is populated into the editor. Adjusting and returning triggers a replacement in the array by match index, then saved.
4.  **Deletion**: User swamps a card Left -> Right. `removeAt` strips the index from the array and calls save.
