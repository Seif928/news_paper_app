# Product Requirements Document (PRD) - Newspapers App

## Overview
Newspapers App is a mobile and web news application built using Flutter. It provides users with live news, categories, article details, bookmarking capabilities, user authentication, customizable themes, and localization.

## Core Features

### 1. User Authentication
- **User Login**: Login using email/password or third-party providers (Google/Facebook).
- **User Registration**: Sign up with email and password.
- **Session Management**: Persistent auth state using Firebase Auth.

### 2. News Feed & Navigation
- **Home Screen**: Browse top news headlines grouped by categories (e.g., General, Business, Technology, Sports, Entertainment, Health, Science).
- **Article Details**: View full content, cover image, author, publication date, and external link to original article.

### 3. Search
- **Keyword Search**: Search news articles by query string with real-time results.

### 4. Saved Articles (Bookmarks)
- **Bookmark Article**: Save articles for offline reading.
- **Remove Bookmark**: Delete saved articles from local storage (Hive).
- **Saved List**: View all bookmarked articles in a dedicated list screen.

### 5. Settings & Customization
- **Theme Support**: Switch between Light and Dark themes dynamically using BLoC.
- **Localization**: Support English (`en`) and Arabic (`ar`) languages.
- **Privacy Policy**: View application privacy policy details.

### 6. Notifications
- **In-App Notifications**: Notification screen listing received alerts.
- **Push Notifications**: Firebase Cloud Messaging (FCM) and local notification integration.
