import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r_c_car_cockpit/ui/cockpit/cockpit_screen.dart';

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
      title: 'R/C Car Cockpit',
      home: const CockpitScreen(),
    );
  }
}
