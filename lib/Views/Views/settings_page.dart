import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"),),
      body: const Center(
        child: Column(
          children: [
            ListTile(title: Text("Change Theme"), onTap: null,)
          ],
        )
      ),
    );
  }
}