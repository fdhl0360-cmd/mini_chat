import 'package:flutter/material.dart';

void main() {
  runApp(const MiniChatApp());
}

class MiniChatApp extends StatelessWidget {
  const MiniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Chat',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Chat'),
      ),
      body: const Center(
        child: Text(
          'مرحباً بك في Mini Chat 👋',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
