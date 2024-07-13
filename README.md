# Basketball Stats UI App

Welcome to the Basketball Stats UI App! This Flutter application showcases the stats of top basketball players. Below you will find the instructions to set up and run the app on an emulator.

## Features

- Display stats of top basketball players.
- User-friendly UI with player details.
- Interactive and visually appealing design.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter**: Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install).
- **Dart**: Ensure Dart is installed (it comes with Flutter).
- **Android Studio** or **VS Code**: Install your preferred code editor.
- **Emulator**: Set up an Android or iOS emulator.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yadavcodes0/basketball.git
   cd basketball
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

## Running the App

### Using Android Studio

1. **Open the project**:
   - Open Android Studio.
   - Click on `Open an existing Android Studio project`.
   - Navigate to the cloned repository and select the folder.

2. **Set up the emulator**:
   - Go to `AVD Manager` (Android Virtual Device).
   - Create a new virtual device or use an existing one.
   - Start the emulator.

3. **Run the app**:
   - Click on the `Run` button or use the shortcut `Shift + F10`.

### Using VS Code

1. **Open the project**:
   - Open VS Code.
   - Navigate to the cloned repository folder and open it.

2. **Set up the emulator**:
   - Open the command palette (`Ctrl + Shift + P` or `Cmd + Shift + P`).
   - Type `Flutter: Launch Emulator` and select the desired emulator.
   - Start the emulator.

3. **Run the app**:
   - Press `F5` or go to the Debug menu and select `Start Debugging`.

### Using the Command Line

1. **Navigate to the project directory**:

   ```bash
   cd basketball
   ```

2. **Run the emulator**:
   - For Android:

     ```bash
     flutter emulators --launch <emulator_id>
     ```

     Replace `<emulator_id>` with your emulator ID (you can list available emulators using `flutter emulators`).

   - For iOS (Mac only):

     ```bash
     open -a Simulator
     ```

3. **Run the app**:

   ```bash
   flutter run
   ```

## Project Structure

```plaintext
lib/
│
├── main.dart                  # Entry point of the application
├── player_card.dart/          # Data model for basketball players
├── player_screen.dart/        # UI screen
├── player_card_screen.dart/   # The statistics page of the player
└── widget/                    # widgets used in the other screen
```

## Contributing

Contributions are always welcome! Please follow these steps:

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Thank you for using the Basketball Stats UI App! If you have any questions, feel free to reach out.

## Contact

- GitHub: [yadavcodes0](https://github.com/yadavcodes0)
- Email: [dy22900@gmail.com](dy22900@gmail.com)