# FitTrack 

FitTrack is a mobile app developed in Flutter designed to help users track their physical activity and weight loss. The app features a clean, elegant design inspired by Apple's Cupertino style, offering a seamless, native user experience.

Data is synchronized in real time thanks to the integration with **Firebase Firestore**, while the management of the global state of the application is entrusted to **Provider**.

---

##  Main Features

* **Real-Time Activity Summary:** View your workout history (Running, Gym, etc.) retrieved directly from Cloud Firestore via `StreamBuilder`.
* **Workout Details:** Each session tracks the date, type of activity, calories burned, and precise duration (hours, minutes, and seconds).
* **Body Weight Tracking:** Record your weight daily.
* **Intuitive Graphs:** View your weight trends over time with interactive, gradient line graphs, implemented with the `fl_chart` library.
* **History Measurements:** A grid view clearly displays all historical weigh-ins stored in the database.

---

##  Technologies Used

*   **Framework:** [Flutter](https://flutter.dev/) (SDK based on Dart)
*   **UI Style:** Cupertino Widgets (iOS look & feel)
*   **Database & Backend:** [Firebase Core](https://firebase.google.com/docs/flutter/setup) & [Cloud Firestore](https://firebase.google.com/docs/firestore) (Cloud Sync and Persistence)
*   **State Management:** [Provider](https://pub.dev/packages/provider) (`ChangeNotifier` for reactive local data management)
*   **Graphs:** [fl_chart](https://pub.dev/packages/fl_chart) (For weight graph rendering)

---

## Main File Structure

* `main.dart`: Application entry point. Initializes Firebase and configures the global `ChangeNotifierProvider`.
* `attivita.dart`: Screen dedicated to summarizing physical activities and workouts, structured with a tabbed layout and live updates.
* `grafici.dart`: Screen for entering weight, displaying the time graph, and displaying the progress history grid.
* `attivita_provider.dart`: Provider for managing the local state of the activity data list.
* `firebase_options.dart`: Automatic configuration of connection parameters for Android and iOS platforms (generated via FlutterFire CLI).

---

##  Configuration & Installation

To launch the project on your local computer, follow these steps:

### Prerequisites
Make sure you have Flutter installed on your system. If not, follow the [official Flutter guide](https://docs.flutter.dev/get-started/install).

### 1. Clone the repository
```bash
git clone [https://github.com/emanuelenassisi007-cyber/FitTrack.git](https://github.com/emanuelenassisi007-cyber/FitTrack.git)
cd FitTrack
```
### 2. Install Dependencies

Run the following command in the terminal to download all the necessary packages defined in the `pubspec.yaml` file:

```bash
flutter pub get
```

### 3. Configure Firebase

The application is configured to interface with Firebase. If you want to use your own database, follow these steps:

1. Create a new project in the Firebase Console (https://google.com).
2. Enable Cloud Firestore within the project.
3. Install the FlutterFire CLI on your computer and run the command:

```bash
flutterfire configure
```

> **Note:** This command will automatically overwrite the `lib/firebase_options.dart` file with your personal database credentials.

### 4. Launch the application

Connect an emulator or physical device and launch the project with the following command:

```bash
flutter run
```

---

## ⚠️ Security Notes

> [!IMPORTANT]
> The `firebase_options.dart` file contains the backend configuration keys.

If you decide to make this repository public, be sure to adequately protect your database's read and write rules on **Cloud Firestore (Firestore Rules)**. This step is essential to prevent unauthorized access or misuse of your resources.
