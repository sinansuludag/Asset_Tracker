import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Login işlemi burada yapılacak
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                // Kayıt ekranına yönlendirme
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don't have an account? Register here."),
            ),
          ],
        ),
      ),
    );
  }
}
