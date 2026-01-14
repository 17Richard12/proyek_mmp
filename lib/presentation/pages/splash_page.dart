import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_city, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text('CityCare', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            const Text('Making Cities Sustainable'),
          ],
        ),
      ),
    );
  }
}
