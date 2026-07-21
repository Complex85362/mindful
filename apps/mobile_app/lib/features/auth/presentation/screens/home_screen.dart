import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:() => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Text('Signed in as: ${user?.email?? "unknown"}'),
      )
    );
  }
}
