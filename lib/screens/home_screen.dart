import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      child: ElevatedButton(
          onPressed: () {
            Auth().signOut();
          },
          child: Text("Sign out")),
    );
  }
}
