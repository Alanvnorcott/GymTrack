//home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Workout'),
      ),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
