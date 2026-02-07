## Project YP

### A Flutter Mobile Concept-Sharing Application

This project was developed as part of a college app development course. The goal was to **design and implement a centralized platform where fans can create, share, and explore custom Yu-Gi-Oh and Pokémon concepts**, all in one mobile experience.

---

## Project Overview

Project YP provides a creative space for anime, trading card game, and design enthusiasts to showcase original card concepts.

The application allows users to:

Register and log in securely

Browse Pokémon and Yu-Gi-Oh concepts

Create custom card concepts using guided forms

Upload and share designs

Like and comment on concepts

Manage user profiles

The long-term vision is to offer an all-in-one mobile platform for Yu-Gi-Oh and Pokémon fans 

---

## Project Scope & Objectives

The main objectives of this project were:

- Build a working Flutter mobile app from scratch

- Implement Firebase authentication and data storage

- Demonstrate API integration

- Support CRUD-style concept creation

- Practice UI design consistency

- Apply Git version control collaboratively

- Focus on quality core features rather than feature quantity

- Design a responsive admin dashboard

- Improve usability with search, filters, and feedback messages

Advanced features (real-time chat, notifications) were intentionally excluded due to time constraints and course scope 

---

## Technologies Used

- Flutter (Dart)

- Android Studio

- Firebase (authentication + database)

- Pokémon Showdown API

- Material Icons

- GitHub

- Figma (UI Prototypes)

- Yu-Gi-Oh Cards API 

---

## Core Features

### Authentication

- User registration and login 

- Google sign-in

- Firebase authentication

### Concept Sharing

- Create Pokémon and Yu-Gi-Oh card concepts

- Upload images

- Explore community creations with search and filtering cards

- Like and comment on cards

### User Experience

- Profile pages

- Navigation between Pokémon and Yu-Gi-Oh sections

- Discover feed

- Personal “My Concepts” area 

### Data Storage (Firebase)

The database stores:

- Users & login data

- User profiles

- Pokémon concepts & images

- Yu-Gi-Oh concepts & images

- Likes and comments

---

## Project Files
```
project-yp/
├── android/                # Android platform files
├── ios/                    # iOS platform files
├── linux/                  # Linux desktop support
├── macos/                  # macOS desktop support
├── windows/                # Windows desktop support
├── web/                    # Web build support
├── test/                   # Unit and widget tests
│
├── assets/                 # Images and static assets
│
├── lib/                    # Main Flutter application source
│   ├── models/            # Data models (Pokemon, Yu-Gi-Oh, Users)
│   ├── views/             # UI screens (login, register, discover, profile, create)
│   ├── services/          # Firebase + API services
│   ├── widgets/           # Reusable UI components
│   └── main.dart          # Application entry point
│   └── constants          # API usage for links
│   └── view_models        # Connection between models and views
│   └── dependencies.dart  # links to packages to organize import and export
│   └── firebase_options.dart       
│   └── nav.dart           # navigation bar
│   └── pages.dart         # links to pages/files(views,models,viewmodels,etc) to organize import and export
├── .flutter-plugins
├── .gitattributes
├── .gitignore
├── .metadata
│
├── ProjectYP_Presentation.pdf
├── README.md
├── analysis_options.yaml
├── app-release.apk        # Release APK
├── firebase.json
├── pubspec.yaml
├── pubspec.lock
└── query/                 # API queries / helpers

        
```
---

## Target Users

This application was designed for: 

Anime, video game, and trading card game fans

Artists and designers

Game theorists

Competitive players

Collectors who want to showcase custom decks 

## Notes

How to Run (Android Studio)

Requirements for running on Android Studio

- Flutter SDK

- Android Studio

- Android emulator or physical device

- Internet connection (Firebase + APIs)

Steps:

1. Open the project in Android Studio
2. Run: ``` flutter pub get ```
3. Start an emulator or connect a physical Android device
4. Press Run after choosing the platform to run on (i.e, Chrome, Windows, Pixel 6a)

APK 
The release APK that can run the app on android after download is included in:
``` project-yp/ ```
or 
```build/app/outputs/flutter-apk/app-release.apk```

Team Members
> Cheng Yu, Meerab 2025
