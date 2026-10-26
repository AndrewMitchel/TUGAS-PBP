# ☕ CoffeeSpot — Coffee Finder App

**CoffeeSpot** is a café discovery application built with Flutter. The application helps users explore cafés, view café details, discover available facilities, and find café locations through Google Maps.

🌐 **Live Demo:** [CoffeeSpot on GitHub Pages](https://andrewmitchel.github.io/TUGAS-PBP/)

📦 **Repository:** [AndrewMitchel/TUGAS-PBP](https://github.com/AndrewMitchel/TUGAS-PBP)

---

## ✨ Features

- **User Login** — Enter the application through the login page.
- **Explore Cafés** — Browse a collection of cafés and discover places to visit.
- **Café Details** — View café information, ratings, distance, images, and descriptions.
- **Café Facilities** — Discover facilities such as Wi-Fi, power outlets, and air conditioning.
- **Café Categories** — Explore information related to coffee, food, and Wi-Fi availability.
- **Favorites** — Access the favorites section of the application.
- **Google Maps Integration** — Open a café's location in Google Maps using the *View Location* button.
- **User Profile** — Access the profile section through the application's navigation.
- **Flutter Web Support** — Run the application in a browser and deploy it to GitHub Pages.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Application development framework |
| Dart | Programming language |
| Material Design | User interface components |
| Google Maps | Café location navigation |
| GitHub Pages | Web application hosting |

## 📱 Application Screens

The application includes the following main screens:

1. **Login Page** — The entry page for users.
2. **Explore Page** — Displays the café discovery interface.
3. **Café Detail Page** — Presents café information, images, ratings, facilities, and location access.
4. **Favorites Page** — The section for accessing favorite cafés.
5. **Profile Page** — The user profile interface.

## 🚀 Getting Started

### Prerequisites

Make sure the following tools are installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- [Visual Studio Code](https://code.visualstudio.com/) or Android Studio
- An Android emulator, physical Android device, or web browser

Verify your Flutter installation:

```bash
flutter doctor
```

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/AndrewMitchel/TUGAS-PBP.git
   ```

2. Navigate to the project directory:

   ```bash
   cd TUGAS-PBP
   ```

3. Install the project dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

To run the application in Google Chrome:

```bash
flutter run -d chrome
```

## 🌐 Build and Deploy to GitHub Pages

CoffeeSpot can be built for web and deployed using GitHub Pages.

### Build for Web

Run the following command from the project root:

```bash
flutter build web --release --base-href "/TUGAS-PBP/"
```

The production build will be generated in:

```text
build/web
```

### Live Application

Visit the deployed application:

**https://andrewmitchel.github.io/TUGAS-PBP/**

The web deployment requires GitHub Pages to be configured correctly for the repository.

## 📂 Project Structure

```text
TUGAS-PBP/
├── assets/
│   └── images/          # Café images and visual assets
├── lib/                 # Flutter application source code
├── android/             # Android platform configuration
├── ios/                 # iOS platform configuration
├── web/                 # Web platform configuration
├── linux/               # Linux platform configuration
├── macos/               # macOS platform configuration
├── windows/             # Windows platform configuration
├── pubspec.yaml         # Dependencies and asset configuration
├── pubspec.lock         # Locked dependency versions
└── README.md            # Project documentation
```

## 🎯 Project Objectives

CoffeeSpot was developed as a Flutter application project to demonstrate cross-platform application development, user interface design, navigation between screens, café information presentation, and integration with external map services.

The application provides a simple way for users to discover cafés and review relevant information before visiting a location.

## 👨‍💻 Author

**Andrew Mitchel**

GitHub: [@AndrewMitchel](https://github.com/AndrewMitchel)

## 📄 License

This project was developed for educational purposes as part of a university programming assignment.
