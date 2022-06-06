import 'package:flutter/material.dart';
import 'package:podplay_flutter/app/app.dart';
import 'package:podplay_flutter/core/di/di.dart';

void main() {
  configureDependencies();
  runApp(const App());
}