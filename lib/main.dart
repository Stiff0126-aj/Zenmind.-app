import 'package:flutter/material.dart';
import 'package:panicaid/Pages/start_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
        body:OnboardingFlow()),
  ));
}
