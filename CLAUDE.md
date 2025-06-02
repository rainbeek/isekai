# Architecture

This project is an iOS and Android application written in Flutter.

- [`./android/`](/android/): Product code and project settings for Android
- [`./ios/`](/ios/): Product code and project settings for iOS
- [`./lib/`](/lib/): Product code common to all OS
  - [`./data/`](/lib/data/): Information storage and retrieval, and interaction with the OS layer
  - [`./definition/`](/lib/data/definition/): Common definitions used for information storage and retrieval, and interaction with the OS layer
  - [`./model/`](/lib/data/model/): Domain model. Place pure data structures that are not dependent on the UI, and UI-independent `Exception`, `Error`, etc.
  - [`./repository/`](/lib/data/repository/): Repository. Defines the process of retaining and retrieving information while abstracting the specific destination.
  - [`./service/`](/lib/data/service/): Service. Defines the connection to the OS and Firebase.
- [`./ui/`](/lib/ui/): Defines screen drawing and display logic.

In this app, Swift Package Manager (SPM) is enabled and used in conjunction with CocoaPods.

SPM is enabled in Flutter itself with the following command:

```bash
flutter config --enable-swift-package-manager
```

Since SPM is a beta feature, problems may occur during builds, etc.

In that case, troubleshoot by investigating any reported issues in Flutter or considering the possibility of an unknown problem.

# Development guide

## General rules

### Style

Resolve linter and compiler warnings immediately.

Always use early returns to reduce nesting.

Use `try`-`catch` statements to enclose only processes that may throw, and in the smallest possible scope.

Immediately delete unused code.

### Maintain code consistency

Implement processes with similar functions in the same flow. Check whether a similar process has already been implemented in the surrounding area, and follow it if it has been implemented.

- In particular, standardize the flow of data acquisition, conversion, and filtering.

### Maintain sufficient comments

Add comments only when necessary to clarify the intent or purpose of the code. Avoid comments if the content of the code is clear.

Describe in detail, including the reasons, particularly for important points and pitfalls.

Write comments in Japanese.

### Maintain readability of naming

Name variables to clearly indicate their purpose and content.

Use meaningful names even for temporary variables.

Use consistent naming patterns for variables that handle the same type of data.

## Rules for Flutter

### Defining the domain model

Clearly separate the domain model and place it in the appropriate file.

Define an immutable domain model using `freezed`. Use `freezed` even when using `sealed class`.

### Utilize functional programming

Use functional methods for collection operations.

- Example: `map`, `where`, `fold`, `expand`

Divide complex data transformations into multiple steps to improve readability.

When converting a collection, use a process that returns a new converted collection.

- Example: `sortedBy` in the `collection` package.

### Use `Riverpod` appropriately for state management

Use `Riverpod` for state management.

The provider is Define using code generation using the `@riverpod` annotation.

When dealing with multiple asynchronous providers, `watch` all providers first and then `await` them later to prevent state resets.

Example:

```dart
@riverpod
Future<String> currentUser(Ref ref) async {
  final data1Future = ref.watch(provider1.future);
  final data2Future = ref.watch(provider2.future);

  final data1 = await data1Future;
  final data2 = await data2Future;

  // subsequent process
}
```

### Handle errors properly

Catch asynchronous processing errors properly and notify the user.

### Build UI properly

Manage the visibility of UI elements with a dedicated state management class.

- Example: `HouseWorkVisibilities`

Implement state change logic in the presenter.

Filter data based on visibility in the provider.

Use `SingleChildScrollView` to make content scrollable if there is a possibility of a large amount of content.

Add padding that takes into account the device's safe area.

- Example: `EdgeInsets.only(left: 16 + MediaQuery.of(context).viewPadding.left, ...)`

Split widgets into classes to improve readability.

Example:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        _Content(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Header');
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Content');
  }
}
```

Separate the process into two steps: storing the widget in a local variable → assembling with margins.

Example:

```dart
Widget build(BuildContext context) {
  // Storing the widget in a local variable
  const firstText = Text('1st');
  const secondText = Text('2nd');

  // Assembling with margins
  return Column(
    children: const [
      firstText,
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: secondText,
      ),
    ],
  );
}
```

Use the colors defined in the theme.

- Example: `Theme.of(context).colorScheme.primary`.

Use the text style defined in the text theme.

- Example: `Theme.of(context).textTheme.headline6`.

Add tooltips to areas where users can operate, and consider accessibility.

The strings to display in the UI are defined during the widget construction process.

### Screen navigation

Define `MaterialPageRoute` in a static field for the screen, and use the static field and `Navigator` when transitioning to that screen.

Example:

```dart
class SomeScreen extends StatelessWidget {
  const SomeScreen({super.key});

  static const name = 'AnalysisScreen';

  static MaterialPageRoute<SomeScreen> route() =>
      MaterialPageRoute<SomeScreen>(
        builder: (_) => const SomeScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    // Screen build process
  }
}

// When transitioning
Navigator.of(context).push(SomeScreen.route);
```

## Troubleshooting

### Policy

When troubleshooting, adopt solutions in the following order of priority:

1. Apply solutions according to official documentation and guidelines
2. If a future response is planned in an official issue, wait for that response
3. Apply solutions indicated in the official issue
4. Apply solutions indicated in communities such as Stack Overflow
