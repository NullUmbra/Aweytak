# Aweytak: Offline First Aid Guide

**Aweytak** (أويتك) is a mobile application designed to provide quick and reliable first-aid instructions, especially in areas where professional medical help may be delayed or unavailable. Built with an offline-first approach, it ensures that essential emergency guidance is always accessible, even without an internet connection.

## About the Project

The goal of Aweytak is to empower individuals in remote or underserved communities with life-saving knowledge. Inspired by open-access medical resources, the app presents first-aid procedures in a simplified, bilingual format suitable for non-medical users.

## Key Features

* **Offline Functionality**
  All emergency scenarios are stored on-device to guarantee accessibility without internet access.

* **Bilingual Support**
  Available in both English and Arabic for broader usability.

* **User-Centered Design**
  Light and dark themes for better visibility in all lighting conditions.

* **Organized Categories**
  Emergency topics are grouped logically for quick navigation.

* **Detailed Scenarios**
  Step-by-step instructions for burns, bleeding, choking, CPR, and more.

* **Critical Warnings and Tips**
  Each scenario includes safety warnings, do's and don'ts, and helpful context.

## Getting Started

### Prerequisites

* Flutter SDK installed
* A development environment (e.g., VS Code with Flutter plugin or Android Studio)

### Installation

Clone the repository:

```bash
git clone https://github.com/NullUmbra/Aweytak.git
cd Aweytak
```

Install dependencies:

```bash
flutter pub get
```

Generate Hive adapters:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Run the application:

```bash
flutter run
```

Ensure a connected Android device or emulator.

## License and Source Attribution

This application includes first-aid content derived from the public domain [Wikibooks First Aid Guide](https://en.wikibooks.org/wiki/First_Aid), licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

All medical information has been paraphrased and simplified for accessibility while retaining essential accuracy. The app is not certified by any medical authority and is provided for educational and emergency reference purposes only.

## Disclaimer

Aweytak is **not a substitute for professional medical care**. In life-threatening situations, users should always contact emergency services. The app is intended to assist when professional help is delayed or unreachable. The developer assumes no responsibility for outcomes resulting from its use.

## Contact

For inquiries, suggestions, or feedback:

**Email:** [kei.softcraft@gmail.com](mailto:kei.softcraft@gmail.com)

## Contributing

Contributions are welcome. If you would like to propose improvements, new features, or fixes, please submit an issue or a pull request on the GitHub repository.

## Planned Improvements

* Add more emergency scenarios and conditions
* Integrate instructional visuals and illustrations
* Add more settings options
* Expand compatibility to iOS and web

---

**Aweytak** – designed for those who need help the most, when it matters the most.

