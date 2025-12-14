# 🚦 Personal Traffic Monitor

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

A modern, real-time IoT application designed to monitor and count foot traffic using an ESP32-CAM and Firebase, visualized through a sleek Flutter interface.

## 📖 Overview

The **Personal Traffic Monitor** is a comprehensive solution for tracking people entering or exiting a space. It leverages an **ESP32-CAM** module to process video feeds and detect motion/people, syncing the count in real-time to **Firebase**. The mobile application, built with **Flutter**, provides a live dashboard to view the current count and sensor status instantly.

## ✨ Features

- **Real-Time Counting**: Instant updates of visitor counts synced via Firebase Realtime Database.
- **Live Video Feed**: (Experimental) Direct video stream integration from the ESP-CAM module.
- **Sensor Status**: Visual indicators to show if the IoT sensor is online and transmitting.
- **Modern UI**: A dark-mode, aesthetics-first design using Material 3 and custom gradients.
- **Cross-Platform**: Runs seamlessly on Android and iOS.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend/Database**: Firebase Realtime Database
- **Hardware/IoT**: ESP32-CAM (C++/Arduino)

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.x or higher)
- [Firebase Account](https://firebase.google.com/)
- An IDE (VS Code or Android Studio)

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/mohamedddyasserr/Personal-Traffic-Monitor.git
   cd Personal-Traffic-Monitor
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   This project uses `flutterfire` for configuration.
   ```bash
   # Install FlutterFire CLI if you haven't already
   dart pub global activate flutterfire_cli

   # Configure your project
   flutterfire configure
   ```
   *Follow the prompts to select your Firebase project and platforms.*

4. **Run the App**
   ```bash
   flutter run
   ```

## 📱 Screenshots

| Dashboard | Live Feed (Concept) |
|:---:|:---:|
| *Insert Dashboard Screenshot* | *Insert Feed Screenshot* |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
