import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r_c_car_server/server/server_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'R/C Car Server',
      home: const ServerScreen(),
    );
  }
}
