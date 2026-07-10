# Complete Flutter Development Course

> A practical, project-based repository for learning Dart and Flutter, from first principles to intermediate Flutter concepts.

This repository contains course notes, small Dart programs, focused Flutter exercises, and complete Flutter projects. It is organized by learning section, so you can work through the material in order or open an individual project and run it independently.

## What you will learn

- Set up a Flutter development environment
- Write Dart programs using variables, collections, control flow, functions, and object-oriented programming
- Understand constructors, inheritance, abstraction, generics, exception handling, and asynchronous code
- Build Flutter interfaces with layouts, navigation, input controls, and stateful widgets
- Create practical apps, including a to-do app and an e-commerce app
- Implement light and dark themes with persisted theme preferences

## Repository structure

```text
.
|-- Section-1 Introduction/
|   |-- 1 Introduction/
|   |-- 2 Course Overview/
|   |-- 3 Resources/
|   |-- 4 Overview of mobile development technologies/
|   `-- 5 Introduction Of Flutter/
|-- Section-2 Setups/
|-- Section-3 Dart Programming Fundamental/
|-- Section-4 Flutter Programming Fundamentals/
|   |-- flutter_programming_fundamentals/
|   |-- input/
|   |-- stateless_vs_statefull_widgets/
|   `-- Projects/
|       |-- todo_app/
|       `-- Ecommerce_App/ecommerce_app/
`-- Section-5 Intermediate Level/
    `-- 1-Theme/theme/
```

## Course outline

### Section 1 - Introduction

Introduces the course, available resources, the mobile development landscape, and Flutter itself.

### Section 2 - Setups

Contains material for preparing a Flutter development environment.

### Section 3 - Dart Programming Fundamentals

Standalone Dart files that cover:

- Basics: first program, variables, user input, comments, data types, keywords, operators, and constants
- Collections and control flow: lists, sets, maps, conditions, switch statements, and loops
- Functions and classes: functions, OOP, classes and objects, constructors, `this`, and static members
- Object-oriented design: inheritance, access modifiers, super constructors, getters/setters, and abstraction
- Advanced language features: exceptions, typedefs, generics, callable classes, and async/await

### Section 4 - Flutter Programming Fundamentals

Introduces core Flutter concepts through focused examples and projects:

- Widget layouts, common Material widgets, navigation routes, lists, grids, and gesture handling
- Form and text input with a simple to-do interface
- Stateless versus stateful widgets through a counter example
- Larger practice apps, including to-do and e-commerce projects

### Section 5 - Intermediate Level

Builds on the fundamentals with a theme-switching application that supports light and dark modes and stores the selected preference.

## Flutter projects

Every directory below is an independent Flutter application with its own `pubspec.yaml`.

| Project | Location | Demonstrates |
| --- | --- | --- |
| Flutter fundamentals | `Section-4 Flutter Programming Fundamentals/flutter_programming_fundamentals` | Material widgets, layouts, named routes, lists, grids, and gestures |
| Input to-do example | `Section-4 Flutter Programming Fundamentals/input` | Text input and a simple to-do UI |
| Counter example | `Section-4 Flutter Programming Fundamentals/stateless_vs_statefull_widgets` | Stateful widgets and counter state |
| To-do app | `Section-4 Flutter Programming Fundamentals/Projects/todo_app` | Task management with local database initialization |
| E-commerce app | `Section-4 Flutter Programming Fundamentals/Projects/Ecommerce_App/ecommerce_app` | Product browsing, cart management, quantity controls, coupons, and order summary |
| Theme app | `Section-5 Intermediate Level/1-Theme/theme` | Light/dark themes and persisted theme preference |

## Prerequisites

Install the following before running the examples:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- An editor such as [Visual Studio Code](https://code.visualstudio.com/) or Android Studio with the Flutter and Dart extensions/plugins
- An Android/iOS emulator, a connected device, Windows desktop support, or a supported browser

Confirm that your environment is ready:

```bash
flutter doctor
```

## Run a Flutter project

1. Open a terminal at the repository root.
2. Change to the project you want to run. For example:

   ```bash
   cd "Section-4 Flutter Programming Fundamentals/Projects/Ecommerce_App/ecommerce_app"
   ```

3. Download dependencies:

   ```bash
   flutter pub get
   ```

4. Start the app on a selected device:

   ```bash
   flutter run
   ```

To see the devices Flutter can target, run `flutter devices`. To launch in Chrome, use `flutter run -d chrome`.

## Run a Dart lesson

The Dart exercises are in `Section-3 Dart Programming Fundamental`. Change into that directory and run the desired file:

```bash
cd "Section-3 Dart Programming Fundamental"
dart run 1-First-Program.dart
```

Replace `1-First-Program.dart` with any lesson filename, such as `18-Loops.dart` or `34-Async-&-Await.dart`.

## Test a Flutter project

From inside a Flutter project directory, run:

```bash
flutter test
```

## Contributing

Contributions that improve explanations, examples, documentation, or projects are welcome.

1. Fork the repository and create a branch.
2. Keep changes focused on the relevant course section or project.
3. Run `dart format .` and the relevant `flutter test` command before opening a pull request.
4. Describe what you changed and why.

## License

No license has been specified for this repository. Contact the repository owner before reusing its content outside personal learning purposes.
