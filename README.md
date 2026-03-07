![Quotie-Genie Hero Banner](assets/images/hero.png)

# 🧞‍♂️ Quotie-Genie

<p align="center">
  <img src="assets/images/logo.png" width="150" alt="Quotie-Genie Logo">
</p>

**Quotie-Genie** is a fully offline, cross-platform logistics machine learning application built entirely in **Flutter** (for both UI and native calculation logic). It empowers logistics and supply chain professionals to make data-driven decisions regarding quotation pricing.

## 🚀 Key Features

*   **Offline First**: Functions entirely offline via an embedded native Dart calculation engine. Data privacy is guaranteed.
*   **Predict Win Probability**: Calculate the likelihood of a customer accepting the quoted price based on historical data.
*   **Optimal Pricing**: Generate recommended prices balancing competitiveness and maximum profit margins.
*   **Actionable UI**: Instant visual indicators (Green/Red) to quickly highlight profitable quotes or low-margin risks.

## 🛠️ Architecture

Quotie-Genie uses a unified architecture built fully in Flutter, ensuring high performance on Android, iOS, and Desktop without needing external interpreters.

*   **Frontend & Logic Engine**: Flutter (Cross-Platform) & Dart
*   **Data Persistence**: SQLite (via `sqflite_common_ffi` for desktop support)

## 📋 Getting Started

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

### Installation & Run

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/your-username/quote_genie.git
   ```
2. Navigate to the project directory:
   ```bash
   cd quote_genie
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application (Mobile or Desktop):
   ```bash
   flutter run
   ```

## 📦 Building the App

To generate standalone executables or installation packages for each platform, you can use the following Flutter build commands depending on your target OS:

### Windows (EXE)
```bash
flutter build windows
```
*Outputs to: `build/windows/x64/runner/Release/quote_genie.exe`*

### Android (APK)
```bash
flutter build apk
```
*Outputs to: `build/app/outputs/flutter-apk/app-release.apk`*

### Android (AppBundle / Play Store)
```bash
flutter build appbundle
```
*Outputs to: `build/app/outputs/bundle/release/app-release.aab`*

### iOS (IPA)
```bash
flutter build ipa
```
*(Requires Xcode & macOS)*

### macOS (App)
```bash
flutter build macos
```
*(Requires Xcode & macOS. Outputs to: `build/macos/Build/Products/Release/`)*

### Linux
```bash
flutter build linux
```
*(Outputs to: `build/linux/x64/release/bundle/`)*
