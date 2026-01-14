import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text("User Name", style: Theme.of(context).textTheme.headlineSmall),
            const Text("user@citycare.com"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Logout logic
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
