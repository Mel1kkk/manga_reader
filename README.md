# Tokyo Ghoul Manga Reader 📖  

This is a mobile app for reading *Tokyo Ghoul* manga. It uses **MangaDex API** to fetch manga data like chapters, images and titles.  

## Features ✨  

- **Read Manga**: Browse and read *Tokyo Ghoul* chapters easily.  
- **Dark & Light Theme**: Choose between **black** and **white** themes. The app remembers your choice even after you leave.  
- **Last Opened Chapter**: The app saves the last chapter you read and shows it on the home screen. Click it to continue reading.
- **Smooth Image Loading**: Uses CachedNetworkImage for efficient and fast loading of manga pages.
- **Secure API Keys**: API keys are hidden using .env and not committed to Git.  

## How It Works ⚙️  

- **Fetching Data**:  
  - Uses **HTTP** requests to fetch manga data (images, titles, chapters, etc.) from the **MangaDex API**.  
  - Then data is stored and managed with **Provider**.  

- **Providers Used**:  
  - `ThemeProvider` - Manages the app's theme (light/dark).  
  - `ChapterProvider` - Handles the list of chapters on the home screen.  
  - `MangaurlProvider` - Loads manga images.  
  - `LastOpenedChapterProvider` - Saves and displays the last chapter you opened.

- **Image Optimization**:
  - **CachedNetworkImage** is used to cache and preload manga images, reducing load times and improving performance.

- **Storage**:  
  - `SharedPreferences` is used to **remember** the last opened chapter and selected theme.