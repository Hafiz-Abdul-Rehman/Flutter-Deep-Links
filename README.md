# Deep Linking in Flutter: A Comprehensive Guide

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)](https://dart.dev)
[![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen.svg)](https://opensource.org/)
[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME?style=social)](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME?style=social)](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME)](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME/issues)
[![GitHub Pull Requests](https://img.shields.io/github/pulls/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME)](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME/pulls)

This repository provides a clear and practical implementation of deep linking in Flutter applications. Deep linking allows users to navigate directly to specific content within your app from external sources like websites, emails, or other apps. This enhances the user experience and makes sharing and accessing content much more seamless.

## What's Inside?

This repository contains a well-structured Flutter project demonstrating various aspects of deep linking, including:

* **Basic Deep Linking:** Handling simple URL schemes to open the app on a specific screen.
* **Parameter Handling:** Extracting and utilizing parameters passed through the deep link URL.
* **Platform Configuration:** Clear instructions and code snippets for setting up deep linking on both Android and iOS.
* **Navigation Logic:** Examples of how to navigate to different parts of your app based on the deep link.
* **Error Handling:** Basic strategies for managing invalid or malformed deep links.
* **Universal Links (iOS) and App Links (Android):** Demonstrating how to use standard web links to open your app without the need for a disambiguation dialog.

## Getting Started

Follow these steps to get this deep linking example up and running on your local machine:

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/Hafiz-Abdul-Rehman/Flutter-Deep-Links.git
    cd Flutter-Deep-Links
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Platform Setup:**

    * **Android:**
        * Open the `android/app/src/main/AndroidManifest.xml` file.
        * Locate the `<activity>` tag for your main activity.
        * Add an `<intent-filter>` within the `<activity>` tag to handle your custom URL scheme. Replace `your_scheme` and `your_host` with your desired values:

            ```xml
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="your_scheme" android:host="your_host" />
            </intent-filter>
            ```

        * **(For App Links - Optional):** You'll need to associate your app with your website by uploading a `assetlinks.json` file to your domain's `/.well-known/` directory and configure the `android:autoVerify="true"` attribute in your `AndroidManifest.xml`. Refer to the official Flutter documentation for detailed instructions.

    * **iOS:**
        * Open the `ios/Runner.xcworkspace` file in Xcode.
        * Go to your project's target, select the **Info** tab.
        * In the **URL Types** section, click the **+** button.
        * Enter a unique **Identifier** (e.g., `com.yourbundleid.deeplink`).
        * In the **URL Schemes** array, add your desired custom URL scheme (e.g., `your_scheme`).

        * **(For Universal Links - Optional):** You'll need to associate your app with your website by creating an `apple-app-site-association` file and uploading it to your domain's root or `/.well-known/` directory. You also need to configure the **Associated Domains** entitlement in your Xcode project. Refer to the official Flutter documentation for detailed instructions.

4.  **Run the App:**

    ```bash
    flutter run
    ```

5.  **Testing Deep Links:**

    * **Android:** You can use the `adb` command in your terminal to simulate opening a deep link:

        ```bash
        adb shell am start -W -a android.intent.action.VIEW -d "your_scheme://your_host/some/path?param=value" your_package_name
        ```

      Replace `your_scheme`, `your_host`, `some/path`, `param=value`, and `your_package_name` with your actual values.

    * **iOS:** You can use the `xcrun` command in your terminal or open a link in Safari (for Universal Links):

        ```bash
        xcrun simctl openurl booted "your_scheme://your_host/some/path?param=value"
        ```

      Replace the placeholders with your actual values.

## Code Highlights

The main logic for handling deep links typically resides in your `main.dart` file or a dedicated service class. You'll likely use the `uri_links` package (or similar) to listen for incoming deep link events.

```dart
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _latestLink;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  Future<void> _initUniLinks() async {
    // Handle initial link if the app was launched with a deep link
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      setState(() {
        _latestLink = initialLink;
      });
      _handleDeepLink(Uri.parse(initialLink));
    }

    // Listen for subsequent deep link events
    linkStream.listen((String? link) {
      if (link != null) {
        setState(() {
          _latestLink = link;
        });
        _handleDeepLink(Uri.parse(link));
      }
    }, onError: (err) {
      print('Error receiving URI: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    // Example of handling different paths and parameters
    if (uri.pathSegments.contains('profile')) {
      String? userId = uri.queryParameters['id'];
      if (userId != null) {
        // Navigate to the user's profile page with the given ID
        print('Navigating to profile with ID: $userId');
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)));
      }
    } else if (uri.pathSegments.contains('product')) {
      String? productId = uri.queryParameters['id'];
      if (productId != null) {
        // Navigate to the product details page
        print('Navigating to product with ID: $productId');
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(productId: productId)));
      } else {
        // Navigate to the general products page
        print('Navigating to products page');
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductsScreen()));
      }
    } else {
      // Handle other deep links or navigate to the home screen
      print('Received unknown deep link: $uri');
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Linking Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Deep Linking Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Latest Deep Link:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                _latestLink ?? 'No deep link received yet.',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Try opening the app via a deep link!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
