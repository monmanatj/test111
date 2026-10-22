// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'screens/meal_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MealProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Expense Tracker',
      home: MealListScreen(), // เปลี่ยนเป็นหน้าจอหลัก
    );
  }
}
