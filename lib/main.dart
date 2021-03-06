import 'package:flutter/material.dart';
import 'package:podplay_flutter/app/app.dart';
import 'package:podplay_flutter/core/di/di.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}