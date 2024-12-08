import 'package:flutter/material.dart';
// Onboarding ekranına yönlendirme

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Splash ekranı
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.flutter_dash,
                size: 100, color: Colors.white), // Logo veya animasyon
            SizedBox(height: 20),
            Text(
              'Your App Name',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
