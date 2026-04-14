import 'package:c25k_app/screens/temp_selector_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'screens/home_screen.dart';

void main() {
  _backgroundInitialize();
  runApp(const C25KApp());
}

_backgroundInitialize() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "C25K Runner",
    notificationText: "Running in the background",
    notificationImportance: AndroidNotificationImportance.normal,
    notificationIcon: AndroidResource(
      name: 'background_icon',
      defType: 'drawable',
    ),
  );
  return await FlutterBackground.initialize(androidConfig: androidConfig);
}

class C25KApp extends StatelessWidget {
  const C25KApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C25K Runner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: TempSelectorPage(),
    );
  }
}
