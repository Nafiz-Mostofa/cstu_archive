import 'package:cstu_archive/login_direction.dart';
import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDirectionPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade100
        )
      ),
    );
  }
}
