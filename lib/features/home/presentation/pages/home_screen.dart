import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final authNotifier = ref.read(authProvider.notifier);
            await authNotifier.signOut();
            if (ref.watch(authProvider) == AuthState.unauthenticated) {
              Navigator.pushNamed(context, RouteNames.login);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Çıkış yapıldı'),
                ),
              );
            }
          },
          child: Text("Çıkış yap"),
        ),
      ),
    );
  }
}
