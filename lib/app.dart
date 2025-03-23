import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.routeName,
      routes: {
        MainScreen.routeName: (_) => const MainScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
    );
  }
}