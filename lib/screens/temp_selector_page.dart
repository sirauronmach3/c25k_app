import 'package:c25k_app/screens/cadence_screen.dart';
import 'package:c25k_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class TempSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperature Selector')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scheduled Run', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Text('Home Screen'),
            ),
            SizedBox(height: 20),
            Text("Cadence setter", style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadenceScreen()),
                );
              },
              child: Text('Cadence Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
